% assign lables
clearvars -except dataset
close all
parameters;

% Add repository path
path =  fullfile(pwd);
addpath(genpath(path));
parameters;

% load data
load(['features/',features_type,'/',dataset,'/',features_type,'_', city,'_',dataset,'.mat'],'routes');
for j=1:length(routes)
    % junctions
    if ~isempty(routes(j).dist_f) && routes(j).dist_f <= thresh_jc && routes(j).dist_f >= 1
        desc(1) = 1; % front
    else
        desc(1) = 0;
    end

    if ~isempty(routes(j).dist_b) && routes(j).dist_b <= thresh_jc && routes(j).dist_b >= 1
        desc(3) = 1; % back
    else
        desc(3) = 0;
    end

    % gaps
    desc(4) = 0;
    if ~isempty(find(routes(j).zerL_l >= thresh_bd)) && isempty(find(routes(j).zerL_l >= max_rays)) % 5 degree
        desc(4) = 1; % left
    else
        if ~isempty(find(routes(j).dist_diff_l >= thresh_dist))
            desc(4) = 1;
        end
    end

    desc(2) = 0;
    if ~isempty(find(routes(j).zerL_r >= thresh_bd)) && isempty(find(routes(j).zerL_r >= max_rays)) % 5 degree
        desc(2) = 1; % right
    else
        if ~isempty(find(routes(j).dist_diff_r >= thresh_dist))
            desc(2) = 1;
        end
    end

    routes(j).BSDs = desc;

end
save(['features/',features_type,'/',dataset,'/',features_type,'_', city,'_',dataset,'.mat'],'routes');
