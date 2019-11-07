clc
clear all
close all

datasets = {'scattered_london'};
legend_text = {'London'};


% datasets = { 'edinburgh_10_19', 'london_10_19','luton_v4','oxford_10_19', 'tonbridge_v2'}
% legend_text = {'Edinburgh','London','Luton', 'Oxford', 'Tonbridge'};

%datasets = {'newyork_10_19', 'paris_10_19', 'rome_v1', 'toronto_v1', 'washington_10_19'}
%legend_text = {'New York','Paris', 'Rome', 'Toronto','Washington'};

% datasets = {'newyork_10_19', 'washington_10_19', 'rome_v1', 'paris_10_19', 'toronto_v1', 'london_10_19', 'edinburgh_10_19', 'oxford_10_19', 'tonbridge_v2', 'luton_v4'}
% legend_text = {'New York', 'Washington', 'Rome', 'Paris', 'Toronto','London', 'Edinburgh', 'Oxford', 'Tonbridge', 'Luton'};
dt = 0.030;
top1p = zeros(1, length(dataset));
for dset_index=1:length(datasets)
    dataset = datasets{dset_index};
    features_filename = ['features/ES/',dataset,'.mat'];
    % regenerate to be sure to use latest features
    load(features_filename)

    %     % get pairwise distances
    distances = pdist2(Y,X); %y-x distances
    [sorted_distances, sorted_indices] = sort(distances, 2, 'ascend'); 
    labels = [1:1:size(Y,1)];
    
    geographic_distances = zeros(size(labels,2),size(labels,2));
    acc = 0;
    %sumas = zeros(1,size(X,1));
    for k=1:100 %size(Y,1)
        for i=1:size(Y,1)
            gt_lat = gsv_lat(1,i);
            gt_lon = gsv_lon(1,i);
            pred_index = sorted_indices(i,k);
            pred_lat = gsv_lat(1,pred_index);
            pred_lon = gsv_lon(1,pred_index);
            d = distance(pred_lat, pred_lon, gt_lat, gt_lon);
            geo_distance = deg2km(d);
            geographic_distances(i, k) = geo_distance;
        end
    end
                


%     ranking = zeros(1,size(labels,2));
%     for i=1:size(labels,2)
%        ranking(1,i) = find(labels(1,i) == sorted_indices(i,:));
%     end
% 
%     accuracy = zeros(1,size(labels,2));
%     for k = 1:size(labels,2)
%         accuracy(1,k) = sum(ranking <= k) / size(ranking, 2);
%        
%         if k == floor(0.01 * size(labels,2))
%             top1p(dset_index,1) = accuracy(1,k);
%         end
%     end
% 
%     x = labels / size(labels,2);
% 
%     plot(x,accuracy,'LineWidth',2.0)
%     hold on

end

a = (geographic_distances(:,1:100) <= 0.030);
acc = sum(any(a,2))/size(Y,1);
% xlabel('k (as a fraction of the dataset length)', 'FontName', 'Times', 'fontsize', 10)
% ylabel('Top k recall', 'FontName', 'Times', 'fontsize', 10)
% legend(legend_text, 'FontName', 'Times', 'fontsize', 10)
% grid on

