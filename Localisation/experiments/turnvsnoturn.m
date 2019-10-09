%% Plot turn vs no turn 
% statistic reults
clear all
close all
parameters;
datasets = {'paris_10_19'};
color_map = {'b','r','g','y','m','c','k'};
turns_set = {'true','false'};
figure(3)
k = 1;
probs = 'true'


for d=1:length(datasets)
    dataset = datasets{d};
    %color = color_map{d};
    % Plot a line for each turn case
    for t=1:length(turns_set)
        turn_opt = turns_set{t};
        option = [features_type, turn_opt ,probs]; 
        load(['Data/',dataset,'/results/',option,'.mat']); %the results
        % Extract the size of R_ without route filter
        % without turn filters the size is the same for all turns
        possible_points_wt = zeros(test_num,max_route_length_init);
        for route=1:test_num
            for m=1:max_route_length_init
                [a,b] = size(ranked_points_of_routes{1,route}{1,m});
                possible_points_wt(route,m) = a; 
            end
        end
        possible_points_wt = possible_points_wt ./ size(routes, 2);
        possible_points = mean(possible_points_wt, 1);
        
        if strcmp(features_type, 'ES')
            line = '-';
        else
            line = '--';
        end

        if strcmp(turn_opt, 'true')
            color = 'b';
        else
            color = 'r';
        end
        
        plot(sum(ranking <= k, 1)./size(result_final,1), 'LineStyle', line, 'Color', color)
        hold on
        plot(possible_points,'LineStyle', line, 'Color', color, 'Marker', '+')
    end
    % Here plot the number of routes left 
    grid on
end
xlabel('Node')
ylabel('Percentage')
legend_names = {'Accuracy with turns','Routes with turns','Accuracy without turns','Routes without turns'};
legend(string(legend_names), 'Location', 'southeast')
