function res = qrmodule( ver , btst , alnvec , ecc)
% Draw Qr Code
% Compliment BitString Bits
btstr = regexprep(num2str(btst ~= char(ones(1,length(btst))+48)) , '\W' ,'');

qrs = (((ver-1)*4)+21);            % module size
finder =   [0 0 0 0 0 0 0;         % finder pattern
            0 1 1 1 1 1 0;         % zeros -> black
            0 1 0 0 0 1 0;         % ones  -> white
            0 1 0 0 0 1 0;
            0 1 0 0 0 1 0;
            0 1 1 1 1 1 0;
            0 0 0 0 0 0 0];
seps = ones(1,7);                % seperator vector
seps2 = ones(8,1);               % column seperator vector
qrcod = ones(qrs , qrs);         % initial matrix;

exwh = 8;

qzone = ones(qrs + exwh , qrs + exwh);    % quiet zone
qrcod = qrcod + 1;

%% Finder Patterns
%%
qrcod(1:7,1:7) = finder;                 % top left corner
qrcod(qrs-6:qrs,1:7) = finder;           % bottom left corner
qrcod(1:7,qrs-6:qrs) = finder;           % top right corner

%% Add Seperators
%%
qrcod(8,1:7)             = seps;           qrcod(1:8,8)            = seps2;
qrcod(8,qrs-6:qrs)       = seps;           qrcod(1:8,qrs-7)        = seps2;
qrcod(qrs-7,1:7)         = seps;           qrcod(qrs-7:qrs,8)      = seps2;

%% Add Alignment Patterns
%%
if(ver > 1)
    algnpat =  [0 0 0 0 0;
                0 1 1 1 0;
                0 1 0 1 0;
                0 1 1 1 0;
                0 0 0 0 0];
    
    cnt = nnz(alnvec);
    for i = 1:cnt
        rw = alnvec(i) + 1;
        for j = 1:cnt
            cl = alnvec(j) + 1;
            if( qrcod(rw , cl) )
                rr = rw - 2;
                cc = cl - 2;
                qrcod(rr:rr+4 , cc:cc+4) = algnpat;
            end
        end
    end
    
end
%% Add Timing Patterns
%%
tog = 0;
qrcod(9,1:8) = 3;                           % Reserve area to the right of Top Left Finder
qrcod(1:9,9) = 3;                           % Reserve area to the bottom of the Top Left Finder
for i = 1:(qrs - 16)
    qrcod(7,i+8) = tog;
    qrcod(i+8,7) = tog;
    tog = ~tog;
end

%% Add Dark Module & Reserved Areas
%%
qrcod((4 * ver) + 9 + 1, 8 + 1) = 0;        % draw dark module
qrcod(9,qrs-7:qrs) = 3;                     % reserve format information
qrcod(qrs-6:qrs,9) = 3;

extraSp = 7;

if( ver >= 7 )                              % reserve version informatio
    qrcod(qrs-10:qrs-8,1:6) = 3;
    qrcod(1:6,qrs-10:qrs-8) = 3;
    extraSp = 10;
end
%% Place Bits
%%
resbts = zeros(1 , 8);
qrmsk1 = qrcod; qrmsk2 = qrcod; qrmsk3 = qrcod; qrmsk4 = qrcod;
qrmsk5 = qrcod; qrmsk6 = qrcod; qrmsk7 = qrcod; qrmsk8 = qrcod;

i = qrs;    j =   qrs;
k = 1;      dirUp = 1;
cnt = 0;

