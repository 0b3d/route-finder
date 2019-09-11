load('20180330_NETonly', 'net1', 'net2');
load('Tjc.mat');
load('Tbd.mat');
files = dir('new_panos/*jpg');
for m = 1:20
% classifying
% intersection
tmp1 = [];
tmp2 = [];
init_idx = 2*m+1;
try
for i=2:-1:1
    % read and resize image
    idx = init_idx - i;
    filepath = cell2mat(Tjc.imageSet_jc(idx));
    % check: if image doesn't exist
    if isempty(dir(filepath))
        continue;
    end
    I = imresize(imread(filepath), [227 227]);
    % classify image
    [label,~] = classify(net1,I);
    if label == 'cate2'
        desc = 0;
    else
        desc = 1;
    end
    tmp1 = [tmp1, desc];

end

% building gap
for i=2:-1:1
    idx = init_idx - i;
    % read and resize image
    filepath = cell2mat(Tbd.imageSet_bd(idx));
    if isempty(dir(filepath))
        continue;
    end
    I = imresize(imread(filepath), [227 227]);
    % classify image
    [label,~] = classify(net2,I); 
    if label == 'cate2'
        desc = 0;
    else
        desc = 1;
    end
    tmp2 = [tmp2, desc];
end

descriptor(1) = tmp1(1); % front
descriptor(2) = tmp2(2); % right
descriptor(3) = tmp1(2); % back
descriptor(4) = tmp2(1); % left

catch
    disp('error');
end
end