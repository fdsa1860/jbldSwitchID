%  
%	Computes the probability of success for klinreg
%
%	and also outputs the estimated constants for the model
%	of Psuccess
%
%  Usage:
%
%   	[Psuccess, K, T, tau] = psuccess(N, n, p, dynamic)
%
%  Inputs:
%	N	: number of data
%	n	: number of modes
%	p	: dimension of the data
%	dynamic	: If not 0, then use alternate model of the probability of success
%		  (default is 0 for switched regression,
%		   set it to 1 for dynamical system identification)
%
%  Outputs:
%	Psuccess	: estimated probability of success of each restart
%	K, T, tau	: constants in the model of Psuccess
%
%  For more details, see 
%  	F. Lauer, "Estimating the probability of success of a simple algorithm 
%  	for switched linear regression", 2012.
%
function [Psuccess, K, T, tau] = psuccess(N, n, p, dynamic)

if nargin < 4
	dynamic = 0;
end

if dynamic
	K = 1.02 - 0.023 * n;
	T = 52 * sqrt(2^n * p ) - 220;
	tau = 1.93 * 2^n * p - 37;
else
	K = 0.99; 
	T = 2.22 * 2^n * p;
	tau = (2^n * p)^(1.4) * 0.2;
end
Psuccess = max(0, K*(1 - exp( -(N - tau) / T) ) );


