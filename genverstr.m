function res = genverstr( ver )
% Generates an 18 bit version string

genpstr = '1111100100101';
ver6 = dig2bin(ver , 6);                  % six bit version string
verstr = strcat(ver6 , dig2bin(0 , 12));  % make 18 bits long
k = 1;

while(verstr(k) == '0')
    k = k + 1;
    if(k == 16)
        k = 1;
        zroflag = 1;
        break;
    end
end
verstr = verstr(k:end);
k = 1;

while( length(verstr) > 12 )
    
    dif = length(verstr)-length(genpstr);
    
    % pad generator string with number of needed zeros
    genp1 = strcat(genpstr , dig2bin(0,dif));
    
    % xor bit strings together
    verstr = regexprep( num2str(verstr ~= genp1) , '\W' , '');
    
    % remove leading zeros in result
    while(verstr(k) == '0')
        k = k + 1;
    end
    verstr = verstr(k:end);
    k = 1;
end

% Pad String if length is less than 12
if(length(verstr) < 12)
    verstr = strcat(dig2bin(0 , 12 - length(verstr)) , verstr);
end

% concate 6 bit version string with xord result
res = strcat(ver6 , verstr);        
end

