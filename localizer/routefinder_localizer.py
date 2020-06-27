import os, sys
import numpy as np

import random
import torch
import time
import math
import cv2

from tqdm import tqdm
from PIL import Image
import scipy.io as sio
from matplotlib import pyplot as plt
from sklearn.metrics import pairwise_distances
from itertools import compress
import multiprocessing

from localizer import BaseLocalizer

class RouteFinderLocalizer(BaseLocalizer):
    """ This class implements methods commun for ES and BSD route finding """
    def __init__(self, opt):
        BaseLocalizer.__init__(self, opt)
        self.opt = opt
        if self.opt.seed >= 0:
            np.random.seed(self.opt.seed)     
            random.seed(self.opt.seed)
        self.source_domain, self.target_domain = self.opt.direction
        print('source domain: {} target_domain {}'.format(self.source_domain, self.target_domain))
    
    def load_test_routes(self, cfg):
        # Load test routes into memory
        filename = '{}_routes_500_60.mat'.format(cfg['dataset'])
        path = os.path.join('Localisation', 'test_routes', filename)
        self.test_routes = sio.loadmat(path)['test_route'][0:self.opt.num_test_routes,:self.opt.max_route_length] - 1
        if self.opt.verbose > 0:
            print("Loaded test routes from ", path, "shape", self.test_routes.shape)
        
        if not self.opt.no_turns:
            filename = '{}_turns_500_{}.mat'.format(cfg['dataset'], self.opt.turn_threshold)
            path = os.path.join('Localisation', 'test_routes', filename)
            self.test_turns = sio.loadmat(path)['test_turn'][:self.opt.num_test_routes,:self.opt.max_route_length]            
            if self.opt.verbose > 0:
                print("Loaded test routes from ", path, "shape", self.test_turns.shape)

        self.num_nodes = self.routes.shape[-1]

   
    def RRextend(self, R_, dist_):
        nr, nc = R_.shape
        R = np.zeros((nr*5,nc+1),dtype=np.int16) #preallocate
        dist = np.zeros(nr*5,)
        index = 0
        
        for i in range(nr):
            idx = R_[i,-1]
            neighbors = self.routes['neighbor'][0,idx].reshape(-1) - 1 # -1 is because python uses 0-based indexes

            for neighbor in neighbors:
                if neighbor not in R_[i,:]:

                    R[index,:] = np.append(R_[i,:], neighbor)  
                    dist[index] = dist_[i]
                    index += 1
        
        R = R[:index, :]
        dist = dist[:index]
        return R, dist

    def turn_filter(self, route_index, m, R_, dist_):
        turn = self.test_turns[route_index, m-1]
        T_ = np.zeros((R_.shape[0],), dtype=np.int16)

        for i in range(R_.shape[0]):
            idx1, idx2 = R_[i,m-1], R_[i,m]
            theta1 = self.routes['gsv_yaw'][0,idx1].astype(np.float32).reshape(-1)
            theta2 = self.routes['gsv_yaw'][0,idx2].astype(np.float32).reshape(-1)
            if theta1.size == 0 or theta2.size == 0: 
                T_[i] = 3
            else:
                turn_ = theta2 - theta1
                if turn_ > 180:
                    turn_ -= 360
                elif turn_ < -180:
                    turn_ += 360
                T_[i] = 1 if (abs(turn_) > self.opt.turn_threshold) else 0

        k = np.argwhere(T_ == turn).reshape(-1)
        R_ = R_[k,:]
        dist_ = dist_[k]
        return R_, dist_ 

    def localize_route(self, route_index):
        R = np.arange(0,self.num_nodes, dtype=np.int16).reshape(-1,1)
        distances = np.zeros((self.num_nodes,))
        route_ranking = []
        route_ranking = np.zeros((self.opt.max_route_length,))

        for m in range(self.opt.max_route_length):
            gt_index = self.test_routes[route_index,m] # Observation gt_index

            # ------ filters ------------------------------
            if m > 0 and not self.opt.no_turns:
                R, distances = self.turn_filter(route_index, m, R, distances)                                  
                
            if R.shape[0] == 0: 
                break
            
            R_, dist_ = self.distance_filter(gt_index, R, distances)   # This method should be implemented in subclass ES or BSD
            
            # ------ extend -------------------------------
            if m < self.opt.max_route_length-1:
                R, distances = self.RRextend(R_, dist_)

            # ------ top-k accuracy -----------------------
            k = min(R_.shape[0], self.opt.topk)
            low = max(m - self.opt.overlap + 1, 0)
            high = m + 1 
            gt = self.test_routes[route_index,low:high]
            best_estimated_routes = R_[0:k,low:high]

            comp = [np.array_equal(row, gt) for row in best_estimated_routes]
            is_in_top_k = any(comp)                    
            
            ind = list(compress(range(len(comp)), comp))
            rank = ind[0] + 1 if is_in_top_k else 0
            route_ranking[m] = rank
            #route_ranking.append(rank)
                
            if self.opt.verbose > 2:
                message = 'route {} step {} rank {} routes {}'.format(route_index, m, rank, R_.shape[0])
                print(message)
        
        route_ranking = np.stack(route_ranking, 0)
        if self.opt.verbose > 1:
            message = 'route {} final rank {}'.format(route_index, rank)

        return route_ranking

    def localize(self):   
        """ Perform route_searching algorithm """
        
        experiment_start_time = time.time()  # timer for entire epoch
        experiment_rankings = []


        for net in self.opt.networks: 
            nets_rankings = []   
            for dataset in self.opt.datasets:
                dataset_rankings = [] 

                message = '-'*5+'localizing dataset {} and features from net {}'.format(dataset, net) + '-'*5
                print(message)

                cfg = {'network': net, 'dataset':dataset}
                self.setup(cfg)                                     # This methods should be implemented in subclass
                route_indexes = np.arange(0,self.opt.num_test_routes) if self.opt.routes is None else self.opt.routes
                
                for route_index in tqdm(route_indexes):
                    route_ranking = self.localize_route(route_index)
                    dataset_rankings.append(route_ranking)
                
                ranking = np.stack(dataset_rankings, axis=0)
                nets_rankings.append(ranking)
            
            ranking = np.stack(nets_rankings, axis=0) 
            experiment_rankings.append(ranking)
        
        self.ranking = np.stack(experiment_rankings, axis=0) 

        if self.opt.save:
            filename = '{}_{}.npy'.format(self.opt.name, self.opt.seed)
            path = os.path.join(self.opt.results_dir, filename)
            np.save(path, self.ranking)
            print('results saved in ',path)

        message = 'Experiment {} completed in {:.3f} sec '.format(self.opt.name, time.time()-experiment_start_time)
        print(message)

    def visualize(self):
        nsamples = self.ranking.shape[2]
        legends = []
        for i,net in enumerate(self.opt.networks):
            for j,dataset in enumerate(self.opt.datasets):
                legends.append(net+'_'+dataset)
                count = (self.ranking[i,j,:,:] > 0).sum(axis=0)
                accuracy = count / nsamples
                indices = np.arange(0, accuracy.size, 5)
                print('Accuracy ', legends[-1], accuracy[indices])
                plt.plot(accuracy)

        plt.grid()        
        plt.legend(legends)
        plt.title(self.opt.name)
        plt.xlabel('Route length')
        plt.ylabel('Accuracy')
        plt.show()
