%
%	k-LinReg algorithm for solving the switched linear regression
%	problem
%
%	min_w  sum_i min_j (y_i - w_(lambda_i)^T x_i)^2
%	
%	This is a simple version based on a fixed number of restarts
%
%  Usage:
%
%   	[w, lambda, minerror, cost, W, Winit] = klinreg(X,Y,n,restarts,wmax)
%
%  Inputs:
%	X	: N x p matrix of N regression vectors in R^p as rows 
%	Y	: N x 1 vector of target outputs
%	n	: number of modes
% 	restarts: number of restarts
%	wmax	: bound on the initializations: w0 is in [-wmax, +wmax]^np	
%
%  Outputs:
%	w	: p x n matrix of estimated parameter vectors w_j as columns
%	lambda	: N x 1 vector of estimated modes (labels)
%	minerror: best cost function value over all restarts
%	cost	: vector of cost function values for all restarts
%	W	: (restarts x p) x n matrix of all estimated parameter vectors
%	Winit	: (restarts x p) x n matrix of all initializations 
%
%  For more details, see 
%  	F. Lauer, "Estimating the probability of success of a simple algorithm 
%  	for switched linear regression", 2012.
%
function [w, lbls, minerror, criterion, W, Winit] = klinreg_simple(X,Y,n,restarts,wmax)

[N,p] = size(X);

W = zeros(restarts*p,n);
Winit = zeros(restarts*p,n);
for i=1:restarts

	w = 2*wmax * rand(p,n) - wmax;
	Winit((i-1)*p + 1:i*p,:) = w;
	
	ok = 1;
	lbls_prec = zeros(N,1);
	lbls = -ones(N,1);
	iters = 0;
	while (ok == 1 & sum(lbls == lbls_prec) < N),
		iters = iters +1;
		
		% compute labels
		ej = Y*ones(1,n) - X*w;
		lbls_prec = lbls;
		[e, lbls] = min(ej.*ej,[],2);

		% compute parameters
		for j=1:n
			if sum(lbls==j) > 2	
				w(:,j) = X(lbls==j,:) \ Y(lbls==j);
			else
				ok = 0;
				break;
			end
		end
	end
	if ok
		W((i-1)*p + 1:i*p,:) = w;
		ej = Y*ones(1,n) - X*w;
		[e, lbls] = min(ej.*ej,[],2);
		criterion(i) = sum(e);
	else
		%disp('Dropped one mode');	
		criterion(i) = inf;	
	end

end

[minerror, i] = min(criterion);

w = W((i-1)*p + 1:i*p,:);
ej = Y*ones(1,n) - X*w;
[e, lbls] = min(ej.*ej,[],2);

