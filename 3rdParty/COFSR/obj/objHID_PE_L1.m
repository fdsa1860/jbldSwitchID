% OBJECTIVE function for hybrid system identification
%   
% PE with epsilon-insensitive loss function
%
function f = objHID_PE_L1(structure,W)
X = structure{1};
Y = structure{2};
n = structure{3};
[N p]=size(X);

O=reshape(W,p,n);

E = abs(Y*ones(1,n) - X*O);

f = sum(prod(E,2)) ;
