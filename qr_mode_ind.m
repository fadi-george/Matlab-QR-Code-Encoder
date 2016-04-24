function res = qr_mode_ind( mode )
%% returns bit string to indicate which mode used
%%
switch mode
    case 1                  % Numeric mode
        res = '0001';
    case 2                  % Alphanumeric mode
        res = '0010';
    case 3                  % Byte mode
        res = '0100';
    case 4                  % Kanji mode
        res = '1000';
    case 5                  % ECI mode
        res = '0111';
end

end

