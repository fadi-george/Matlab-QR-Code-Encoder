function res = intrLv( dCodW , eCodW , errcaprow)
%% interleaves data codeworks and error codewords
% 
rows = errcaprow(3)+errcaprow(5);   % add up number of blocks to determine rows

%% allocate space for data and error values
%%
fils = zeros(1 , (errcaprow(1) + (errcaprow(3)+errcaprow(5))*errcaprow(2)));
if(rows == 1)
    fils = [dCodW eCodW];
else
    k = 1;
    
    for col = 1:errcaprow(4)
        for rws = 1:rows   
            fils(k) = dCodW(rws , col);
            k = k + 1;
        end
    end
    for i = 1:errcaprow(5)
        fils(k) = dCodW(errcaprow(3) + i , errcaprow(6));
        k = k + 1;
    end
    for col = 1:errcaprow(2)
        for rws = 1:rows   
            fils(k) = eCodW(rws , col);
            k = k + 1;
        end
    end
end

res = fils;
end

