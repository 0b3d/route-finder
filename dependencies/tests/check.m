load('old_london_center.mat');
missed_idx = [];
for i=1:length(routes)
   if isempty(routes(i).id)
       missed_idx = [missed_idx;i];
   end    
end