function numpn = penlt4( qrmat )
% Determine ratio of light modules to dark modules

len = length(qrmat);
%% total number of modules
tot = len*len;              

%% count total number of dark modules
numdk = 0;
for i = 1:len
    for j = 1:len
        if( qrmat(i , j) == 0 )     
            numdk = numdk + 1;
        end
    end
end

%% percentage of dark modules
pmod = ((numdk / tot)*100);
pmod = floor(pmod);

%% cloest multiple of 5
k = 0;
while(mod((pmod+k),5) ~= 0)
    k = k + 1;
end
himul5 = pmod + k;

k = 0;
while(mod((pmod-k),5) ~= 0)
    k = k + 1;
end
lomul5 = pmod - k;

%% subtract 50 and take absolute values
himul5 = abs(himul5 - 50);
lomul5 = abs(lomul5 - 50);

%% divide each by 5
himul5 = himul5/5;
lomul5 = lomul5/5;

%% take minimum of two and multiply it by 10
numpn = min( himul5 , lomul5) * 10;
end

