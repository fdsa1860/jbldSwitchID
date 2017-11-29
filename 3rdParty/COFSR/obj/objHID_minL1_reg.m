% OBJECTIVE function for hybrid system identification
%   
% ME with absolute loss function
%
function f = objHID_minL1_reg(structure,W)
X = structure{1};
Y = structure{2};
n = structure{3};
C = structure{4};
[N p]=size(X);

O=reshape(W,p,n);
E = abs(Y*ones(1,n) - X*O);


f =  (W'*W) ./ (n*p) + (C./N) * sum(min(E,[],2)) ;
