function dist = hamming_dist(desc, desc_new)
% dist = 0;
% for i=1:size(desc,2)
%     if desc(i) ~= desc_new(i)
%         dist = dist+1;
%     end
% end
%[row, col] = find(desc~=desc_new);
dist = size(find(desc~=desc_new), 1);

end