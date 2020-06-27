import argparse
from localizer import create_localizer
from options.base_options import BaseOptions

opt = BaseOptions().parse() # get training options
localizer = create_localizer(opt)
localizer.localize()
localizer.visualize()