function desc = bit_flipped_v3(desc, accuracy_jc, accuracy_njc, accuracy_bd, accuracy_nbd)
% desc(1) - front, desc(2) - right, desc(3) - back, desc(4) - left
for i=1:size(desc, 2)
    alphabet = [1, 0];
    if i == 1 || i == 3        
        if desc(i) == 1        
            prob = [accuracy_jc, (1-accuracy_jc)];
            desc(i) = randsrc(1, 1, [alphabet;prob]);
        else
            prob = [(1-accuracy_njc), accuracy_njc];
            desc(i) = randsrc(1, 1, [alphabet;prob]);
        end            
    else
         if desc(i) == 1        
            prob = [accuracy_bd, (1-accuracy_bd)];
            desc(i) = randsrc(1, 1, [alphabet;prob]);
        else
            prob = [(1-accuracy_nbd), accuracy_nbd];
            desc(i) = randsrc(1, 1, [alphabet;prob]);
         end 
    end
end
end