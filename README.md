This branch contains a python implementation of route-finder
It supports both BSD and ES features.

The main script is localize.py. To see a list of main options use.

>> python localize.py --help

For specific options and defaults values for each features_type check esrf and bsdrf classes.

Example of usage:

python localize.py -l esrf -n experiment_name --no_turns -d hudsonriver5k wallstreet5k unionsquare5k --networks v2_2 -s
python localize.py -l bsdrf -n experiment_name -d hudsonriver5k wallstreet5k unionsquare5k --networks resnet18 --no_turns -s

It is also possibe to localize specific routes by specifing their indices using --routes option. For example, to
localize routes 5 10 and 15 (zero-based indexes) of Hudson River using top5 and 5 points of overlap use

>> python localize.py -l esrf -n new_experiment -M v2_2 -d hudsonriver5k --routes 5 10 15 -k 5 -o 5

If flag -s is included a file with the results will be saved in results directory. Results is a 4-D array where each dimension correspond to
[<datasets>,<networks>,<num_routes>,<route_length>] respectively.

Note: The implementation considerable slower than Matlab implementation.