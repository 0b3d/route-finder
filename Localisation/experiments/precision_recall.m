clc
clear all
close all
parameters;

option = [features_type, turns, probs];
%load the results file
load(['Data/',dataset,'/results/',option,'.mat']);

targets = ones(1,test_num);
scores = zeros(1, test_num);

for i=1:test_num
    rank_ = ranking(i,20);
    scores(1,i) = dist{1,i}{20}(rank_);
    if rank_ == 1
        targets(1,i) = 1;
    else 
        targets(1,i) = 0;
    end
end

prec_rec(scores, targets);

