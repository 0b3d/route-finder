function bfs_download_v2(seed_panoid, download_number, zoom)
city = 'London';
outfolder = 'test';

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

cnt = 0;

panoidAll = {seed_panoid};
downloadAll = false(1); % 1 by 1 array of logical zeros

failed_panoids = {};

while cnt < download_number
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
        cnt = cnt + 1;
        
        skip = false;
        % check previously downloaded
        % if(ismember(panoidAll{i}, files))
        %     skip = true;
        %     disp('skipping');
        % end
        
        % panoids = downloadPano(panoidAll{i}, outfolder, zoom, skip);
        panoids = downloadPano_v2(panoidAll{i}, outfolder, zoom, skip);
        
        downloadAll(i)=true;
        
        for i=1:length(panoids)
            Idx = find(ismember(panoidAll,panoids{i})==1);  % find non-zero elements
            if isempty(Idx) && length(panoidAll)<download_number
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
