% find lost panos
load('tmp4.mat');
load('london_new_locations.mat');

P1 = [];
for i=1:length(routes)
   if ~isempty(routes(i).id)
       P1 = [P1 ; routes(i).id];
   end    
end

P2 = [];
str = 'None                  ';
for i=1:length(pano_id)
   if ~strcmp(pano_id(i,:), str)
       P2 = [P2 ; pano_id(i,:)];
   end    
end

P3 = [];
for i=1:length(P2)
    idx = find(ismember(P1, P2(i,:), 'rows'));
    if isempty(idx)
        P3 = [P3; P2(i,:)];
    end   
end


