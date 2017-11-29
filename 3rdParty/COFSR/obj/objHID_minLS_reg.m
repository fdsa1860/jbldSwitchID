% OBJECTIVE function for hybrid system identification
%   
% ME with squared loss function (least squares like)
%
function f = objHID_minLS_reg(structure,W)

X = structure{1};
Y = structure{2};
n = structure{3};
C = structure{4};
[N p]=size(X);

E = (Y*ones(1,n) - X*reshape(W,p,n)).^2;
f = (W'*W) ./ (n*p) + (C./N) * sum(min(E,[],2)) ;

