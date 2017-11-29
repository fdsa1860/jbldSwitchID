%
%	k-LinReg algorithm for solving the switched linear regression
%	problem
%
%	min_w  sum_i min_j (y_i - w_(lambda_i)^T x_i)^2
%
%	The function estimates the optimal number of restarts
%	and then calls klinreg_simple.
%	
%  Simple usage:
%
%   	[w, lambda, fbest] = klinreg(X,Y,n,dynamic)
%
%  Inputs:
%	X	: N x p matrix of N regression vectors in R^p as rows 
%	Y	: N x 1 vector of target outputs
%	n	: number of modes
%	dynamic	: If not 0, then use alternate model of the probability of success
%		  when computing the number of restarts
%		  (default is 0 for switched regression,
%		   set it to 1 for dynamical system identification)
%
%  Outputs:
%	w	: p x n matrix of estimated parameter vectors w_j as columns
%	lambda	: N x 1 vector of estimated modes (labels)
%	fbest	: best cost function value obtained with w
%
%  With more options:
%
%   	[w, lambda, fbest, r_opt, cost, W, Winit] = klinreg(X,Y,n,dynamic,Pf,wmax)
%
%  Additional inputs:
%	Pf		: Probability of failure (default is 0.001)
%	wmax		: bound on the initializations: w0(k) is in [-wmax, +wmax]
%		  	  (default is 100)
%
%  Additional outputs:
%	r_opt	: number of restarts used by klinreg_simple
%	cost	: r_opt x 1 vector of cost function values for all restarts
%	W	: (r_opt x p) x n matrix of all estimated parameter vectors
%	Winit	: (r_opt x p) x n matrix of all initializations 
%
%  For more details, see 
%  	F. Lauer, "Estimating the probability of success of a simple algorithm 
%  	for switched linear regression", 2012.
%
function [w, lambda, fbest, r_opt, cost, W, Winit] = klinreg(X,Y,n,dynamic,Pf,wmax)

[N,p] = size(X);
if nargin < 4
	dynamic = 0;
end
if nargin < 5
	Pf = 0.001;
end
if nargin < 6
	wmax = 100;
end

[r_opt, Psuccess, K, T, tau] = rstar(Pf,N,n,p,dynamic);

[w, lambda, fbest, cost, W, Winit] = klinreg_simple(X,Y,n,r_opt,wmax);

