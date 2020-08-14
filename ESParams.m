classdef ESParams < BaseParams
    properties
        results_dir = 'results/ES';
        features_dir = 'features/ES';
        zoom = 'z18';
        features_type = 'ES';
        network = 'v2_12';
        N = ones(40,1)*100;
        metric = 'euclidean';
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
                                    obj.zoom, ...
                                    turns, ...
                                    obj.name); %experiment directory 
            obj.res_filename = [obj.dataset,'.mat'];    % name for the file with results 

        end
    end
end
