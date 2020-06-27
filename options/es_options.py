from .base_options import BaseOptions


class ESOptions(BaseOptions):
    """This class includes test options.

    It also includes shared options defined in BaseOptions.
    """

    def initialize(self, parser):
        parser = BaseOptions.initialize(self, parser)  # define shared options
        parser.set_defaults(features_dir='./features/ES')
        parser.set_defaults(results_dir='./results/ES')

        self.isTrain = False
        return parser
