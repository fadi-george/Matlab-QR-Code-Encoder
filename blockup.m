function res = blockup( rawbits , luval , errcap)
%   Seperate BitStrings into different blocks
numblks = errcap(luval , 3) + errcap(luval , 5);
blcks = cell(1,numblks);
k = 1;

for i = 1:numblks 
    if(i < errcap(luval , 3) + 1)
        blcks(i) = {rawbits(k : k + 8*errcap(luval , 4) - 1)};
        k = k + 8*errcap(luval , 4);
    else
        blcks(i) = {rawbits(k : k + 8*errcap(luval , 6) - 1)};
        k = k + 8*errcap(luval , 6);
    end
   
end
   
res = blcks;
end

