function res = dig2bin( num , bits )
%% Converts a decimal value (num) into the specified number of bits needed
%% Example: dig2bin(5 , 8) returns an 8-bit binary representation of the number 5
%           ans = 
%               00000101

i = 1; count = 0;
B = zeros(1 , bits);
if(num < 0)
    num = 2^(bits) + num;
end

while( num ~= 0)            % keep dividing the decimal value by 2 to see the remainder
    B(i) = rem(num , 2);    % stop when the number can't be divided any futher
    i = i + 1;
    num = floor(num / 2);
    count = count + 1;
end


B = fliplr(B);
B = char(B+'0');            % turn the binary array into a string

res = B;                    % return binary string
end

