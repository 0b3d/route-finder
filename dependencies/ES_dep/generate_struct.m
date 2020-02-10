% Add repository path
path =  fullfile(pwd);
addpath(genpath(path));
%load(['features/ES/',dataset,'.mat']); 
%5load(['Data/',dataset,'/routes_small.mat']);
city = 'manhattan'
s = struct


%% generate delete set

for i=1:size(pano_id,1)
    srcidx = find(strcmp(src,string(pano_id(i,:))));
    dstpanos = dst(srcidx, :);
    dstbearing = bearing(srcidx);
    neighbours = zeros(size(dstpanos,1), 1);
    for p=1:size(dstpanos,1) %for find neighbor
        dstpano = string(dstpanos(p,:));
        orgidx = find(strcmp(pano_id, dstpano));
        neighbours(p,1) = orgidx;
    end
  
    s(i).id = pano_id(i,:);
    s(i).gsv_coords = [lat(i), lon(i)];
    s(i).gsv_yaw = yaw(i);
    s(i).neighbor = neighbours; 
    s(i).bearing = dstbearing;
    i
end

save(['features/ES/','ES_',city,'.mat'],'s');