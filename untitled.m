clear all
high_way_flag = [0,0,0,1,1,1,0,0,0];
t = [1,2,3,7,8,9];
q = high_way_flag(t(:));
if sum(high_way_flag(t(:)))
    disp('there is tunels');
else
    disp('there is no tunels');
end
