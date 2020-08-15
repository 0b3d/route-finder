classdef BSDLocaliser < Localiser
   properties
       name = 'BSDLocaliser';
       routes
       exp_dir
       filename
       %D
   end
   
   methods
       %% Constructor for BSD Localiser
       function obj = BSDLocaliser(params)                      
         if nargin == 0
            params = [];
         end
         obj = obj@Localiser(params);
         % initialize the routes struct
         filename = ['BSD_', params.dataset,'.mat'];
         path = fullfile(params.features_dir, params.network, filename);
         routes = load(path);
         obj.routes = routes.routes;
         % obj.routes = load(path).routes;
         
         % load features
         %filename = [params.dataset,'.mat'];
         %path = fullfile(params.features_dir,params.network,params.zoom,filename)
         %features = load(path, 'X', 'Y');
         %X = features.X
         % obj.D = pairwise_distances(obj.routes);           
         disp('BSDLocaliser has been created ... to start localisation call localise method');
       end
       
       %% Localisation method
       function [ranking, topk_estimated_routes] = localise(obj)         
         obj = localise@Localiser(obj);     % call method in parent class
         ranking = obj.ranking;
         topk_estimated_routes = obj.topk_estimated_routes; 
       end
      
       %% Distance filter for ES
      function obj = distance_filter(obj, gt_index, m)
          
          % Measurement done by indexing
          % target_indices = obj.R(:,m);
          % measurement = obj.D(gt_index,target_indices);              
          % obj.distances = obj.distances + measurement';
          
          % Compute distances       
          observation = obj.routes(gt_index).CNNs; 
          sz1 = size(obj.R, 1);
          for i=1:sz1     
            k = obj.R(i,m); 
            try
                if ~isempty(obj.routes(k).BSDs)
                    desc_ = obj.routes(k).BSDs; 
                    obj.distances(i,1) = obj.distances(i,1) + size(find(desc_~=observation), 2); 
                else
                    obj.distances(i,1) = 1000; % max - similar to delete this route
                end
            catch
                disp('error');
            end
          end
          
          [~,I] = sort(obj.distances);
          ncandidates = size(I,1);
          if ncandidates > obj.params.mnc
             p = floor(ncandidates/100*obj.params.N(m));
          else
             p = ncandidates;
          end
          I = I(1:p,1);    
          obj.R = obj.R(I,:);
          obj.distances = obj.distances(I,1);
      end
      
      %% This method is to generate routes struct
      function obj = data_generation(obj)
          % load features
          path = fullfile(obj.params.features_dir, obj.params.network, obj.params.zoom, [obj.params.dataset,'.mat']);
          load(path,'X','Y')

          % load routes
          load(['Data/streetlearn/',obj.params.dataset,'_new.mat'],'routes');

          %% generate delete set
          for i=1:5000
              routes(i).x = X(i,:);
              routes(i).y = Y(i,:);
          end
          path = fullfile(obj.params.features_dir, obj.params.network, obj.params.zoom,['BSD_',obj.params.dataset,'.mat']);
          save(path,'routes');
      end
   end
end