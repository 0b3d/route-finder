classdef Localiser
    properties
        params
        test_routes
        test_turns
        num_nodes
        distances
        ranking
        time
        R
    end
    methods
        %% Constructor for the class (Load params and testing information)
        function obj = Localiser(params)
            obj.params = params;
            % load test_routes
            filename = [params.dataset,'_routes_',num2str(500),'_', num2str(params.threshold),'.mat'];
            path = fullfile('Localisation','test_routes',filename);
            obj.test_routes = load(path).test_route;
            % load test turns
            if params.turns
                filename = [params.dataset,'_turns_',num2str(500),'_', num2str(params.threshold),'.mat'];
                path = fullfile('Localisation','test_routes',filename);
                obj.test_turns = load(path).test_turn;                
            end
            obj.ranking = zeros(params.T, params.mrl);
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
        %% This method performs route localisation
        function obj = localise_route(obj, route_index)
            for m=1:obj.params.mrl
                gt_index = obj.test_routes(route_index,m);
                %if m > 0 && obj.params.turns
                %    disp('turns filter');
                %end
                if size(obj.R,1) == 0
                    break
                end
                obj = obj.distance_filter(gt_index, m);   % This method should be defined in subclass
                
                if m < obj.params.mrl
                    obj = obj.RRextend();
                end
                obj.ranking(route_index,m) = obj.get_ranking(route_index); 
            end
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
            tic
%             if obj.params.save
%                 filename = [obj.params.dataset, obj.params.name,'.txt'];
%                 diary filename
%                 obj.params
%             end
            
            for route_index=1:(obj.params.T)
                obj.num_nodes = size(obj.routes,2); 
                obj.R = (1:obj.num_nodes)';
                obj.distances = zeros(obj.num_nodes,1);
                obj = obj.localise_route(route_index);
            end
            time = toc;
            disp(["Elapsed time ", time])
            
            %save results
            if obj.params.save
               filename = [obj.params.dataset, obj.params.name,'.mat'];
               dir = fullfile(obj.params.results_dir, obj.params.network); 
               path = fullfile(dir, filename);
               if ~exist(dir,'dir')
                  mkdir(path);
               end
               disp(["Results saved in", path])
            end
            
        end
    end
end