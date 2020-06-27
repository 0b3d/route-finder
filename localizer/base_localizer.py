
import os
from abc import ABC, abstractmethod
from matplotlib import pyplot as plt
import numpy as np
import pandas as pd
import random
import torch
import math
import time
from utils.util import haversine
import scipy.io as sio
import cv2

class BaseLocalizer(ABC):
    def __init__(self, opt):
        self.opt = opt
        if self.opt.seed >= 0:
            np.random.seed(opt.seed) 
            random.seed(opt.seed)
            torch.manual_seed(opt.seed)
            torch.backends.cudnn.deterministic = True
            torch.cuda.manual_seed(opt.seed)

        # Create a log file
        # self.log_name = os.path.join( self.opt.results_dir, self.opt.name, self.opt.localizer + '_' + str(self.opt.seed) + '.csv' )
        # with open(self.log_name, "a") as log_file:
        #     now = time.strftime("%c")
        #     log_file.write('================  Localizing (%s) ================\n' % now)


    @staticmethod
    def modify_commandline_options(parser, is_train):
        """Add new dataset-specific options, and rewrite default values for existing options.

        Parameters:
            parser          -- original option parser
            is_train (bool) -- whether training phase or test phase. You can use this flag to add training-specific or test-specific options.

        Returns:
            the modified parser.
        """
        return parser

    @abstractmethod
    def setup(self):
        pass

    @abstractmethod
    def localize(self):
        pass

    # @property
    # def gt(self):
    #     return self._robot.cpu().data.numpy()[0]

