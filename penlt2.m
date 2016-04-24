function numpn = penlt2( qrmat )
% Calculates up 3 for every 2 by 2 block (overlapping included)
sum = 0;

for i = 1:length(qrmat)-1         % go through every row
    for j = 2:length(qrmat)       % and column
        %% Matching 2x2 block entries
        %% check for black block
        if((qrmat(i,j) == 0) && (qrmat(i,j-1) == 0))
            if((qrmat(i+1,j) == 0) && (qrmat(i+1,j-1) == 0))
                sum = sum + 3;
            end
        % check for white block
        elseif((qrmat(i,j) == 1) && (qrmat(i,j-1) == 1))
            if((qrmat(i+1,j) == 1) && (qrmat(i+1,j-1) == 1))
                sum = sum + 3;
            end
        end
    end
end

numpn = sum;
end

