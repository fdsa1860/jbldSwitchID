%  
%	Computes the optimal number of restarts for klinreg
%
%	(and can also output the estimated constants for the model
%	of Psuccess)
%
%  Simple usage:
%
%   	r_opt = rstar(Pf, N, n, p, dynamic)
%
%  Inputs:
%	Pf	: Probability of failure
%	N	: number of data
%	n	: number of modes
%	p	: dimension of the data
%	dynamic	: If not 0, then use alternate model of the probability of success
%		  (default is 0 for switched regression,
%		   set it to 1 for dynamical system identification)
%
%  Output:
%	r_opt	: number of restarts to use in klinreg_simple
%
%  Additional outputs:
%
%   	[r_opt, Psuccess, K, T, tau] = rstar(Pf, N, n, p, dynamic)
%
%	Psuccess	: estimated probability of success of each restart
%	K, T, tau	: constants in the model of Psuccess
%
%  For more details, see 
%  	F. Lauer, "Estimating the probability of success of a simple algorithm 
%  	for switched linear regression", 2012.
%
function [r_opt, Psuccess, K, T, tau] = rstar(Pf, N, n, p, dynamic)

if nargin < 5
	dynamic = 0;
end

[Psuccess, K, T, tau] = psuccess(N, n, p, dynamic);

if Psuccess > 0
	r_opt = ceil(log(Pf) / log(1-Psuccess));
else
	r_opt = 100;
end

if r_opt < 1
	r_opt = 1;
end
