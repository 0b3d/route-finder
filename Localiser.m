classdef Localiser
    properties
        params
        test_routes
        test_turns
        num_nodes
        distances
        ranking
        R
        topk_estimated_routes
    end
    
    methods
        %% Constructor for the class (Load params and testing information)
        function obj = Localiser(params)
            obj.params = params;
            % load test_routes
            filename = [params.dataset,'_routes_',num2str(500),'_', num2str(params.threshold),'.mat'];
            path = fullfile('Localisation','test_routes',filename);
            test_routes = load(path);
            obj.test_routes = test_routes.test_route;
            % obj.test_routes = load(path).test_route;
            % load test turns
            if params.turns
                filename = [params.dataset,'_turns_',num2str(500),'_', num2str(params.threshold_),'.mat'];
                path = fullfile('Localisation','test_routes',filename);
                test_turns = load(path);
                obj.test_turns = test_turns.test_turn; 
                % obj.test_turns = load(path).test_turn;                
            end
            obj.ranking = zeros(params.T, params.mrl);
            obj.topk_estimated_routes = {params.T};
        end
        
        %% Extend routes function
        function obj = RRextend(obj)
            index = 1;
            sz1 = size(obj.R,1);
            sz2 = size(obj.R,2);
            R = zeros(sz1*5,sz2+1);   % preallocate, should be large enough
            dist = zeros(sz1*5,1);

            for i=1:sz1
                idx = obj.R(i,sz2);
                neighbor = obj.routes(idx).neighbor;

                if isempty(neighbor) % if no neighbors, delete this route
                    continue;
                end

                for j=1:size(neighbor, 1)      
                    k = find (obj.R(i,:) == neighbor(j));
                    if size(k, 2)== 0
                        R(index,:) = [obj.R(i,:), neighbor(j)];
                        dist(index,1) = obj.distances(i,1);
                        index = index+1;
                    else
                        continue;
                    end          
                end    
            end
            obj.R = R(1:index-1,:);  % shrink
            obj.distances = dist(1:index-1,1);
        end
        
        %% This method implements the turn filter
        function obj = turn_filter(obj, route_index, m)
            T_ = zeros(size(obj.R,1),1);
            turn = obj.test_turns(route_index,m-1);
            for i=1:size(obj.R, 1)
                idx1 = obj.R(i, m-1);
                idx2 = obj.R(i, m);
                theta1 = obj.routes(idx1).gsv_yaw;
                theta2 = obj.routes(idx2).gsv_yaw;
                if isempty(theta1) || isempty(theta2)
                    T_(i) = 3;
                else
                    turn_ = theta2 - theta1;
                    if turn_ > 180
                        turn_ = turn_-360;
                    elseif turn_ < -180
                        turn_ = turn_+360;
                    end

                    if abs(turn_) > obj.params.threshold_
                        T_(i) = 1;
                    else
                        T_(i) = 0;
                    end
                end
            end 
            k = find(T_ == turn);
            obj.R = obj.R(k,:);
            obj.distances = obj.distances(k, :);

        end
        
        
        %% This method performs route localisation
        function obj = localise_route(obj, route_index)
            top_routes = {obj.params.mrl};
            for m=1:obj.params.mrl
                gt_index = obj.test_routes(route_index,m);
                
                if m > 1 && obj.params.turns
                    obj = obj.turn_filter(route_index,m);
                end
                
                if size(obj.R,1) == 0   % If no candidate routes
                    break
                end
                
                obj = obj.distance_filter(gt_index, m);   % This method should be defined in subclass
                obj.ranking(route_index,m) = obj.get_ranking(route_index);   
                
                if size(obj.R, 1) > obj.params.topk
                    top_routes{m} = obj.R(1:5,:);
                else
                    top_routes{m} = obj.R;
                end
                
                if m < obj.params.mrl
                    obj = obj.RRextend();
                end
            end
            obj.topk_estimated_routes{route_index} = top_routes;
        end
        
        %% This method searchs the route rank
        function rank = get_ranking(obj, route_index)
            k = min(size(obj.R,1), obj.params.topk);
            high = size(obj.R,2);
            low = max(high - obj.params.overlap + 1, 1);
            gt_route = obj.test_routes(route_index,low:high); % [1,N]
            best_estimates = obj.R(1:k,low:high);
            comp = ismember(best_estimates,gt_route,'rows');
            isintopk = any(comp);
            if isintopk
                index = find(comp);
                rank = index(1);
            else
                rank = 0;
            end        
        end
        
        %% Localisation method
        function obj = localise(obj)
            
            % Localisation directory 
            if ~exist(obj.params.exp_dir,'dir')
              mkdir(obj.params.exp_dir);
            end
            diary_filename = fullfile(obj.params.exp_dir, 'log');
            diary(diary_filename)
            diary on
            
            disp('-----------------------------------------')
            disp(datetime(now,'ConvertFrom','datenum'))
            disp(obj.params)
            diary off
            disp('Localising ... be patient!')
            tic

            for route_index=1:obj.params.T 
                fprintf('Route %d \r', route_index);
                obj.num_nodes = size(obj.routes,2); 
                obj.R = (1:obj.num_nodes)';
                obj.distances = zeros(obj.num_nodes,1);
                obj = obj.localise_route(route_index);
            end
            
            time = toc;
            diary(diary_filename)
            diary on
            disp("All done! ")
            fprintf('Elapsed time (s) %f \n', time);
         
            %save results
            if obj.params.save
               path = fullfile(obj.params.exp_dir, obj.params.res_filename);
               ranking = obj.ranking;
               topk_estimated_routes = obj.topk_estimated_routes;
               save(path, 'ranking', 'topk_estimated_routes');
               fprintf("Results saved in %s  \n", path);
            end
            diary off
        end
    end
end