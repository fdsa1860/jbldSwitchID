% function contOpt_synthetic

close all;
dbstop if error

addpath(genpath(fullfile('..','3rdParty')));
addpath(genpath('.'));

var.nSys = 3; % number of systems
% var.sysOrders = [3 3 3]; % order for each system, minimum 2
% var.den_ord = [3 3 3];
var.den_ord = [2 2 2];
var.num_ord = [2 2 2];
var.numSample = 100; % number of data samples
var.numDim = 1;
var.switchInd = [11 29 41 59 73 89] * 1;
% var.switchInd = [ 20 40 60 80] * 1;
% var.switchInd = [22 58 74 118 146 178];
% var.switchInd = [100];
var.hasInput = true;
var.noiseLevel = 0.2;

% [y, u, gt, sys_par] = switchSysDataGen(var);
% [y, u, x, gt] = switchSysStateDataGen(var);
% rng(22);
% [y, u, gt, a, b] = switchSysDataGen2(var);
rng(22);
[y, u, gt, a, b] = switchSysDataGen4(var);
gt = gt(3:end);

Hy = hankel(y(1:3), y(3:end));
Hu = hankel(u(1:2), u(2:end-1));
x = [Hu; Hy];

[W,label] = klinreg(x(1:4,:)',x(end,:)',3); 
label = label';

% match label and gt
v = perms(1:length(unique(label)));
nMatch = zeros(1,size(v,1));
for i = 1:length(nMatch)
    nMatch(i) = nnz(v(i,label)==gt);
end
[~,ind] = max(nMatch);
% accuracy
label = v(ind,label);
% label = [gt(1:horizon-1) label];
accuracy = nnz(label==gt) / length(gt);

fprintf('identification accuracy is %f\n', accuracy);


% display
plot(label,'*')
hold on;
plot(gt,'o');
hold off;