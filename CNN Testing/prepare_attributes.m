% generate training attributes
% Add repository path
path =  fullfile(pwd);
addpath(genpath(path));
radius = 35;
range = 2;
thresh = 10; 
features_type = 'BSD';
% city_list = {'bath';'bristol';'cambridge';'cheltenham';'coventry';'derby';'glasgow';...
%     'leeds';'liverpool';'livingston';'manchester';'newcastle';'norwich';'sheffield';...
%     'southampton';'plymouth';'preston';'wakefield';'walsall';'wolverhampton';'york';...
%     'nottingham';'leicester';'cardiff';'belfast';'brighton';'aberdeen';'inverness';...
%     'durham';'birmingham';'dublin';'lyon';'helsinki';'berlin';'amsterdam';'madrid';...
%     'vienna';'athens';'prague';'milan';'miami';'dallas';'atlanta';'chicago';'columbus';...
%     'calgary';'edmonton';'ottawa';'montreal';'vancouver'};
city_list = {'london'};

for i=1:size(city_list, 1)
    % load data
    dataset = [city_list{i,1},'_10_19'];
    load(['Data/',dataset,'/routes_small.mat']);
    load(['Data/',dataset,'/ways.mat']);
    load(['Data/',dataset,'/inters.mat']);
    load(['Data/',dataset,'/buildings.mat']);

    inters = inters_filter_v2(inters, ways, thresh); 
    routes = BSD_generation_v5(routes, inters, buildings, radius, range);
    save(['features/',features_type,'test','/',features_type,'_', dataset,'.mat'],'routes');
end

