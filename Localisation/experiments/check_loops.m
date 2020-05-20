% check loops
clear all
close all
dataset = 'wallstreet5k';
load(['Localisation/test_routes/',dataset,'_routes_', '500','_' , '60','.mat']); 
error = 0;
for i=1:500
    t = test_route(i,:);
    for j=1:40
        k = find(t==t(j));
        if size(k,2)>1 || k~=j
            error = error+1;
        end
    end    
end
