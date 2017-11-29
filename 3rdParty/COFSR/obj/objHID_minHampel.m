% OBJECTIVE function for hybrid syste midentification
%   
% ME with Hampel's loss function
%
function f = objHID_minHampel(structure,W)
X = structure{1};
Y = structure{2};
n = structure{3};
delta = structure{4};

[N p]=size(X);

O=reshape(W,p,n);
E = hampel(Y*ones(1,n) - X*O,delta);


f = 10*sum(min(E,[],2)) ;
