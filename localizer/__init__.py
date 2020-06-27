"""This package contains modules related to localization algorithms.

To add a custom algorithm class called 'dummy', you need to add a file called 'dummy_localizer.py' and define a subclass DummyLocalizer inherited from BaseLocalizer.
You need to implement the following five functions:
    -- <__init__>:                      initialize the class; first call BaseLocalizer.__init__(self, opt).
    -- <modify_commandline_options>:    (optionally) add localizer-specific options and set default options.
    -- <setup>:                         read features, routes, etc.
    -- <localize>                       perform the localization algorithms
    -- <visualize>                      visualize current state of variables


Now you can use the localizer class by specifying flag '--localizer dummy'.
"""

import importlib
from localizer.base_localizer import BaseLocalizer
import torch

def find_localizer_using_name(localizer_name):
    """Import the module "localizer/[localizer_name]_localizer.py".

    In the file, the class called DatasetNameLocalizer() will
    be instantiated. It has to be a subclass of BaseLocalizer,
    and it is case-insensitive.
    """
    localizer_filename = "localizer." + localizer_name + "_localizer"
    localizerlib = importlib.import_module(localizer_filename)
    localizer = None
    target_localizer_name = localizer_name.replace('_', '') + 'localizer'
    for name, cls in localizerlib.__dict__.items():
        if name.lower() == target_localizer_name.lower() \
           and issubclass(cls, BaseLocalizer):
            localizer = cls

    if localizer is None:
        print("In %s.py, there should be a subclass of BaseLocalizer with class name that matches %s in lowercase." % (localizer_filename, target_localizer_name))
        exit(0)

    return localizer


def get_option_setter(localizer_name):
    """Return the static method <modify_commandline_options> of the localizer class."""
    localizer_class = find_localizer_using_name(localizer_name)
    return localizer_class.modify_commandline_options


def create_localizer(opt):
    """Create a localizer given the option.
    Example:
        >>> from localizer import create_localizer
        >>> localizer = create_localizer(opt)
    """
    localizer = find_localizer_using_name(opt.localizer)
    instance = localizer(opt)
    print("localizer [%s] was created" % type(instance).__name__)
    return instance

