% turns histogram
load('./Localisation/test_routes/turn_london_center_09_19_500.mat');

histogram = zeros(500, 3);
for i=1:size(test_turn,1)
    for j=1:size(test_turn,2)
        if test_turn(i,j) == 0
            histogram(i,1) = histogram(i,1)+1;
        elseif test_turn(i,j) == 1
            histogram(i,2) = histogram(i,2)+1;
        else
            histogram(i,3) = histogram(i,3)+1;
        end
    end
end
figure(1)
%bar(histogram(1:50,:));
% figure(2)
 bar(histogram(51:100,:));
% figure(3)
% bar(histogram(101:150,:));
% figure(4)
% bar(histogram(151:200,:));


load('./Localisation/test_routes/turn_tonbridge_500.mat');

histogram = zeros(500, 3);
for i=1:size(test_turn,1)
    for j=1:size(test_turn,2)
        if test_turn(i,j) == 0
            histogram(i,1) = histogram(i,1)+1;
        elseif test_turn(i,j) == 1
            histogram(i,2) = histogram(i,2)+1;
        else
            histogram(i,3) = histogram(i,3)+1;
        end
    end
end
figure(2)
bar(histogram(51:100,:));