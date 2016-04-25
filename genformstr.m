function res = genformstr( ecc , masknum )
% Generate Format String (15 bits)

if(ecc == 'L')
    ecbits = '01';
    
elseif(ecc == 'M')
    ecbits = '00';
    
elseif(ecc == 'Q')
    ecbits = '11';
    
elseif(ecc == 'H')
    ecbits = '10';
else
    error('Not a valid correction level.');
end
maskbits = dig2bin( masknum , 3);
fivbits = strcat(ecbits , maskbits);

bitss = strcat(fivbits, dig2bin(0,10));
k = 1;
zroflag = 0;

while(bitss(k) == '0')
    k = k + 1;
    if(k == 16)
        k = 1;
        zroflag = 1;
        break;
    end
end

if(zroflag)
    res = '101010000010010';
else
    bitss = bitss(k:end);
    
    genpstr = '10100110111';
    bits1   = bitss;
    k = 1;
    
    while(length(bits1) > 10)
        
        % see difference in lengths
        dif = length(bits1)-length(genpstr);
        
        % pad gen poly str if needed
        genp1 = strcat(genpstr , dig2bin(0,dif));
        
        % xor bits
        bits1  = regexprep( num2str(genp1 ~= bits1) , '\W' , '');
        
        % remove leading zeros in result
        while(bits1(k) == '0')
            k = k + 1;
        end
        bits1 = bits1(k:end);
        k = 1;
    end
    
    if(length(bits1) < 10)
        bits1 = strcat(dig2bin(0 , 10 - length(bits1)) , bits1);
    end
    
    %% Combine XOR result with 5-bit format string
    cmbnd = strcat(fivbits , bits1);
    
    %% Final XOR with string 101010000010010
    res = regexprep( num2str(cmbnd ~= '101010000010010') , '\W' , '');
end

end

