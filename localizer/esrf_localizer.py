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
        if self.opt.seed >= 0:
            np.random.seed(self.opt.seed)     
            random.seed(self.opt.seed)
        self.steps_list = []

    @staticmethod
    def modify_commandline_options(parser):
        """Add new dataset-specific options, and rewrite default values for existing options.

        Parameters:
            parser          -- original option parser
            is_train (bool) -- whether training phase or test phase. You can use this flag to add training-specific or test-specific options.

        Returns:
            the modified parser.
        """
        parser.set_defaults(results_dir='./results/ES', features_dir='./features/ES', features_type='ES')
        parser.add_argument('-z','--zoom', type=str, nargs='+', default=['z19'], choices={'z18','z19'}, help='tile zoom level')
        
        #parser.add_argument('-e','--epoch', type=str, default='latest', help='epoch')
        # Set defaults related to dataset and model
        return parser


    # ------ distance filter --------------------------
    def distance_filter(self, index, R, distances):
        source_descriptor = self.source_features[index,:].reshape(1,-1)
        target_descriptors = self.target_features[R[:,-1],:]
        measurement = pairwise_distances(source_descriptor, target_descriptors).squeeze()
        distances += measurement
        NN = np.argsort(distances, axis=-1)   
        p = int(NN.shape[0]*(1-self.opt.culling_percentage))
        p = max(p,100)
        I = NN[:p]
        R_ = R[I]
        dist_ = distances[I]
        return R_, dist_

      
    def setup(self, cfg):
        """ Setup everything requered to perform the algorithm """

        # Read routes struct
        path = os.path.join(self.opt.features_dir, cfg['network'], self.opt.zoom[0], 'ES_' + cfg['dataset'] + '.mat')
        data = sio.loadmat(path, squeeze_me=False)
        self.routes = data['routes'] # to access use routes[field][0,index]
        #data = sio.loadmat(path, struct_as_record=False, squeeze_me=True) # to acess use data[index].field
        
        # read features in array 
        path = os.path.join(self.opt.features_dir, cfg['network'], self.opt.zoom[0], cfg['dataset'] + '.mat')
        data = sio.loadmat(path, squeeze_me=True)

        self.source_features, self.target_features = data['X'], data['Y']
        if self.opt.verbose > 0:
            print("Features shape source: {} target:{}".format(self.source_features.shape, self.target_features.shape))
        
        # load test_routes
        super().load_test_routes(cfg)

        # Compute pairwise distances
        self.D = pairwise_distances(self.target_features, self.source_features)
        if self.opt.verbose > 0:
            print("Pairwise distances shape: {}".format(self.D.shape))


    def localize(self):   
        """ Perform algorithm """
        super().localize()
        pass
        

    