% generate unique sparse datasets
clear all
load('routes_10m_9.mat', 'routes');
routes2 = routes;
min_dist = 100;
stack = routes(1).dist;
index = 1;

for i=2:length(routes)
    f_node = routes(i-1);
    c_node = routes(i);
    if f_node.id == c_node.id
        stack = [stack, c_node.dist];
        index = [index, i];
    else
        [M, I] = min(stack);
        if M < min_dist
            index(I) = [];
        end
        for j=1:length(index)
            routes2(index(j)).id = []; 
            routes2(index(j)).coords = [];
            routes2(index(j)).coords_t = [];
            routes2(index(j)).yaw = [];
            routes2(index(j)).neighbor = [];
            routes2(index(j)).BSDs = [];
            routes2(index(j)).BSDs_t = [];
        end
        stack = c_node.dist;
        index = i;
    end    
end

routes3 = struct();
delete_set = struct();
idx_1 = 1;
idx_2 = 1;

% % reallocate neighbors
for i=1:length(routes2)
    curnode  = routes(i);
    curnode2 = routes2(i);
    if isempty(curnode2.id)
        delete_set(idx_1).oidx = i;
        delete_set(idx_1).id = curnode.id;
        delete_set(idx_1).coords = curnode.coords;
        delete_set(idx_1).coords_t = curnode.coords_t;
        delete_set(idx_1).yaw = curnode.yaw;
        delete_set(idx_1).neighbor = curnode.neighbor;
        delete_set(idx_1).BSDs = curnode.BSDs;
        delete_set(idx_1).BSDs_t = curnode.BSDs_t; 
        idx_1 = idx_1+1;
    else
        routes3(idx_2).oidx = i;
        routes3(idx_2).id = curnode2.id;
        routes3(idx_2).coords = curnode2.coords;
        routes3(idx_2).coords_t = curnode2.coords_t;
        routes3(idx_2).yaw = curnode2.yaw;
        routes3(idx_2).neighbor = curnode2.neighbor;
        routes3(idx_2).BSDs = curnode2.BSDs;
        routes3(idx_2).BSDs_t = curnode2.BSDs_t; 
        idx_2 = idx_2 + 1; 
    end
end

Delete = zeros(length(delete_set),1);
for i=1:length(delete_set)
      Delete(i) = delete_set(i).oidx; 
end
save('Delete.mat', 'Delete');


