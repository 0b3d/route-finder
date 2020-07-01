import os, sys
import numpy as np

import random
import scipy.io as sio

from .routefinder_localizer import RouteFinderLocalizer
from sklearn.metrics import pairwise_distances


class ESRFLocalizer(RouteFinderLocalizer):
    def __init__(self, opt):
        RouteFinderLocalizer.__init__(self, opt)
        self.opt = opt
        #if self.opt.seed >= 0:
        #    np.random.seed(self.opt.seed)     
        #    random.seed(self.opt.seed)

    @staticmethod
    def modify_commandline_options(parser):
        """Add new dataset-specific options, and rewrite default values for existing options.

        Parameters:
            parser          -- original option parser

        Returns:
            the modified parser.
        """
        parser.set_defaults(results_dir='./results/ES', features_dir='./features/ES', features_type='ES', metric='euclidean', culling_percentage=0.5)
        parser.add_argument('-z','--zoom', type=str, nargs='+', default=['19'], choices={'18','19'}, help='tile zoom level')
        parser.add_argument('-e','--epoch', type=str, default='latest', help='Model epoch to load')

        return parser

    def distance_filter(self, index, R, distances, pairwise_distances):      
        target_indices = R[:,-1]
        measurement = pairwise_distances[index, target_indices]
        distances += measurement
        NN = np.argsort(distances, axis=-1) 
        
        if NN.shape[0] > self.opt.min_num_candidates:  
            p = int(NN.shape[0]*(1-self.opt.culling_percentage))
            NN = NN[:p]
    
        R_ = R[NN]
        dist_ = distances[NN]
        return R_, dist_

    def setup(self, cfg):
        """ Setup everything requered to perform the algorithm """


        self.source_domain = 'Y' if self.opt.direction[0] == 'i' else 'X'
        self.target_domain = 'X' if self.opt.direction[1] == 'm' else 'Y'
        print('source domain: {} target_domain {}'.format(self.source_domain, self.target_domain))

        # read features 
        #path = os.path.join(self.opt.features_dir, cfg['network'], 'z'+ self.opt.zoom[0], cfg['dataset'] + '.mat')
        #data = sio.loadmat(path, squeeze_me=True)
        #self.source_features, self.target_features = data[self.source_domain], data[self.target_domain]

        filename = '{}_predictions_{}_{}_test_zoom_{}.npz'.format(self.opt.epoch, self.source_domain,cfg['dataset'],self.opt.zoom[0])
        path = os.path.join(self.opt.features_dir, cfg['network'], filename)
        self.source_features = np.load(path)['predictions']

        filename = '{}_predictions_{}_{}_test_zoom_{}.npz'.format(self.opt.epoch, self.target_domain,cfg['dataset'],self.opt.zoom[0])
        path = os.path.join(self.opt.features_dir, cfg['network'], filename)
        self.target_features = np.load(path)['predictions']

        print("Features shape source: {} target:{}".format(self.source_features.shape, self.target_features.shape))

        # Compute pairwise distances
        self.D = pairwise_distances(self.source_features, self.target_features, self.opt.metric).astype(np.float32)
        print("Pairwise distances computed from: {} shape: {}".format(path,self.D.shape))


    def localize(self):   
        """ Perform algorithm """
        super().localize()
        pass
        

    