while((i ~= qrs - extraSp) || (j ~= 2))
    if(dirUp)                                           % going up
        if((qrcod(i,j) == 2) && (qrcod(i,j-1) == 2))    % fill if empty
            qrcod(i,j) = str2double(btstr(k));
            qrcod(i,j-1) = str2double(btstr(k+1));
            %% Mask Patterns
            %%
            resbts = maskpat( qrcod(i,j) , i , j );
            qrmsk1(i,j) = resbts(1); qrmsk3(i,j) = resbts(3); qrmsk5(i,j) = resbts(5); qrmsk7(i,j) = resbts(7);
            qrmsk2(i,j) = resbts(2); qrmsk4(i,j) = resbts(4); qrmsk6(i,j) = resbts(6); qrmsk8(i,j) = resbts(8);
            
            resbts = maskpat( qrcod(i, (j - 1)) , i , (j - 1) );
            qrmsk1(i,j-1) = resbts(1); qrmsk3(i,j-1) = resbts(3); qrmsk5(i,j-1) = resbts(5); qrmsk7(i,j-1) = resbts(7);
            qrmsk2(i,j-1) = resbts(2); qrmsk4(i,j-1) = resbts(4); qrmsk6(i,j-1) = resbts(6); qrmsk8(i,j-1) = resbts(8);
            %%
            
            k = k + 2;                                  % move forward in string
            cnt = cnt + 2;
            if(i == 1)
                j = j - 2;
                dirUp = ~dirUp;
            else
                i = i - 1;                              % move up a row
            end
        elseif((i == qrs) && (j == 9))                  % near bottom left finder pattern
            i = i - 8;
        elseif((qrcod(i,j-1) == 1) && (qrcod(i,j) == 0))    % check if horizontal timer pattern
            if(qrcod(i-1,j) == 3)
                i = 1;
                j = qrs - 11;
                dirUp = ~dirUp;
                for i = 1:6
                    qrcod(i,j) = str2double(btstr(k));
                    %% Mask Patterns
                    %%
                    resbts = maskpat( qrcod(i,j) , i , j );
                    qrmsk1(i,j) = resbts(1); qrmsk3(i,j) = resbts(3); qrmsk5(i,j) = resbts(5); qrmsk7(i,j) = resbts(7);
                    qrmsk2(i,j) = resbts(2); qrmsk4(i,j) = resbts(4); qrmsk6(i,j) = resbts(6); qrmsk8(i,j) = resbts(8);
                    %%
                    k = k + 1;
                end
                cnt = cnt + 6;
                i = i + 1;
                j = j + 1;
            else
                i = i - 1;
            end
        elseif((qrcod(i,j-1) == 0) && (qrcod(i,j) == 0))    % check for align pattern
            i = i - 5;                                      % move up five rows
        elseif((qrcod(i,j-1) == 2) && (qrcod(i,j) == 0))    % check to left of align pattern
            qrcod(i,j-1) = str2double(btstr(k));            % put bit to the left
            %% Mask Patterns
            %%
            resbts = maskpat( qrcod(i,j-1) , i , (j - 1 ));
            qrmsk1(i,j-1) = resbts(1); qrmsk3(i,j-1) = resbts(3); qrmsk5(i,j-1) = resbts(5); qrmsk7(i,j-1) = resbts(7);
            qrmsk2(i,j-1) = resbts(2); qrmsk4(i,j-1) = resbts(4); qrmsk6(i,j-1) = resbts(6); qrmsk8(i,j-1) = resbts(8);            
            %%
            k = k + 1;
            cnt = cnt + 1;
            i = i - 1;
        else
            if((i == 9) && (j == 9))
                j = j - 3;                                  % move left of vertical timing pattern
            else
                j = j - 2;                                  % move left two columns
            end
            i = i + 1;                                  % go back to previous row
            dirUp = ~dirUp;                                 % flip directions
        end
    else
        if((qrcod(i,j) == 2) && (qrcod(i,j-1) == 2))    % fill if empty
            qrcod(i,j) = str2double(btstr(k));
            qrcod(i,j-1) = str2double(btstr(k+1));
            %% Mask Patterns
            %%
            resbts = maskpat( qrcod(i,j) , i , j );
            qrmsk1(i,j) = resbts(1); qrmsk3(i,j) = resbts(3); qrmsk5(i,j) = resbts(5); qrmsk7(i,j) = resbts(7);
            qrmsk2(i,j) = resbts(2); qrmsk4(i,j) = resbts(4); qrmsk6(i,j) = resbts(6); qrmsk8(i,j) = resbts(8);
            
            resbts = maskpat( qrcod(i,j-1) , i , j-1 );
            qrmsk1(i,j-1) = resbts(1); qrmsk3(i,j-1) = resbts(3); qrmsk5(i,j-1) = resbts(5); qrmsk7(i,j-1) = resbts(7);
            qrmsk2(i,j-1) = resbts(2); qrmsk4(i,j-1) = resbts(4); qrmsk6(i,j-1) = resbts(6); qrmsk8(i,j-1) = resbts(8);
            %%
            k = k + 2;                                  % move forward in string
            cnt = cnt + 2;
            if(i == qrs)
                j = j - 2;
                dirUp = ~dirUp;
            else
                i = i + 1;                                  % move up a row
            end
        elseif((qrcod(i,j-1) == 1) && (qrcod(i,j) == 0))    % check if horizontal timer pattern
            i = i + 1;
            
        elseif((qrcod(i,j-1) == 2) && (qrcod(i,j) == 0))  % check to left of align pattern
            qrcod(i,j-1) = str2double(btstr(k));          % put bit to the left
            %% Mask Patterns
            %%
            resbts = maskpat( qrcod(i,j-1) , i , (j - 1 ));
            qrmsk1(i,j-1) = resbts(1); qrmsk3(i,j-1) = resbts(3); qrmsk5(i,j-1) = resbts(5); qrmsk7(i,j-1) = resbts(7);
            qrmsk2(i,j-1) = resbts(2); qrmsk4(i,j-1) = resbts(4); qrmsk6(i,j-1) = resbts(6); qrmsk8(i,j-1) = resbts(8);            
            %%
            k = k + 1;
            cnt = cnt + 1;
            i = i + 1;
            
        elseif((qrcod(i,j-1) == 0) && (qrcod(i,j) == 0))    % check for align pattern
            i = i + 5;                                      % move up five rows
        else
            j = j - 2;                                  % move left two columns
            i = i - 1;                                  % go back to previous row
            dirUp = ~dirUp;                             % flip directions
        end
    end
