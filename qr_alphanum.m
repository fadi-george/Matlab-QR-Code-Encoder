function [res  ver] = qr_alphanum( txt , len , ecc , tcap , terr)
% Encoded Portion is Composed of 3 Parts
%------------.-----------------.--------------.
% Mode Indic | Character Count | Encoded Data |
%------------.-----------------.--------------.
cnt = 0; tog = 0; extrr = 0;

%%    Access char capacitie table
%%
if    ( ecc == 'L' )
    lookup = 1;
elseif( ecc == 'M' )
    lookup = 2;
elseif( ecc == 'Q' )
    lookup = 3;
elseif( ecc == 'H' )
    lookup = 4;
else
    error('Not valid ECC level.\n');
end

while( len > tcap(lookup) )
    lookup = lookup + 4;        % advance four rows in table
end

if((lookup >= 1) && (lookup <= 36))
    bitpad = 9;
elseif((lookup > 36) && (lookup <= 104))
    bitpad = 11;    
else
    bitpad = 13;   
end

%%    Mode Bit String
%%
mode = qr_mode_ind( 2 );

%%    Mode Bit String
%%
chcount = dig2bin(len , bitpad);    % pad bits 

%%    Encoded Data
%%
k = 1; bts = 11;
if(mod(len , 2))            % encoding in pais
    lim = (len + 1)/2;      % account for odd number of characters
    odnum = 1;
else
    lim = (len)/2;
    odnum = 0;
end
encStr = cell(1,lim);

for i = 1:lim
    
    if((i == lim) && (odnum))
            pair = alnum_enc(txt(k));
            bts = 6;
    else      
        pair = 45*alnum_enc(txt(k)) + alnum_enc(txt(k+1));
    end
    
    encStr{i} = dig2bin(pair , bts);
    k = k + 2;
end

%%    Add terminator bits
%%

curr = horzcat(mode , chcount , regexprep(strtrim(sprintf('%s ',encStr{:})),'\W',''));
clen = length(curr);
bitlen = terr(lookup)*8;

if( clen < bitlen )
    if(terr(lookup)*8 - clen > 4)
        termn = '0000';
        i=4;
    else
        
        for i = 1:4
            if(i == (bitlen - clen))
                termn = dig2bin(0,i);
                break;
            end
        end
    end
    
    %%    Add any extra zero bits
    %%
    clen2 = clen + i;
    if( mod(clen2, 8) ~= 0)
        while(mod(clen2, 8) ~= 0)
            clen2 = clen2 + 1;
            extrr = extrr + 1;
        end
        
        exBits = dig2bin(0,extrr);
    else
        exBits = '';
    end
    
    curr2 = horzcat(curr,termn,exBits);
    clen2 = length(curr2);
    
    %%    Add any extra zero bits
    %%
    if(clen2 < bitlen)
        exByts = bitlen - clen2;
        ByStr  = cell(1,exByts/8);
        i = 1;
        while(exByts > 0)
            if(~tog)
                ByStr{i} = '11101100';  % 237
            else
                ByStr{i} = '00010001';  % 17
            end
            tog = ~tog;                 % toggle bit
            i = i + 1;
            exByts = exByts - 8;
        end
        res = horzcat(curr2 , regexprep(strtrim(sprintf('%s ',ByStr{:})),'\W',''));

    else
        ByStr = '';
        res = curr2;
    end
    
else
    res = curr;
end

ver = lookup;
end