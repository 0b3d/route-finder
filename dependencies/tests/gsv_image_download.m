% gsv image download and crop it to four directions
addpath(genpath('gsv_download_v2')); 
load('routes_10m_gsv.mat', 'routes')
zoom = 3;
download_num = 10;
routes = gsv_download_v4(routes, download_num, zoom);
