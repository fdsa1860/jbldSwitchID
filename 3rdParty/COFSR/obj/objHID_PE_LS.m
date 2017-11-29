% OBJECTIVE function for hybrid system identification
%   
% PE with epsilon-insensitive loss function
%
function f = objHID_PE_LS(structure,W)
X = structure{1};
Y = structure{2};
n = structure{3};
[N p]=size(X);

O=reshape(W,p,n);

E = Y*ones(1,n) - X*O;

l_E = E.*E;

f = sum(prod(l_E,2)) ;
