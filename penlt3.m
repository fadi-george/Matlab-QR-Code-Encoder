function numpn = penlt3( qrmat )
% Checks for a pattenr corresponding to dark-light-dark-dark-dark-light-dark
% with four light on either side
sum = 0;
pat1 = [0 1 0 0 0 1 0 1 1 1 1];
pat2 = [1 1 1 1 0 1 0 0 0 1 0];

for i = 1:length(qrmat)
    for j = 1:length(qrmat)-10
        % check rows for the two patterns
        if(isequal(qrmat(i,j:j+10) , pat1))
            sum = sum + 40;
        end
        if(isequal(qrmat(i,j:j+10) , pat2))
            sum = sum + 40;    
        end
        
        % check columns for the two patterns
        if(isequal(qrmat(j:j+10,i) , pat1'))
            sum = sum + 40;
        end
        if(isequal(qrmat(j:j+10,i) , pat2'))
            sum = sum + 40;  
        end          
    end
end

numpn = sum;
end

