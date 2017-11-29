% OBJECTIVE function for hybrid system identification
%   
% PE with Hampel loss function
%

function f = objHID_PE_HAMPEL(structure,W)
X = structure{1};
Y = structure{2};
n = structure{3};
delta = structure{4};

[N p]=size(X);

O=reshape(W,p,n);
Ea = abs(Y*ones(1,n) - X*O)>delta;

% SCALED VERSION : loss(e>delta) = 1
E = (pi./(2*delta.^2)).*((delta.^2/pi).*(1 - cos(pi.*(Y*ones(1,n) - X*O)./delta)).*(1-Ea) + (2*delta.^2./pi).*Ea);

f = sum(prod(E,2)) ;
