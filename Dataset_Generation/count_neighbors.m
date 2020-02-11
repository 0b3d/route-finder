% count the number of neighbors
clear all
close all
city = 'manhattan';
name = 'wallstreet';
load(['Data/', city ,'_', name,'.mat'],'routes');

num_0 = 0;
num_1 = 0;
num_2 = 0;
num_3 = 0;
num_4 = 0;
num_5 = 0;
for i=1:length(routes)
    neighbors = routes(i).neighbor;
    num = size(neighbors, 1);
    if num == 0
        num_0 = num_0+1;
    end    
    if num == 1
        num_1 = num_1+1;
    end
    if num == 2
        num_2 = num_2+1;
    end
    if num == 3
        num_3 = num_3+1;
    end            
    if num == 4
        num_4 = num_4+1;
    end    
    if num == 5
        num_5 = num_5+1;
    end        
end


