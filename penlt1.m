function numpn = penlt1( qrmat )
% Calculate Penalties
cnt1 = 1; cnt2 = 1;
pen1 = 0; pen2 = 0;
for i = 1:length(qrmat)
    for j = 2:length(qrmat)
        %% check rows for consecutive modules
        if(mod(qrmat(i,j),2) == mod(qrmat(i,j-1),2))
            cnt1 = cnt1 + 1;
            if((j == length(qrmat)))
                if(cnt1 >= 5)
                    pen1 = pen1 + (cnt1 - 2);
                end
                cnt1 = 1;
            end
        else
            if(cnt1 >= 5)
                pen1 = pen1 + (cnt1 - 2);
            end
            cnt1 = 1;
        end
        
        %% check columns for consecutive modules
        if(mod(qrmat(j,i),2) == mod(qrmat(j-1 ,i),2))
            cnt2 = cnt2 + 1;
            if((j == length(qrmat)))
                if(cnt2 >= 5)
                    pen2 = pen2 + (cnt2 - 2);
                end
                cnt2 = 1;
            end
        else
            if(cnt2 >= 5)
                pen2 = pen2 + (cnt2 - 2);
            end
            cnt2 = 1;
        end
    end
    
end

numpn = pen1 + pen2;
end

