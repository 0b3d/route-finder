% statistic_single_route
clear all
close all
load('Data/result_tonbridge.mat');
load('Data/tonbridge/routes_small_withBSD_75.mat');
load('Data/test_routes/tonbridge_routes_500_60.mat');
load('Data/test_routes/tonbridge_turns_500_60.mat');
t = test_route(45,:);
T = test_turn(45,:);
R = struct();
for i=1:20
    idx = t(i);
    R(i).BSDs = routes(idx).BSDs;
    R(i).CNNs = routes(idx).CNNs;    
end

counts = zeros(2, 16);
for i=1:length(R)
    if isempty(R(i).BSDs)
        continue;
    else
        idx1 = (bi2de(R(i).BSDs))+1;
        idx2 = (bi2de(R(i).CNNs))+1;
        counts(1,idx1) = counts(1,idx1)+1;
        counts(2,idx2) = counts(2,idx2)+1;
    end
end 
figure(1)
bar(counts')

histogram = zeros(1, 2);
for i=1:20
    if T(i) == 0
        histogram(1) = histogram(1)+1;
    else 
        histogram(2) = histogram(2)+1;
    end
end
figure(2)
bar(histogram);