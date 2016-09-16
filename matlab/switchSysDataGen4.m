% switch system data generation

function [y, u, gt, a, b] = switchSysDataGen4(opt)

%% Data generation

if nargin == 0
    num_sys = 3; % number of systems
    % sys_ord = [2 2 3 3 4 4]; % order for each system, minimum 2
    den_ord = [3 3 3]; % order for each system, minimum 2
    num_ord = [2 2 2];
    num_sample = 100; % number of samples per system
    num_dim = 1;
    switchInd = [11 29 41 59 73 89];
    hasInput = true;
    noiseLevel = 0;
else
    num_sys = opt.nSys; % number of systems
    den_ord = opt.den_ord; % order for each system, minimum 2
    num_ord = opt.num_ord;
    num_sample = opt.numSample; % number of data samples
    num_dim = opt.numDim;
    switchInd = opt.switchInd;
    hasInput = opt.hasInput;
    noiseLevel = opt.noiseLevel;
end

a = cell(1, length(den_ord));
b = cell(1, length(num_ord));

%% System Generation
theta = (rand(num_sys,1))*2*pi; %
for i = 1:num_sys
    x = rand(den_ord(i)-2,1);
    r = rand*0.5+0.5;
    p = [r*(cos(theta(i))+1i*sin(theta(i)));r*(cos(theta(i))-1i*sin(theta(i)));x(:)]; % two complex poles and the rest are real poles
    p = -fliplr(poly(p'));
    a{i} = p;
    b{i} = rand(1, num_ord(i));
end

%% Generate switch system data
gt = zeros(1, num_sample);

y = zeros(num_dim, num_sample + den_ord(1));
yInit = rand(num_dim, den_ord(1)) - 0.5;
y(:, 1:den_ord(1)) = yInit;

if hasInput
    u = zeros(num_dim, num_sample + num_ord(1));
    uInit = zeros(num_dim, num_ord(1));
    u(:,1:num_ord(1)) = uInit;
%     u(num_ord(1)+1:end) = rand(num_dim, num_sample) - 0.5;
    u(:,num_ord(1)+1:end) = idinput([num_sample, num_dim],'rgs').';
else
    u = zeros(num_dim, num_sample + num_ord(1));
end

% e = noiseLevel * (2*rand(size(y))-1);
e = noiseLevel * randn(size(y));

rng(0);
i = 1;
for j = 1:num_sample
    if any(switchInd==j)
        %             i = mod(i, num_sys)+1;
        i = i + randi(num_sys-1);
        i = mod(i-1, num_sys)+1;
    end
    y(:,j+den_ord(i)) =  y(:,j:j+den_ord(i)-1) * a{i}(1:end-1).' + u(:,j:j+num_ord(i)-1) * b{i}.';
    gt(j) = i;
end
y = y + e;

y(:,1:den_ord(1)) = [];
u(:,1:num_ord(1)) = [];
    
end
