%% Continuous Optimization Framework for Switched Regression
%  (and hybrid system identification)
%	
% Use:
%
% [W,labels,obj_value] = cofsr(X,Y,n,obj,delta,C)
%
% to solve the switched linear regression problem in X, Y.
% 
%Inputs
% X	: N x p regression matrix
% Y	: N x 1 target outputs
% n	: number of modes
% obj	: open HIDmcs.m to see the list of available objective functions
%	  classical choices are
%	 'ls', 'l1', 'hampel'... for the product-of-error estimator
%	  or 'minls', 'minl1', ... for their minimum-of-error counterparts
% delta	: loss function parameter (when needed, e.g., for Hampel loss)
% C	: regularization parameter (for regularized objectives only)
%
%Outputs
% W		: p x n matrix of estimated parameter vectors
% labels	: N x 1 vector of estimated mode 
% obj_value	: minimum objective function value
%
%
% This is an implementation by F. Lauer of the method described in 
% "A continuous optimization framework for hybrid system identification",
%  by F. Lauer, R. Vidal, G. Bloch, Automatica, 2011.
%
% Optimization is performed by the MCS algorithm of Huyer and Neumaier,
% see http://www.mat.univie.ac.at/~neum/software/mcs/ for details.
%
function [W,ij,fbest] = cofsr(XX,YY,nmodes,obj,delta,C)
clear mex; clear global; 


tic;

if nargin < 6
	C = 100;
end
if nargin < 5
	delta = 0;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%% problem definition %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
[N,p] = size(XX);

u = -100*ones(nmodes*p,1);	% box bounds on parameters
v = 100*ones(nmodes*p,1);	% change these if some |w| > 100 

%========== select objective function ======================================
%   
% An objective function has 3 customizable components:
%
% * computes either the minimum of errors (min) or the product of errors (default)
% *	with a specific loss function among: squared loss (ls), l1, hampel,
%			 								huber, epsilon-insensitive (eps)
% * and does or does not include regularization (reg)
%
%	All implemented choices are listed below. For example, 
%
%	 obj = 'ls' 		  => product of squared loss functions without regularization
%	 obj = 'minhampelreg' => minimum of Hampel loss functions with regularization
%
%	See inside the 'obj/' directory for implementation details. 
%	Implementing additional objectives is also possible and straightforward.
% ==========================================================================
switch lower(obj)

% with minimum-of-error (ME) objective function ( obj='min...' )
   
    case 'minls'
    fcn = 'objHID_minLS';
    data = {XX,YY,nmodes};	

    case 'minl1'
    fcn = 'objHID_minL1';
    data = {XX,YY,nmodes};	
 
    case 'minhampel'
    fcn = 'objHID_minHampel';
    data = {XX,YY,nmodes,delta};
    if delta==0
    	error('Bad or missing parameter: cannot use delta=0 in Hampel loss function.');    	
    end
  
% with product-of-error (PE) objective function ( obj='...' )
    case 'ls'
    fcn = 'objHID_PE_LS';
    data = {XX,YY,nmodes};	
 
    case 'l1'
    fcn = 'objHID_PE_L1';
    data = {XX,YY,nmodes};	
 
    case 'eps'
    fcn = 'objHID_PE_EPS';
    data = {XX,YY,nmodes,delta};	  

    case 'hampel'
    fcn = 'objHID_PE_HAMPEL';
    data = {XX,YY,nmodes,delta};	    
    if delta==0
    	error('Bad or missing parameter: cannot use delta=0 in Hampel loss function.');    	
    end
  
    case 'l1sat'
    fcn = 'objHID_PE_L1SAT';
    data = {XX,YY,nmodes,delta};	
    if delta==0
    	error('Bad or missing parameter: cannot use delta=0 in L1SAT loss function.');    	
    end
  
    case 'l2sat'
    fcn = 'objHID_PE_L2SAT';
    data = {XX,YY,nmodes,delta};	
    if delta==0
    	error('Bad or missing parameter: cannot use delta=0 in L2SAT loss function.');    	
    end
    
    case 'huber'
    fcn = 'objHID_PE_HUBER';
    data = {XX,YY,nmodes,delta};	
  
% -- Regularized versions --

% with ME objective function  ( obj='min...reg' )
   
    case 'minlsreg'
    fcn = 'objHID_minLS_reg';
    data = {XX,YY,nmodes,C};	

    case 'minl1reg'
    fcn = 'objHID_minL1_reg';
    data = {XX,YY,nmodes,C};	
 
    case 'minhampelreg'
    fcn = 'objHID_minHampel_reg';
    data = {XX,YY,nmodes,delta,C};	
    if delta==0
    	error('Bad or missing parameter: cannot use delta=0 in Hampel loss function.');    	
    end
  
