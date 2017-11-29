%% Hampel Loss

% function f = hampel(e,delta)

function f = hampel(e,delta)

Ea = abs(e)>delta;
f = (delta.^2/pi).*(1 - cos(pi.*e./delta)).*(1-Ea) + (2*delta.^2./pi).*Ea;
