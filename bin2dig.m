function res = bin2dig( bitstr )
%   Detailed explanation goes here
if(iscellstr(bitstr))
    blen = length(bitstr{1});
    bflp = fliplr(bitstr{1});
else
    blen = length(bitstr);
    bflp = fliplr(bitstr);
end

sum = 0;

for i = 1:blen
    sum = sum + (2^(i-1))*(str2double(bflp(i)));
end

res = sum;
end

