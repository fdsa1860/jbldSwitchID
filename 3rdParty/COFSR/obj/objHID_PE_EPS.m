% OBJECTIVE function for hybrid system identification
%   
% PE with epsilon-insensitive loss function
%
function f = objHID_PE_EPS(structure,W)
X = structure{1};
Y = structure{2};
n = structure{3};
delta = structure{4};

[N p]=size(X);
O=reshape(W,p,n);
l_E = max(abs(Y*ones(1,n) - X*O)-delta,0);

f = sum(prod(l_E,2));
