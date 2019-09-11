% test
clear all
% delete repeated nodes with same panoids
load('Delete.mat', 'Delete');
load('roads.mat', 'roads');

for i=1:length(roads)
    cursz(i) = roads(i).sz;
end
sum = cumsum(cursz);
roads2 = roads;
count = 0;
countt = 0;
record = [];

for i=1:length(roads)
    curroad = roads(i);
    dense_coords = [];
    dense_azs = [];
    Inters = [];
    road_idx = [];
    for j=1:size(curroad.dense_coords,1)
        if i==1
            curidx = j;
        else
            curidx = sum(i-1)+j;
        end
        idx = find(ismember(Delete,curidx, 'rows'));
        if  isempty(idx) 
            dense_coords = [dense_coords; curroad.dense_coords(j,:)];
            dense_azs = [dense_azs; curroad.dense_azs(j,:)];
            Inters = [Inters; curroad.inters(j)];
            road_idx = [road_idx; curroad.road_idx(j)];
            countt = countt+1;
        else
            count = count+1;
            record = [record; curidx];
        end
    end 
    roads2(i).dense_coords = dense_coords;
    roads2(i).dense_azs = dense_azs;
    roads2(i).inters = Inters;
    roads2(i).road_idx = road_idx;
    roads2(i).sz = size(dense_coords,1); 
end

roads = struct();
count = 1;
for i=1:length(roads2)
    if roads2(i).sz ~= 0 
        roads(count).dense_coords = roads2(i).dense_coords;
        roads(count).dense_azs = roads2(i).dense_azs;
        roads(count).inters = roads2(i).inters;
        roads(count).road_idx = roads2(i).road_idx;
        roads(count).sz = roads2(i).sz;
        roads(count).oidx = i;
        count = count+1;
    end   
end

T = struct2table(roads);
OIDX = T.oidx;
for i=1:length(roads)
    curroad = roads(i);
    new = [];
    for j=1:size(curroad.road_idx,1)
        old = curroad.road_idx(j);
        for k=1:size(old.IDX, 2)
            idx = find(ismember(OIDX, old.IDX(k)));
            new = [new; idx];   
        end
        roads(i).road_idx(j).IDX = new;
    end
end
