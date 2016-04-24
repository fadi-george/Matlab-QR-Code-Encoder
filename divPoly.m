function res = divPoly( Mpol , Gpol , ecblok , gftab)
%   Detailed explanation goes here
m1 = length(Mpol);
g1 = length(Gpol);

mExtnd = zeros(1 , m1 + ecblok);
gExtnd = zeros(1 , m1 + ecblok);

mExtnd(1:m1) = Mpol;
gExtnd(1:g1) = Gpol;

for i = 1:m1                               % iterate over total num of data codewords 
    cons = find(gftab == mExtnd(1)) - 2;   % convert lead term to integer notation
    gExtnd(1:g1) = Gpol(1:g1)  + cons;     % multiply alpha terms to gen poly
    gExtnd = mod(gExtnd , 255);            % modulo 255 just in case
   
    for j = 1:g1
        gExtnd(j) = gftab(gExtnd(j) + 2);    % convert back to integer notation
    end
    
    for j = 1:g1
        mExtnd(j) = bitxor(mExtnd(j) , gExtnd(j));  % convert back to integer notation
    end
    mExtnd = mExtnd(2:end);                         % discard first entry

end

res = mExtnd;     % return error correction codewords                   
end

