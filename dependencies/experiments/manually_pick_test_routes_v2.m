% manually pick test routes
clear all
load('result_1000.mat');
load('test_route_1000.mat');
% required number
total = 150;
p_5 = floor(2 / 100*150);
p_10 = floor(20 / 100*150);
p_15 = floor(58 / 100*150);
p_20 = floor(85 / 100*150);
p_25 = floor(92 / 100*150);
p_30 = floor(96 / 100*150);
p_35 = floor(98 / 100*150);
p_40 = floor(100 / 100*150);


% statistic
num_5 = 0; set_5 = [];
num_10 = 0;set_10 = [];
num_15 = 0;set_15 = [];
num_20 = 0;set_20 = [];
num_25 = 0;set_25 = [];
num_30 = 0;set_30 = [];
num_35 = 0;set_35 = [];
num_40 = 0;set_40 = [];
set_f = [];
for i=1:length(result)
    if result(i,3) == 1 
        route_length = result(i,5);
        if route_length <= 5
            num_5 = num_5 + 1;
            set_5 = [test_route(i,:);set_5];
        elseif route_length <= 10
            num_10 = num_10 + 1;
            set_10 = [test_route(i,:);set_10];
        elseif route_length <= 15
            num_15 = num_15 + 1;
            set_15 = [test_route(i,:);set_15];
        elseif route_length <= 20
            num_20 = num_20 + 1;
            set_20 = [test_route(i,:);set_20];
        elseif route_length <= 25
            num_25 = num_25 + 1;
            set_25 = [test_route(i,:);set_25];
        elseif route_length <= 30
            num_30 = num_30 + 1;
            set_30 = [test_route(i,:);set_30];
        elseif route_length <= 35
            num_35 = num_35 + 1;
            set_35 = [test_route(i,:);set_35];
        elseif route_length <= 40
            num_40 = num_40 + 1;
            set_40 = [test_route(i,:);set_40];
        end
    else
        set_f = [test_route(i,:);set_f];
    end
end

N_5 = 0;
N_10 = p_10 - N_5;
N_15 = p_15-N_10;
N_20 = p_20 - N_15 - N_10;
N_25 = p_25 - N_20 - N_15 - N_10;
N_30 = p_30 - N_25 - N_20 - N_15 - N_10;
N_35 = p_35 - N_30 - N_25 - N_20 - N_15 - N_10;
% N_40 = p_40 - N_35 - N_30 - N_25 - N_20 - N_15 - N_10;
N_40 = 1;
N_f = total - N_40 - N_35 - N_30 - N_25 - N_20 - N_15 - N_10;

test_route_new = [];
test_route_new = [set_10(1:N_10,:);set_15(1:N_15,:);set_20(1:N_20,:);set_25(1:N_25,:);...
                   set_30(1:N_30,:);set_35(1:N_35,:);set_40(1:N_40,:);set_f(1:N_f,:)];
test_route = test_route_new;




