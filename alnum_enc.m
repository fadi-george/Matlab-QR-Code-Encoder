function res = alnum_enc( chrc )
% returns value for an Alphanumeric characters

if( (chrc >= '0') && (chrc <= '9') )       % string is ascii digit
    val = 1*chrc - 48;
    
elseif( (chrc >= 'A') && (chrc <= 'Z') )   % uppercase ascii letters
    val = 1*chrc - 55;

elseif( chrc == ' ')                       % space character
    val = 1*chrc + 4;       

elseif( chrc == '$' || chrc == '%' )       % dollar sign or percent sign
    val = 1*chrc + 1;

elseif( chrc == '*' || chrc == '+' )       % asterisk sign or add sign
    val = 1*chrc - 3;

elseif( chrc == '-' || chrc == '.' || chrc == '/' )   % minus sign or dot sign
    val = 1*chrc - 4; 
    
elseif( chrc == ':')                       % colon character
    val = 1*chrc - 14;  

else
    val = 0;
    fprintf('Not a valid character input.\n');
end

res = val;
end

