function resbyt = maskpat( val , i , j )
% Determine if bit needs toggling

resbyt = zeros(1,8);
%% MASK PATTERN 1                   % FORMULA: (row + column) mod 2 == 0
if(mod(( (i-1)+(j-1) ),2) == 0)
    resbyt(1) = ~(  val );          % toggle colors
else
    resbyt(1) =  (  val );
end

%% MASK PATTERN 2                   % FORMULA: (row) mod 2 == 0 == 0
if(mod((i-1),2)== 0)
    resbyt(2) = ~(  val );
else
    resbyt(2) =  (  val );
end

%% MASK PATTERN 3                   % FORMULA: (column) mod 3 == 0
if(mod((j-1),3)== 0)
    resbyt(3) = ~(  val );
else
    resbyt(3) =  (  val );
end

%% MASK PATTERN 4                   % FORMULA: (row + column) mod 3 == 0
if(mod(( (i-1) + (j-1) ) ,3)== 0)
    resbyt(4) = ~(  val );
else
    resbyt(4) =  (  val );
end

%% MASK PATTERN 5                   % FORMULA: ( floor(row / 2) + floor(column / 3) ) mod 2 == 0
if(mod(floor((i-1)/2) + floor((j-1)/3),2)== 0)
    resbyt(5) = ~(  val );
else
    resbyt(5) =  (  val );
end

%% MASK PATTERN 6                   % FORMULA: ((row * column) mod 2) + ((row * column) mod 3) == 0
if(( mod(( (i-1)*(j-1) ),2) + mod(( (i-1)*(j-1) ),3) )== 0)
    resbyt(6) = ~(  val );
else
    resbyt(6) =  (  val );
end

%% MASK PATTERN 7                   % FORMULA: ( ((row * column) mod 2) + ((row * column) mod 3) ) mod 2 == 0
if(mod(( mod(( (i-1)*(j-1) ),2) + mod(( (i-1)*(j-1 )),3) ) , 2)== 0)
    resbyt(7) = ~(  val );
else
    resbyt(7) =  (  val );
end

%% MASK PATTERN 8                   % FORMULA: ( ((row + column) mod 2) + ((row * column) mod 3) ) mod 2 == 0
if(mod(( mod( ( (i-1)+(j-1) ),2) + mod(( (i-1)*(j-1) ),3)) , 2)== 0)
    resbyt(8) = ~(  val );
else
    resbyt(8) =  (  val );
end
end

