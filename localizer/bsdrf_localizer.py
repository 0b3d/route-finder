import os, sys
import numpy as np

import random
import scipy.io as sio

from .routefinder_localizer import RouteFinderLocalizer
from sklearn.metrics import pairwise_distances


class BSDRFLocalizer(RouteFinderLocalizer):
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
        parser.set_defaults(results_dir='./results/BSD', features_dir='./features/BSD',features_type='BSD', metric='hamming', networks=['resnet18'])
        parser.add_argument('--city', type=str, default='manhattan', choices={'manhattan','pittsburgh'}, help='City')
        
        # Set defaults related to dataset and model
        return parser


    # ------ distance filter --------------------------
    def distance_filter(self, index, R, distances):
        sz1, sz2 = R.shape
        desc_new = self.routes['CNNs'][0,index].reshape(-1)

        for i in range(sz1):
            k = R[i,-1]
            desc_ = self.routes['BSDs'][0,k].reshape(-1)
            distances[i] += np.logical_xor(desc_new, desc_).sum()
            
        NN = np.argsort(distances, axis=-1)   
        p = int(NN.shape[0]*(1-self.opt.culling_percentage))
        #p = max(p,100)
        I = NN[:p]
        R_ = R[I]
        dist_ = distances[I]
        return R_, dist_

      
    def setup(self, cfg):
        """ Setup everything requered to perform the algorithm """

        # Read routes struct
        filename = 'BSD_{}_{}.mat'.format(self.opt.city, cfg['dataset'])
        path = os.path.join(self.opt.features_dir, cfg['dataset'], filename)
        data = sio.loadmat(path, squeeze_me=False)
        self.routes = data['routes'] # to access use routes[field][0,index]
                
        # load test_routes
        super().load_test_routes(cfg)

    def localize(self):   
        """ Perform algorithm """
        super().localize()
        pass
        

    