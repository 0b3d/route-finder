import argparse
import os
from utils import util
import time
import localizer


class BaseOptions():
    """This class defines options used for both ES and BSD
    """

    def __init__(self):
        """Reset the class; indicates the class hasn't been initailized"""
        self.initialized = False

    def initialize(self, parser):
        """Define common options used by BSD and ES. It is posible to change default values ether in command line
           or in the localization subclasses"""
        
        # directories and name
        parser.add_argument('--features_dir', type=str, default='./features', help='path to features')
        parser.add_argument('--results_dir', type=str, default='./results', help='path to results')
        parser.add_argument('-n','--name', type=str, default='unnamed', help='name of the experiment. It decides where to store results')

        # localize options
        parser.add_argument('-l', '--localizer', type=str, default='esrf', choices={'bsdrf','esrf'}, help='Name of the algorithm for localization')
        parser.add_argument('-N', '--culling_percentage', type=float, default=0.5, help='Percentage of routes to drop in each iteration 0-1')        
        parser.add_argument('-t', '--turn_threshold', type=int, default=60, help='Turn threshold')
        parser.add_argument('-k', '--topk', type=int, default=1, help='Top-k')
        parser.add_argument('-o', '--overlap', type=int, default=1, help='N overlap for given a route as localized')
        parser.add_argument('-r', '--routes', type=int, nargs='+', help='If set disable turns pattern conparation')
        parser.add_argument('-T', '--num_test_routes', type=int, default=500, help='number of routes for testing 0-500') 
        parser.add_argument('-L', '--max_route_length', type=int, default=40, help='Maximum route length')
        parser.add_argument('-c', '--min_num_candidates', type=int, default=100, help='Minimun number of route candidates to keep in localization process')
        parser.add_argument('-m', '--metric', type=str, default='hamming', help='Distance metric to use in localization')
        parser.add_argument('--direction', type=str, nargs='+', default=['i','m'], choices={'i','m'}, help='Direction')
        parser.add_argument('--no_turns', action='store_true', help='If set disable turns pattern comparation')

        # model and dataset
        parser.add_argument('-M','--networks', type=str, nargs='+', default=['v2_2'], help='A list of networks (models) to use for localization')
        parser.add_argument('-d','--datasets', type=str, nargs='+', default=['unionsquare5k'], choices={'hudsonriver5k','unionsquare5k', 'wallstreet5k'}, help=' A list of datasets to test')
        #parser.add_argument('-f','--features_type', type=str, default='BSD', choices={'BSD','ES'}, help='Features type to use for localization')
        parser.add_argument('-p','--phase', type=str, default='localize', help='phase of the task')
        
        # additional options 
        #parser.add_argument('--seed', type=int, default=442, help='Set the seed') # At the moment there are no random processes in this code.
        parser.add_argument('-w','--workers', type=int, default=4, help='Number of workers')
        parser.add_argument('-s','--save', action='store_true',help='If set save results in disk')
        parser.add_argument('-v', '--verbose', action='store_true', help='Verbose')
        parser.add_argument('--suffix', default='', type=str, help='customized suffix: opt.name = opt.name + suffix: e.g., {network}_{dataset}_zoom{19}')
        parser.add_argument('--format', default='mat', type=str, choices={'mat','npy'}, help='Results file format')
        
        self.initialized = True
        return parser

    def gather_options(self):
        """Initialize our parser with basic options(only once).
        Add additional model-specific and dataset-specific options.
        These options are defined in the <modify_commandline_options> function
        in localizer classes.
        """
        if not self.initialized:  # check if it has been initialized
            parser = argparse.ArgumentParser(formatter_class=argparse.ArgumentDefaultsHelpFormatter)
            parser = self.initialize(parser)

        # get the basic options
        opt, _ = parser.parse_known_args()
        localizer_option_setter = localizer.get_option_setter(opt.localizer)
        parser = localizer_option_setter(parser)

        # save and return the parser
        self.parser = parser
        return parser.parse_args()

    def print_options(self, opt):
        """Print and save options

        It will print both current options and default values(if different).
        It will save options into a text file / [results_dir] / opt.txt
        """
        message = ''
        now = time.strftime("%c")
        message += '----------------- Options (%s) ---------------\n' % now
        for k, v in sorted(vars(opt).items()):
            comment = ''
            default = self.parser.get_default(k)
            if v != default:
                comment = '\t[default: %s]' % str(default)
            message += '{:>25}: {:<30}{}\n'.format(str(k), str(v), comment)
        message += '----------------- End -------------------'
        print(message)

        # save to the disk
        expr_dir = os.path.join(opt.results_dir)
        util.mkdirs(expr_dir)
        file_name = os.path.join(expr_dir, '{}_opt.txt'.format(opt.phase))
        with open(file_name, 'a') as opt_file:   #with open(file_name, 'wt') as opt_file:
            opt_file.write(message)
            opt_file.write('\n')

    def parse(self):
        """Parse our options, create checkpoints directory suffix, and set up gpu device."""
        opt = self.gather_options()

        # process opt.suffix
        if opt.suffix:
            suffix = ('_' + opt.suffix.format(**vars(opt))) if opt.suffix != '' else ''
            opt.name = opt.name + suffix

        self.print_options(opt)

        self.opt = opt
        return self.opt
