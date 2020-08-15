classdef BaseParams
    properties
        mrl = 40;                   % maximum route length
        T = 500;                    % number of routes to test
        threshold = 60;             % turn threshold
        threshold_ = 30;
        dataset = 'hudsonriver5k';  % name of the dataset to process
        turns = true;               % if use turns in localisation
        topk = 5;                   % the localizer will search the route in the topk candidates            
        overlap = 5;                % N overlap for localisation
        save = true;                % whether to save results in results dir
        name = 'experiment_name';   % experiment name
        charts_dir = fullfile('results','charts');    % directory for charts
    end
    
    methods
        % init method
        function obj = init(obj)
            % cheate charts directory if it does not exist
            if ~exist(fullfile(obj.charts_dir),'dir')
                mkdir(obj.charts_dir)
            end
        end
    end
end

