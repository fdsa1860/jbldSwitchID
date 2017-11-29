% OBJECTIVE function for hybrid system identification
%   
% PE with saturated squared loss function (Tavlar's loss)
%
function f = objHID_PE_L2SAT(structure,W)
X = structure{1};
Y = structure{2};
n = structure{3};
delta = structure{4};

[N p]=size(X);

O=reshape(W,p,n);

E = min((Y*ones(1,n) - X*O).^2,delta.^2);

f = sum(prod(E,2)) ;
