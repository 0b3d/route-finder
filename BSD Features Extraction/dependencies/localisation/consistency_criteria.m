function loop = consistency_criteria(t_c, t_f, loop, overlap)

idx = find(ismember(t_c,t_f));
overlap_ = size(idx,2)/size(t_f,2);
if overlap_ >= overlap
    loop = loop+1;
else
    loop = 0;
end

end