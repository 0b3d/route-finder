import os, sys
import numpy as np

import random
import time
import pandas as pd

from multiprocessing import Pool, RawArray
import scipy.io as sio
from matplotlib import pyplot as plt
from sklearn.metrics import pairwise_distances
from itertools import compress
from localizer import BaseLocalizer

var_dict = {}
def init_worker(pairwise_distances, neighbors, neighbors_shape, test_routes, test_routes_shape, turns=False, test_turns=None, yaw=None):
    var_dict['neighbors'] = neighbors
    var_dict['neighbors_shape'] = neighbors_shape
    var_dict['test_routes'] = test_routes
    var_dict['test_routes_shape'] = test_routes_shape
    var_dict['pairwise_distances'] = pairwise_distances

    if turns:
        var_dict['test_turns'] = test_turns
        var_dict['yaw'] = yaw


class RouteFinderLocalizer(BaseLocalizer):
    """ This class implements methods commun for ES and BSD route finding """
    def __init__(self, opt):
        BaseLocalizer.__init__(self, opt)
        self.opt = opt
    
    def load_test_routes(self, dataset):
        # Load test routes into memory
        filename = '{}_routes_500_60.mat'.format(dataset)
        path = os.path.join('metadata', 'test_routes', filename)
        self.test_routes = sio.loadmat(path)['test_route'][0:self.opt.num_test_routes,:self.opt.max_route_length] - 1
        print("Loaded test routes from ", path, "shape", self.test_routes.shape)
        
        # Load test turns
        if not self.opt.no_turns:
            filename = '{}_turns_500_{}.mat'.format(dataset, self.opt.turn_threshold)
            path = os.path.join('metadata', 'test_routes', filename)
            self.test_turns = sio.loadmat(path)['test_turn'][:self.opt.num_test_routes,:self.opt.max_route_length-1]            
            print("Loaded test turns from ", path, "shape", self.test_turns.shape)

            # Load heading (yaw)
            filename = '{}.csv'.format(dataset)
            path = os.path.join('metadata', filename)
            self.yaw = pd.read_csv(path,usecols=['yaw'],dtype=np.int16).values.reshape(-1)
            print("Loaded yaw information from ", path, "shape", self.yaw.shape)

        # Load connectivity file
        filename = '{}_neighbors.mat'.format(dataset)
        path = os.path.join('metadata', 'connectivity', filename)
        neighbors = sio.loadmat(path)['neighbors']
        self.neighbors = np.where(np.isnan(neighbors),neighbors.shape[0]+1,neighbors).astype(np.uint16) - 1 # Adjust to base_0 index (nan values as 5000)
        message = 'Neighbors read from {} shape{}'.format(path, self.neighbors.shape)        
        print(message)

        self.num_nodes = neighbors.shape[0]

    def initialize_buffers(self):
        neighbors = RawArray('H', self.neighbors.shape[0] * self.neighbors.shape[1])
        neighbors_sharable_wrapped = np.frombuffer(neighbors, dtype=np.uint16).reshape(self.neighbors.shape)
        np.copyto(neighbors_sharable_wrapped, self.neighbors)

        test_routes = RawArray('H', self.test_routes.shape[0]*self.test_routes.shape[1])
        test_routes_sharable_wrapped = np.frombuffer(test_routes, dtype=np.uint16).reshape(self.test_routes.shape)
        np.copyto(test_routes_sharable_wrapped, self.test_routes)

        if not self.opt.no_turns:
            yaw = RawArray('h', self.yaw.shape[0])
            yaw_sharable_wrapped = np.frombuffer(yaw, dtype=np.int16)
            np.copyto(yaw_sharable_wrapped, self.yaw)

            test_turns = RawArray('B', self.test_turns.shape[0]*self.test_turns.shape[1])
            test_turns_sharable_wrapped = np.frombuffer(test_turns, dtype=np.uint8).reshape(self.test_turns.shape)
            np.copyto(test_turns_sharable_wrapped, self.test_turns)
        else:
            yaw, test_turns = None, None

        initargs = [neighbors, self.neighbors.shape, test_routes, self.test_routes.shape, 
                    not self.opt.no_turns, test_turns, yaw]
        return initargs

    @staticmethod
    def RRextend(R_, dist_, neighbors_array):
        nr, nc = R_.shape
        R = np.zeros((nr*5,nc+1),dtype=np.int16) #preallocate
        dist = np.zeros(nr*5,)
        index = 0
        
        for i in range(nr):
            idx = R_[i,-1]
            neighbors = neighbors_array[idx]

            for neighbor in neighbors:
                if neighbor >= 5000:
                    break

                if  neighbor not in R_[i,:]:
                    R[index,:] = np.append(R_[i,:], neighbor)  
                    dist[index] = dist_[i]
                    index += 1
        
        R = R[:index, :]
        dist = dist[:index]
        return R, dist

    @staticmethod
    def turn_filter(route_index, m, R_, dist_, threshold):
        shape = (var_dict['test_routes_shape'][0],var_dict['test_routes_shape'][1]-1)
        offset = np.ravel_multi_index((route_index,m-1), shape)
        turn = np.frombuffer(var_dict['test_turns'], dtype=np.uint8, count=1, offset=offset)

        T_ = np.zeros((R_.shape[0],), dtype=np.uint8)

        for i in range(R_.shape[0]):
            idx1, idx2 = R_[i,m-1], R_[i,m]
            theta1 = np.frombuffer(var_dict['yaw'],dtype=np.int16,count=1,offset=idx1*2)
            theta2 = np.frombuffer(var_dict['yaw'],dtype=np.int16,count=1,offset=idx2*2)
            if theta1.size == 0 or theta2.size == 0: 
                T_[i] = 3
            else:
                turn_ = theta2 - theta1
                if turn_ > 180:
                    turn_ -= 360
                elif turn_ < -180:
                    turn_ += 360
                T_[i] = 1 if (abs(turn_) > threshold) else 0

        k = np.argwhere(T_ == turn).reshape(-1)
        R_ = R_[k,:]
        dist_ = dist_[k]
        return R_, dist_ 

    def localize_route(self, route_index):
        neighbors = np.frombuffer(var_dict['neighbors'],dtype=np.uint16).reshape(var_dict['neighbors_shape'])
        test_routes = np.frombuffer(var_dict['test_routes'],dtype=np.uint16).reshape(var_dict['test_routes_shape'])
        distances_shape = (var_dict['neighbors_shape'][0],var_dict['neighbors_shape'][0])
        pairwise_distances = np.frombuffer(var_dict['pairwise_distances'],dtype=np.float32).reshape(distances_shape)
                  
        R = np.arange(0,self.num_nodes, dtype=np.uint16).reshape(-1,1)
        distances = np.zeros((self.num_nodes,))
        route_ranking = []
        route_ranking = np.zeros((self.opt.max_route_length,))

        for m in range(self.opt.max_route_length):
            gt_index = test_routes[route_index,m] # Observation gt_index

            # ------ filters ------------------------------
            if m > 0 and not self.opt.no_turns:
                R, distances = self.turn_filter(route_index, m, R, distances, self.opt.turn_threshold)                                  
                
            if R.shape[0] == 0: 
                break
            
            R_, dist_ = self.distance_filter(gt_index, R, distances, pairwise_distances)   # This method should be implemented in subclass ES or BSD
            
            # ------ extend -------------------------------
            if m < self.opt.max_route_length-1:
                R, distances = self.RRextend(R_, dist_, neighbors)

            # ------ top-k accuracy -----------------------
            k = min(R_.shape[0], self.opt.topk)
            low = max(m - self.opt.overlap + 1, 0)
            high = m + 1 
            gt = test_routes[route_index,low:high]
            best_estimated_routes = R_[0:k,low:high]

            comp = [np.array_equal(row, gt) for row in best_estimated_routes]
            is_in_top_k = any(comp)                    
            
            ind = list(compress(range(len(comp)), comp))
            rank = ind[0] + 1 if is_in_top_k else 0
            route_ranking[m] = rank
        
            if self.opt.verbose:
                message = 'route {} step {} rank {} routes {}'.format(route_index, m, rank, R_.shape[0])
                print(message)
        
        route_ranking = np.stack(route_ranking, 0)
        return route_ranking


    def localize(self):   
        """ Perform route_searching algorithm """
        
        experiment_start_time = time.time()  # timer for entire epoch
        experiment_rankings = []

        for dataset in self.opt.datasets:
            
            datasets_rankings = []   
            self.load_test_routes(dataset)
            initargs = self.initialize_buffers()
            
            # load test_routes

            for net in self.opt.networks: 
                nets_rankings = [] 
                cfg = {'network': net, 'dataset':dataset}

                self.setup(cfg)                                     # This method should be implemented in subclass
                pairwise_distances = RawArray('f', self.D.shape[0]*self.D.shape[1])
                pairwise_distances_sharable_wrapped = np.frombuffer(pairwise_distances, dtype=np.float32).reshape(self.D.shape)
                np.copyto(pairwise_distances_sharable_wrapped, self.D)
                initargs.insert(0, pairwise_distances)

                route_indexes = np.arange(0,self.opt.num_test_routes) if self.opt.routes is None else self.opt.routes

                message = '-'*5+'localizing dataset {} and features from net {}'.format(dataset, net) + '-'*5
                print(message)

                with Pool(self.opt.workers, initializer=init_worker, initargs=initargs) as pool:
                    nets_rankings = pool.map(self.localize_route, route_indexes)
            
                ranking = np.stack(nets_rankings, axis=0)
                datasets_rankings.append(ranking)
            
            ranking = np.stack(datasets_rankings, axis=0) 
            experiment_rankings.append(ranking)
        
        self.ranking = np.stack(experiment_rankings, axis=0) 

        if self.opt.save:
            filename = '{}.{}'.format(self.opt.name, self.opt.format)
            path = os.path.join(self.opt.results_dir, filename)
            if self.opt.format == 'mat':
                sio.savemat(path, {'ranking':self.ranking})
            else:
                np.save(path, self.ranking)
            print('results saved in ',path)

        message = 'Experiment {} completed in {:.3f} sec '.format(self.opt.name, time.time()-experiment_start_time)
        print(message)

    def visualize(self):
        nsamples = self.ranking.shape[2]
        legends = []
        for i,dataset in enumerate(self.opt.datasets):
            for j,net in enumerate(self.opt.networks):
                legends.append(dataset+'_'+net)
                count = (self.ranking[i,j,:,:] > 0).sum(axis=0)
                accuracy = count / nsamples
                indices = np.arange(4, self.opt.max_route_length, 5)
                print('Accuracy ', legends[-1], accuracy[indices])
                plt.plot(accuracy)

        plt.grid()        
        plt.legend(legends)
        plt.title(self.opt.name)
        plt.xlabel('Route length')
        plt.ylabel('Accuracy')
        plt.show()
