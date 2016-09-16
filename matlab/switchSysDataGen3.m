% switch system data generation

function [y, u, gt, a, b] = switchSysDataGen3(opt)

%% Data generation

if nargin == 0
    num_sys = 2; % number of systems
    % sys_ord = [2 2 3 3 4 4]; % order for each system, minimum 2
    den_ord = [2 2]; % order for each system, minimum 2
    num_ord = [1 1];
    num_sample = 100; % number of samples per system
    num_dim = 1;
    switchInd = [26 51 76];
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
a{1} = [0.24 0.2 -1]; b{1} = 2; a{2} = [-0.53 -1.4 -1]; b{2} = 1;


%% Generate switch system data
gt = zeros(1, num_sample);

y = zeros(num_dim, num_sample + den_ord(1));
yInit = rand(num_dim, den_ord(1)) - 0.5;
y(1:den_ord(1)) = yInit;

if hasInput
    u = zeros(num_dim, num_sample + num_ord(1));
    uInit = zeros(num_dim, num_ord(1));
    u(1:num_ord(1)) = uInit;
%     u(num_ord(1)+1:end) = rand(num_dim, num_sample) - 0.5;
    u(num_ord(1)+1:end) = idinput([num_sample, num_dim],'rgs').';
else
    u = zeros(num_dim, num_sample + num_ord(1));
end

rng(0);
i = 1;
for j = 1:num_sample
        if any(switchInd==j)
%             i = mod(i, num_sys)+1;
            i = i + randi(num_sys-1);
            i = mod(i-1, num_sys)+1;
        end
        y(:,j+den_ord(i)) =  y(:,j:j+den_ord(i)-1) * a{i}(1:end-1).' + u(:,j:j+num_ord(i)-1) * b{i}.' + noiseLevel * randn;
    gt(j) = i;
end

y(:,1:den_ord(1)) = [];
u(:,1:num_ord(1)) = [];
    
end
