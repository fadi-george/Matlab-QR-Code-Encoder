function res = genMPoly( bitstr )
% Takes in abit string
numcof = length(bitstr)/8;
Cof = zeros(1 , numcof);      % Initialize Coeff Array
k = 1;

for i = 1:numcof
    byt = bitstr(k:k+7);           % cut out byte segments
    Cof(i) = bin2dig(byt);
    k = k + 8;
end

res = Cof;
end

