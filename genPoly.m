function res = genPoly( numecc , gftab )

p1 = [ 0 0 ];               % starting poly
k = 2;

if( numecc < 7 )
    error('Minimum of 7 Error Codewords per Block is required.');
end

for i = 1:(numecc-1)
    pp = zeros(1,k + 1);

    p2 = [0 i];
    np2 = p1 + i;
    np2 = mod(np2 , 255);
    pp(end) = np2(end);
    
    for j = 2:k
        
        num1 = gftab(p1(j)  + 2);           % look up integer equivalent
        num2 = gftab(np2(j-1) + 2);
        nxor = bitxor(num1 , num2);         % xor values
        nalp = find(gftab == nxor) - 2;
        pp(j) = nalp;
    end
    
    p1 = pp;
    k = k + 1;
end

res = pp;
end

