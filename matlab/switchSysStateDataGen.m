% switch system data generation

function [y, u, x, gt] = switchSysStateDataGen(opt)

%% Data generation

if nargin == 0
    num_sys = 3; % number of systems
    % sys_ord = [2 2 3 3 4 4]; % order for each system, minimum 2
    sys_ord = [3 3 3]; % order for each system, minimum 2
    num_sample = 200; % number of samples per system
    num_dim = 1;
    switchInd = ceil(num_sample / 2);
    hasInput = false;
else
    num_sys = opt.nSys; % number of systems
    sys_ord = opt.sysOrders; % order for each system, minimum 2
    num_sample = opt.numSample; % number of data samples
    num_dim = opt.numDim;
    switchInd = opt.switchInd;
    hasInput = opt.hasInput;
end

num_Hcol = 10;

As = cell(1, num_sys);
Bs = cell(1, num_sys);
Cs = cell(1, num_sys);
Ds = cell(1, num_sys);

%% System Generation
theta = (rand(num_sys,1))*2*pi; %
for i = 1:num_sys
    x = rand(sys_ord(i)-2,1);
    p = [cos(theta(i))+1i*sin(theta(i));cos(theta(i))-1i*sin(theta(i));x(:)]; % two complex poles and the rest are real poles
    a = -fliplr(poly(p'));
    A = diag(ones(1,sys_ord(i)-1), 1);
    A(end, :) = a(1:end-1);
    B = zeros(sys_ord(i), 1);
    B(end) = 1;
    C = zeros(1, sys_ord(i));
    C(end) = 1;
    D = zeros(num_dim, 1);
    As{i} = A;
    Bs{i} = B;
    Cs{i} = C;
    Ds{i} = D;
end

%% Generate switch system data

x = zeros(sys_ord(1), num_sample);
y = zeros(num_dim, num_sample);
gt = zeros(1, num_sample);
x0 = rand(sys_ord(1), 1) - 0.5;
if hasInput
    u = rand(1, num_sample) - 0.5;
else
    u = zeros(1, num_sample);
end


i = 1;
for j = 1:num_sample
    if j == 1
        x(:,j) = x0;
        y(:,j) = Cs{i} * x(:,j) + Ds{i} * u(j);
    else
        if any(switchInd==j)
%             i = mod(i, num_sys)+1;
            i = i + randi(num_sys-1);
            i = mod(i-1, num_sys)+1;
        end
        x(:,j) = As{i} * x(:,j-1) + Bs{i} * u(j-1);
        y(:,j) = Cs{i} * x(:,j) + Ds{i} * u(j);
    end
    gt(j) = i;
end
    
end
