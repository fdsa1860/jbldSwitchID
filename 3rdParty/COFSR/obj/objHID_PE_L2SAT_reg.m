% OBJECTIVE function for hybrid system identification
%   
% PE with saturated squared loss function (Tavlar's loss)
%
function f = objHID_PE_L2SAT_reg(structure,W)
X = structure{1};
Y = structure{2};
n = structure{3};
delta = structure{4};
C = structure{5};
[N p]=size(X);

O=reshape(W,p,n);

E = min((Y*ones(1,n) - X*O).^2,delta.^2);

f =(W'*W) ./ (n*p) + (C./N) * sum(prod(E,2)) ;
