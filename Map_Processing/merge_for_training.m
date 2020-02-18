% merge ways, intersections and buildings for training
clear all
city = 'train';
city_1 = 'manhattan';
city_2 = 'pittsburgh';
load(['Data/',city_1,'/inters_after_filter.mat']);
load(['Data/',city_1,'/buildings.mat']);
inters_1 = inters;
buildings_1 = buildings;

clear inters
clear buildings

load(['Data/',city_2,'/inters_after_filter.mat']);
load(['Data/',city_2,'/buildings.mat']);
inters_2 = inters;
buildings_2 = buildings;

clear inters
clear buildings

if ~exist(['Data/',city,'/'],'dir')
    mkdir(['Data/',city,'/']);
    % merge inters
    sz1 = size(inters_1,2);
    sz2 = size(inters_2,2);
    inters = struct();
    for i=1:sz1+sz2
        if i <= sz1
            inters(i).coords=inters_1(i).coords;
        else
            inters(i).coords=inters_2(i-sz1).coords;
        end   
    end
    save(['Data/',city,'/inters_after_filter.mat'], 'inters');

    % merge buildings
    sz1 = size(buildings_1,2);
    sz2 = size(buildings_2,2);
    buildings = struct();
    for i=1:sz1+sz2
        if i <= sz1
            buildings(i).coords=buildings_1(i).coords;
        else
            buildings(i).coords=buildings_2(i-sz1).coords;
        end   
    end
    save(['Data/',city,'/buildings.mat'], 'buildings');    
else
    disp('Folder in Data already exists')
end




