classdef BSDParams < BaseParams
    properties
        results_dir = 'results/BSD';
        features_dir = 'features/BSD';
        features_type = 'BSD';
        network = 'resnet18';
        N = ones(40,1)*100;
        metric = 'hamming';
        mnc = 100;
        exp_dir 
        res_filename
    end
    methods
        
        % Constructor
        %function obj = ESParams()
        %    obj = obj@BaseParams();
        %end
        
        % parse some options
        function obj = init(obj)
            % Create results directory
            % We do it here to allow each method (BSD and ES keep its own dir structure)
            % results directory
            obj = init@BaseParams(obj);
            if obj.turns == true
                 turns = "with_turns";
            else
                 turns = "without_turns";
            end
            obj.exp_dir = fullfile(obj.results_dir, ... 
                                    obj.network, ...
                                    turns, ...
                                    obj.name); % experiment directory 
            obj.res_filename = [obj.dataset,'.mat'];    % name for the file with results 

        end
    end
end
