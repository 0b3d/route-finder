function panos = bfs_download_v3(seed_panoid, download_number, zoom, boundary)
city = 'London';
outfolder = 'test';

panos(download_number,1).id = []; % panoid
panos(download_number,1).coords = []; % geographic coordinates
panos(download_number,1).yaw = NaN; % yaw direction
panos(download_number,1).tiltyaw = NaN;
panos(download_number,1).tiltpitch = NaN;
panos(download_number,1).remove = false; % if this pano is invalid

% Set environmental variable
setenv('PATH', '/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/X11/bin:/usr/texbin'); % for wget

if ~exist(outfolder,'dir')
    mkdir(outfolder)
end

% in case this bfs was previously initiated
files = dir([outfolder '/*.xml']);
files = {files.name}';
for i = 1:length(files)
    files{i} = files{i}(1:end-4);
end

cnt = 1;

panoidAll = {seed_panoid};
downloadAll = false(1); % 1 by 1 array of logical zeros

failed_panoids = {};

while cnt < download_number+1
    tic;
    try % execute statements and catch resulting error
        % for i=length(downloadAll):-1:1 % dfs
        for i=1:length(downloadAll) % bfs
            if downloadAll(i)==false
                break;
            end
        end
        if downloadAll(i)==true
            break;
        end
        %cnt = cnt + 1;
        
        skip = false;
        % check previously downloaded
        if(ismember(panoidAll{i}, files))
            skip = true;
            disp('skipping');
        end
        
        % panoids = downloadPano(panoidAll{i}, outfolder, zoom, skip);
        % panoids = downloadPano_v2(panoidAll{i}, outfolder, zoom, skip);
        [panoids, fname, pname] = downloadPano_v4(panoidAll{i}, outfolder, zoom, skip);        
        % assign attributes to GSV panoramas based on OSM and store in "panos" struct
        pano = get_pano_info(boundary, fname);
        
        if skip == false && pano.remove == false
            panos(cnt).id = pano.id; % panoid
            panos(cnt).coords = pano.coords; % geographic coordinates
            panos(cnt).yaw = pano.yaw; % yaw direction
            panos(cnt).tiltyaw = pano.tiltyaw;
            panos(cnt).tiltpitch = pano.tiltpitch;
            panos(cnt).remove = pano.remove; % if this pano is invalid
            cnt = cnt+1;
        elseif pano.remove == true
            delete(fname);
            delete(pname);
        end
                    
        downloadAll(i)=true;
        
        for i=1:length(panoids)
            Idx = find(ismember(panoidAll,panoids{i})==1);  % find non-zero elements
            if isempty(Idx)
                panoidAll{end+1} = panoids{i};
                downloadAll(end+1) = false;
                Idx = length(downloadAll);
            end
        end
        disp([city ' image ' num2str(cnt) ' took ' num2str(toc) ' seconds']);
    catch error
        disp(['Fail on image ' num2str(cnt)]);
        disp(error);
        failed_panoids{end+1,1} = panoidAll{i};
        downloadAll(i) = true; % skipping this failure
        save(['failed_panoids.mat'], 'failed_panoids');       
    end
end
end