% imagesc(qrcod)
% colormap(gray)
% axis square
% set(gca,'XTickLabel','');
% set(gca,'YTickLabel','');
% set(gca,'Xtick',[],'Ytick',[]);
% pause(.8);

end


%% Calculate Penalties
%%
%  Penalty 1            %  Penalty 2            %  Penalty 3            %  Penalty 4
%  Consecutive Colors   %  Same Colored Blocks  %  Check for strip pt.  %  Ratio of white/black modules  
p1_1 = penlt1(qrmsk1);  p2_1 = penlt2(qrmsk1);  p3_1 = penlt3(qrmsk1);  p4_1 = penlt4(qrmsk1);
p1_2 = penlt1(qrmsk2);  p2_2 = penlt2(qrmsk2);  p3_2 = penlt3(qrmsk2);  p4_2 = penlt4(qrmsk2);
p1_3 = penlt1(qrmsk3);  p2_3 = penlt2(qrmsk3);  p3_3 = penlt3(qrmsk3);  p4_3 = penlt4(qrmsk3);
p1_4 = penlt1(qrmsk4);  p2_4 = penlt2(qrmsk4);  p3_4 = penlt3(qrmsk4);  p4_4 = penlt4(qrmsk4);
p1_5 = penlt1(qrmsk5);  p2_5 = penlt2(qrmsk5);  p3_5 = penlt3(qrmsk5);  p4_5 = penlt4(qrmsk5);
p1_6 = penlt1(qrmsk6);  p2_6 = penlt2(qrmsk6);  p3_6 = penlt3(qrmsk6);  p4_6 = penlt4(qrmsk6);
p1_7 = penlt1(qrmsk7);  p2_7 = penlt2(qrmsk7);  p3_7 = penlt3(qrmsk7);  p4_7 = penlt4(qrmsk7);
p1_8 = penlt1(qrmsk8);  p2_8 = penlt2(qrmsk8);  p3_8 = penlt3(qrmsk8);  p4_8 = penlt4(qrmsk8);

%% Add Up Penalties
%%
totp1 = p1_1 + p2_1 + p3_1 + p4_1;
totp2 = p1_2 + p2_2 + p3_2 + p4_2;
totp3 = p1_3 + p2_3 + p3_3 + p4_3;
totp4 = p1_4 + p2_4 + p3_4 + p4_4;
totp5 = p1_5 + p2_5 + p3_5 + p4_5;
totp6 = p1_6 + p2_6 + p3_6 + p4_6;
totp7 = p1_7 + p2_7 + p3_7 + p4_7;
totp8 = p1_8 + p2_8 + p3_8 + p4_8;

parr  = [totp1 totp2 totp3 totp4 totp5 totp6 totp7 totp8];

%% Determine Best Mask
%%
minn = parr(1);
poss = 0;
for m = 2:8
    if(minn > parr(m))
        minn = parr(m);
        poss = m-1;
    end
end

qzone(((exwh/2) + 1):(end - (exwh/2)), ((exwh/2) + 1):(end - (exwh/2))) = qrcod;
qrcod = eval( strcat('qrmsk',num2str(poss+1)) );      % choose best mask

%% Generate Format String
%%
frm = genformstr(ecc , poss);

%% Place on QR Matrix
%%
frm = fliplr(frm);
for m = 1:7
    qrcod( 9 , qrs - m + 1 ) = ~(str2double(frm(m)));         % under right finder
    qrcod( qrs - 7 + m , 9 ) = ~(str2double(frm(m+8)));       % to the right of the bottom finder
    
    if(m <= 6 )
        qrcod(9 , m) = ~(str2double(frm(m)));               % bottom of top left finder
        qrcod(m , 9) = ~(str2double(frm(16 - m)));          % right of top left finder
    else
        qrcod(8 , 9) = ~(str2double(frm(7)));            % under horizontal timing pattern
        qrcod(9 , 8) = ~(str2double(frm(9)));            % right of vertical timing pattern
    end
end
qrcod(9 , qrs - 7) = ~(str2double(frm(8)));                     % under corner of right finder
qrcod(9 , 9)       = ~(str2double(frm(8)));                     % between timing patterns
    
%% Place Version Information if Needed
%%
if(ver >= 7)
    verstr = genverstr(ver);
    verstr = fliplr(verstr);
    
    i = qrs - 10;
    j = 1;
    for m = 1:18
        if(mod(m-1,3) == 0)
            if(m > 1)
                j = j + 1;
                i = qrs - 10;
            end
        end
        qrcod(i,j) = ~(str2double(verstr(m)));  % place on bottom left version block
        qrcod(j,i) = ~(str2double(verstr(m)));  % place on top right version block
        
        i = i + 1;
    end
end

qzone(((exwh/2) + 1):(end - (exwh/2)), ((exwh/2) + 1):(end - (exwh/2))) = qrcod;

%% Draw Image
%%
figure;
imagesc(qzone);
%imagesc(qrcod);
colormap(gray);
axis square;
set(gca,'XTickLabel','');
set(gca,'YTickLabel','');
set(gca,'Xtick',[],'Ytick',[]);


res = qrcod;
end

