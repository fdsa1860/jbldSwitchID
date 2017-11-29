% OBJECTIVE function for hybrid system identification
%   
% PE with Huber loss function
%
function f = objHID_PE_HUBER(structure,W)
X = structure{1};
Y = structure{2};
n = structure{3};
beta = structure{4};

[N p]=size(X);
O=reshape(W,p,n);
E = abs(Y*ones(1,n) - X*O);
Eb=(find(E<beta));
E(Eb) = E(Eb).*E(Eb);

f = sum(prod(E,2));
