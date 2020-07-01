import os, sys
import numpy as np

import random
import scipy.io as sio
from sklearn.metrics import pairwise_distances
from scipy.spatial.distance import pdist

from .routefinder2_localizer import RouteFinderLocalizer

class BSDRFLocalizer(RouteFinderLocalizer):
    def __init__(self, opt):
        RouteFinderLocalizer.__init__(self, opt)
        self.opt = opt

    @staticmethod
    def modify_commandline_options(parser):
        """Add new dataset-specific options, and rewrite default values for existing options.

        Parameters:
            parser          -- original option parser

        Returns:
            the modified parser.
        """
        parser.set_defaults(results_dir='./results/BSD', features_dir='./features/BSD',features_type='BSD', metric='hamming', networks=['resnet18'], culling_percentage=0.1)
        #parser.add_argument('--city', type=str, default='manhattan', choices={'manhattan','pittsburgh'}, help='City')
        
        # Set defaults related to dataset and model
        return parser


    # ------ distance filter --------------------------
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

        #Load features
        filename = '{}_{}.mat'.format(cfg['dataset'],cfg['network'])
        path = os.path.join(self.opt.features_dir, cfg['dataset'], filename)
        data = sio.loadmat(path, squeeze_me=False)
        
        self.source_domain = 'CNNs' if self.opt.direction[0] == 'i' else 'BSDs'
        self.target_domain = 'BSDs' if self.opt.direction[1] == 'm' else 'CNNs'
        print('source domain: {} target_domain {}'.format(self.source_domain, self.target_domain))

        self.source_features, self.target_features = data[self.source_domain], data[self.target_domain]
        print("Features shape source: {} target:{}".format(self.source_features.shape, self.target_features.shape))

        # Compute pairwise distances
        self.D = pairwise_distances(self.source_features, self.target_features, self.opt.metric).astype(np.float32)
        print("Pairwise distances computed from: {} shape: {}".format(path,self.D.shape))

    def localize(self):   
        """ Perform algorithm """
        super().localize()
        pass
        

    