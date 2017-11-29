% OBJECTIVE function for hybrid syste midentification
%   
% PE with saturated L1 loss function
%
function f = objHID_PE_L1SAT(structure,W)
X = structure{1};
Y = structure{2};
n = structure{3};
delta = structure{4};

[N p]=size(X);

O=reshape(W,p,n);

E = min(abs(Y*ones(1,n) - X*O),delta);

f = sum(prod(E,2)) ;
