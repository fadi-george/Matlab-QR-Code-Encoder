function [res ver] = qr_byte( txt , len , ecc , tcap , terr )
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
    fprintf('Not valid ECC level.\n');
end

while( len > tcap(lookup) )
    lookup = lookup + 4;        % advance four rows in table
end

if((lookup >= 1) && (lookup <= 36))
    bitpad = 8;
elseif((lookup > 36) && (lookup <= 104))
    bitpad = 16;
else
    bitpad = 16;
end

%%    Mode Bit String
%%
mode = qr_mode_ind( 3 );


%%    Mode Bit String
%%
chcount = dig2bin(len , bitpad);    % pad bits

%%    Encoded Data
%%
k = 1; bts = 10; i = 1;
encStr = {};

for k = 1:len
encStr{k} = dig2bin( 1*txt(k) , 8);
end

%%    Add terminator bits
%%
regexprep(strtrim(sprintf('%s ',encStr{:})),'\W','');
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

