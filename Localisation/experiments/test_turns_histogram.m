% turns histogram
load('Data/test_routes/tonbridge_turns_500_60.mat');

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
bar(histogram(1:100,:));
figure(2)
bar(histogram(101:200,:));
figure(3)
bar(histogram(201:300,:));
figure(4)
bar(histogram(301:400,:));
figure(5)
bar(histogram(401:500,:));