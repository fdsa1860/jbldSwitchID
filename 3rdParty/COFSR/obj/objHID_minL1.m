% OBJECTIVE function for hybrid system identification
%   
% ME with absolute loss function
%
function f = objHID_minL1(structure,W)
X = structure{1};
Y = structure{2};
n = structure{3};
[N p]=size(X);

O=reshape(W,p,n);
E = abs(Y*ones(1,n) - X*O);


f = 1000*sum(min(E,[],2)) ;
