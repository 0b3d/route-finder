% generate training labels
% Add repository path
path =  fullfile(pwd);
addpath(genpath(path));

thresh_jc = 10; % 10m
thresh_bd = 3;  % 4 degree
thresh_dist = 5; % 5m
max_rays = 43; % 90/2 - 2

city_list = {'bath';'bristol';'cambridge';'cheltenham';'coventry';'derby';'glasgow';...
    'leeds';'liverpool';'livingston';'manchester';'newcastle';'norwich';'sheffield';...
    'southampton';'plymouth';'preston';'wakefield';'walsall';'wolverhampton';'york';...
    'nottingham';'leicester';'cardiff';'belfast';'brighton';'aberdeen';'inverness';...
    'durham';'birmingham';'dublin';'lyon';'helsinki';'berlin';'amsterdam';'madrid';...
    'vienna';'athens';'prague';'milan';'miami';'dallas';'atlanta';'chicago';'columbus';...
    'calgary';'edmonton';'ottawa';'montreal';'vancouver'};

for i=1:size(city_list, 1)
    % load data
    dataset = [city_list{i,1},'_10_19'];
    load(['features/',features_type,'/',features_type,'_', dataset,'.mat'],'routes');
    for j=1:length(routes)
        % junctions
        if routes(j).dist_f <= thresh_jc && routes(j).dist_f >= 1
            desc(1) = 1;
        else
            desc(1) = 0;
        end
        
        if routes(j).dist_b <= thresh_jc && routes(j).dist_b >= 1
            desc(3) = 1;
        else
            desc(3) = 0;
        end
        
        % gaps
        desc(4) = 0;
        if ~isempty(find(zerL_l >= thresh_bd && zerL_l <= 43)) % 5 degree
            desc(4) = 1;
        else
            if ~isempty(find(dist_diff_l >= thresh_dist))
                desc(4) = 1;
            end
        end
        
        desc(3) = 0;
        if ~isempty(find(zerL_r >= thresh_bd && zerL_r <= 43)) % 5 degree
            desc(3) = 1;
        else
            if ~isempty(find(dist_diff_r >= thresh_dist))
                desc(3) = 1;
            end
        end
        
        routes(j).BSDs = desc;
    end        
end