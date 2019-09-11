function roads3 = delete_some_nodes(roads, Delete)
for i=1:length(roads)
    cursz(i) = roads(i).sz;
end
sum = cumsum(cursz);
roads2 = roads;

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
        end
    end 
    roads2(i).dense_coords = dense_coords;
    roads2(i).dense_azs = dense_azs;
    roads2(i).inters = Inters;
    roads2(i).road_idx = road_idx;
    roads2(i).sz = size(dense_coords,1); 
end

roads3 = struct();
count = 1;
for i=1:length(roads2)
    if roads2(i).sz ~= 0 
        roads3(count).dense_coords = roads2(i).dense_coords;
        roads3(count).dense_azs = roads2(i).dense_azs;
        roads3(count).inters = roads2(i).inters;
        roads3(count).road_idx = roads2(i).road_idx;
        roads3(count).sz = roads2(i).sz;
        roads3(count).oidx = i; % old road idx
        count = count+1;
    end   
end

T = struct2table(roads3);
OIDX = T.oidx;
for i=1:length(roads3)
    curroad = roads3(i);
    for j=1:size(curroad.road_idx,1)
        old = curroad.road_idx(j);
        new = [];
        for k=1:size(old.IDX, 2)
            idx = find(ismember(OIDX, old.IDX(k)));
            new = [new idx]; 
            if isempty(idx)
                disp('check')
            end
        end
        roads3(i).road_idx(j).IDX = new;
    end
end

end