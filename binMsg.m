function res = binMsg( vec )
% Takes in vector, Converts Numbers to Binary
msgStr = char(zeros(1,8*length(vec)));
k = 1;
for i = 1:length(vec)
    msgStr(k:k+7) = dig2bin( vec(i) , 8 );
    k = k + 8;
end

res = msgStr;
end

