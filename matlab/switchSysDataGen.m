% switch system data generation

function [y, u, gt, sys_par] = switchSysDataGen(opt)

%% Data generation

if nargin == 0
    num_sys = 2; % number of systems
    % sys_ord = [2 2 3 3 4 4]; % order for each system, minimum 2
    sys_ord = [3 3 3]; % order for each system, minimum 2
    num_sample = 100; % number of samples per system
    num_dim = 1;
    switchInd = [11 29 37 59 73 89];
    hasInput = false;
    noiseLevel = 0;
else
    num_sys = opt.nSys; % number of systems
    sys_ord = opt.sysOrders; % order for each system, minimum 2
    num_sample = opt.numSample; % number of data samples
    num_dim = opt.numDim;
    switchInd = opt.switchInd;
    hasInput = opt.hasInput;
    noiseLevel = opt.noiseLevel;
end
num_Hcol = 10;

sys_par = {};

%% System Generation
theta = (rand(num_sys,1))*2*pi; %
for i = 1:num_sys
    x = rand(sys_ord(i)-2,1);
    p = [cos(theta(i))+1i*sin(theta(i));cos(theta(i))-1i*sin(theta(i));x(:)]; % two complex poles and the rest are real poles
    null{i} = -fliplr(poly([p; rand(num_Hcol-1-sys_ord(i),1)]')); % null space for each system, depends on the number of hankel colomns
    p = -fliplr(poly(p'));
    sys_par{i} = p;
end

%% Generate switch system data
num_sample = num_sample + sys_ord(1);
switchInd = switchInd + sys_ord(1);

x = zeros(num_dim, num_sample);
y = zeros(num_dim, num_sample);
gt = zeros(1, num_sample);
initValues = rand(num_dim, sys_ord(1)) - 0.5;
if hasInput
    u = rand(num_dim, num_sample) - 0.5;
else
    u = zeros(num_dim, num_sample);
end


i = 1;
x(:,1:sys_ord(i)) = initValues;
for j = 1:num_sample
    if i == 1 && j <= sys_ord(i)
        x(:,j) = initValues(:,j);
        if hasInput
            u(:,j) = 0;
        end
    else
        if any(switchInd==j)
%             i = mod(i, num_sys)+1;
            i = i + randi(num_sys-1);
            i = mod(i-1, num_sys)+1;
        end
        x(:,j) =  x(:,j-sys_ord(i):j-1) * sys_par{i}(1:end-1).' + noiseLevel * randn;
        if hasInput
            y(:,j) = x(:,j) + u(:,j);
        else
            y(:,j) = x(:,j);
        end
    end
    gt(j) = i;
end

y(:, 1:sys_ord(1)) = [];
u(:, 1:sys_ord(1)) = [];
gt(1:sys_ord(1)) = [];
    
end
