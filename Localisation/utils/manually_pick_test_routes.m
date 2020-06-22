% manually pick test routes
clear all
load('result.mat');
load('test_route_500.mat');
failed_idx = [];
succeed_idx = [];
test_route_new = [];
for i=1:length(result)
    if result(i,3)==1 && result(i,5)<=20
        succeed_idx = [succeed_idx;i]; % 170
%         failed_idx = [failed_idx;i]; % 150
    else
        failed_idx = [failed_idx;i]; % 30
%         succeed_idx = [succeed_idx;i]; % 50
    end
end
test_route_new = [test_route(failed_idx(1:30),:);test_route(succeed_idx(1:170),:)];
test_route = test_route_new;

