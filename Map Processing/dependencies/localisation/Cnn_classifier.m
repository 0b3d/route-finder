function descriptor = Cnn_classifier(curlocation, net1, net2)
% download relevant image
zoom = 3;
download_num = 1;
curlocation = gsv_download_v2(curlocation, download_num, zoom);

% save data in table form
filepath = 'test_snaps/';
[Tjc, Tbd] = genTabel(filepath, curlocation);

% classifying
% intersection
tmp1 = [];
tmp2 = [];
for i=1:size(Tjc, 1)
    % read and resize image
    filepath = cell2mat(Tjc.imageSet_jc(i));
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
for i=1:size(Tbd, 1)
    % read and resize image
    filepath = cell2mat(Tbd.imageSet_bd(i));
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

descriptor(1) = tmp1(1);
descriptor(2) = tmp2(2);
descriptor(3) = tmp1(2);
descriptor(4) = tmp2(1);

end