% with PE objective function  ( obj='...reg' )
    case 'lsreg'
    fcn = 'objHID_PE_LS_reg';
    data = {XX,YY,nmodes,C};	
 
    case 'l1reg'
    fcn = 'objHID_PE_L1_reg';
    data = {XX,YY,nmodes,C};	
 
    case 'epsreg'
    fcn = 'objHID_PE_EPS_reg';
    data = {XX,YY,nmodes,delta,C};	  

    case 'hampelreg'
    fcn = 'objHID_PE_HAMPEL_reg';
    data = {XX,YY,nmodes,delta,C};	    
    if delta==0
    	error('Bad or missing parameter: cannot use delta=0 in Hampel loss function.');    	
    end
  
    case 'l1satreg'
    fcn = 'objHID_PE_L1SAT_reg';
    data = {XX,YY,nmodes,delta,C};	
    if delta==0
    	error('Bad or missing parameter: cannot use delta=0 in L1SAT loss function.');    	
    end
    
    case 'l2satreg'
    fcn = 'objHID_PE_L2SAT_reg';
    data = {XX,YY,nmodes,delta,C};	
    if delta==0
    	error('Bad or missing parameter: cannot use delta=0 in L2SAT loss function.');    	
    end
    
    case 'huberreg'
    fcn = 'objHID_PE_HUBER_reg';
    data = {XX,YY,nmodes,delta,C};	
  
 % Default 
    otherwise
     fcn = 'objHID_PE_LS';
    data = {XX,YY,nmodes};	

end
				
dimension=length(u);		

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%% MCS settings %%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 
% define amount of output printed
prt = 0;	% print level 
		% prt = 0: no output
		% prt = 1: # sweep, minimal nonempty level, # f-calls,
		%          best point and function value
		% prt > 1: in addition levels and function values of
		%          boxes containing the known global minimizers
		%          of a test function

%
n = length(u);		% problem dimension
smax = 5*n+100;		% number of levels used
nf = 100*n^2; 		% limit on number of f-calls
stop(1) = 3*n;		% = m, integer defining stopping test
stop(2) = -inf;		% = freach, function value to reach
			% if m>0, run until m sweeps without progress
			% if m=0, run until fbest<=freach
			% (or about nf function calls were used)

iinit = 0;	% 0: simple initialization list
		%    (default for finite bounds;
		%     do not use this for very wide bounds)
		% 1: safeguarded initialization list
		%    (default for unbounded search regions)
		% 2: (5*u+v)/6, (u+v)/2, (u+5*v)/6
		% 3: initialization list with line searches
		% else: self-defined initialization list 
		%       stored in file init0.m

% parameters for local search
%
% A tiny gamma (default) gives a quite accurate but in higher 
% dimensions slow local search. Increasing gamma leads to less work 
% per local search but a less accurately localized minimizer
% 
% If it is known that the Hessian is sparse, providing the sparsity 
% pattern saves many function evaluations since the corresponding
% entries in the Hessian need not be estimated. The default pattern
% is a full matrix.
% 
local = 50;		% local = 0: no local search
			% else: maximal number of steps in local search
gamma = eps;		% acceptable relative accuracy for local search
hess = ones(n,n);	% sparsity pattern of Hessian



% defaults are not being used, use the full calling sequence
% (including at least the modified arguments)
%%%%%%%%%%%%%%%%%%%%%%% full MCS call %%%%%%%%%%%%%%%%%%%%%%
xbest = zeros(n,1);
[xbest,fbest,xmin,fmi,ncall,ncloc]=...
  mcs(fcn,data,u,v,prt,smax,nf,stop,iinit,local,gamma,hess);
%ncall
% xmin	  		% columns are points in 'shopping basket'
			% may be good alternative local minima
% fmi	  		% function values in 'shopping basket'
nbasket = length(fmi); 	% number of points in 'shopping basket'
%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Recover estimated parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
W=zeros(p,nmodes);
for j=1:nmodes
    W(:,j) = xbest((j-1)*p+1:j*p);    
end

% Estimate mode for all points
ypj = XX*W;
ej = abs(ypj - YY*ones(1,nmodes));
[emini ij] = min(ej,[],2);

% print elapsed time
toc
