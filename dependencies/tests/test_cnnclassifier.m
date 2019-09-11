% test cnn_classifier
load('20180330_NETonly.mat'); 
load('routes_10m_2.mat');
max_route_length = 20;
t = [42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61];
desc = [];

parfor_progress('testing', max_route_length);
for m=1 : max_route_length
   curlocation = routes(t(m));
   bad = Cnn_classifier(curlocation, net1, net2);  
   desc = [desc ;bad];
   parfor_progress('testing');
end