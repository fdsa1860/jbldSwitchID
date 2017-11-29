% OBJECTIVE function for hybrid system identification
%   
% PE with epsilon-insensitive loss function
%
function f = objHID_PE_LS_reg(structure,W)
X = structure{1};
Y = structure{2};
n = structure{3};
C = structure{4};
[N p]=size(X);

O=reshape(W,p,n);

E = Y*ones(1,n) - X*O;

l_E = E.*E;

f = (W'*W) ./ (n*p) + (C./N) * sum(prod(l_E,2)) ;
