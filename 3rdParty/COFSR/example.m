% EXAMPLES for switched linear regression
% in the Continuous Optimization Framework
%
% by F. Lauer, 2012.
%
close all;
clear all;
format compact;format long;

disp('*******************************************************')
disp('EXAMPLE 1: 2 modes and 61 data points in dimension 1...')

% data 
X = (-3:0.1:3)';
N = length(X);
Y = zeros(N,1);

Y(1:30) = 2*X(1:30) + 0.2*randn(30,1);
Y(31:N) = -0.5*X(31:N) + 0.2*randn(N-30,1);

% identification
[W,mode, obj] = cofsr(X,Y,2,'ls');

objective_function_value = obj

%plots
plot(X,Y,'.k');
hold on
plot(X,X*W,'LineWidth',2);
plot(X(mode==1),Y(mode==1),'ob');
plot(X(mode==2),Y(mode==2),'or');
title('EXAMPLE 1');

true_parameters = [2, -0.5]
estimated_parameters=W

%%%%%%%%%% EXAMPLE 2 %%%%%%%%%%%%%%

disp('*******************************************************')
disp('EXAMPLE 2: 2 modes and 10000 data points in dimension 3...')
clear all;

% data 
N = 10000;
X = 10*rand(N,3) - 5;
Y = zeros(N,1);
Wtrue = 10*rand(3,2) - 5;
truemode = ceil(2*rand(N,1));
NoiseVariance = 1;
noise = sqrt(NoiseVariance) *randn(N,1);
for i=1:N
	Y(i) = X(i,:)*Wtrue(:,truemode(i)) +  noise(i);
end

% identification
[W,mode,obj] = cofsr(X,Y,2,'ls');

objective_function_value = obj

true_parameters = Wtrue
estimated_parameters = W

% compute error
Yp = X*W;
E = zeros(N,1);
for i=1:N
	E(i) = Y(i) - Yp(i,mode(i));
end

NoiseVariance = var(noise)
MSE = E'*E / N
ClassificationErrorRate = min(sum(truemode==mode), sum(truemode~=mode)) / N

figure;
subplot(2,1,1);
plot(noise)
title('EXAMPLE 2: noise signal');
subplot(2,1,2);
plot(E);
title('EXAMPLE 2: error signal y_i - X(i,:) * W(:,mode(i))');


