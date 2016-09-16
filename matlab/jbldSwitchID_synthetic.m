function sys_par = jbldSwitchID_synthetic
% test graph cut with JBLD distance

close all;
dbstop if error

addpath(genpath(fullfile('..','3rdParty')));
addpath(genpath('metric'));

var.nSys = 3; % number of systems
var.sysOrders = [3 3 3]; % order for each system, minimum 2
var.numSample = 500; % number of data samples
var.numDim = 1;
var.switchInd = [11 29 37 59 73 89] * 5;
% var.switchInd = [22 58 74 118 146 178];
% var.switchInd = [100];
var.hasInput = true;
var.noiseLevel = 0.01;

% var.hasInput = false;
% rng(5);
% [y, u, gt, sys_par] = switchSysDataGen(var);
% Hy = blockHankel(y, [20, var.numSample-20+1]);
% svd(Hy)
% var.hasInput = true;
rng(5);
[y, u, gt, sys_par] = switchSysDataGen(var);
% [y, u, x, gt] = switchSysStateDataGen(var);
plot(y);
y = y + 0.00 * norm(y)/size(y,2) * randn(size(y));

opt.H_structure = 'HHt';
% opt.H_structure = 'HtH';
% opt.metric = 'binlong';
opt.metric = 'JBLD';
% opt.Hsize = 3;
opt.H_rows = 4;
opt.sigma = 1e-4;
horizon = 10;

tic
ty = cell(1,var.numSample-horizon+1);
tu = cell(1,var.numSample-horizon+1);
for n = horizon : var.numSample
    ty{n-horizon+1} = y(:,n-horizon+1:n);
    tu{n-horizon+1} = u(:,n-horizon+1:n);
%     t{n-horizon} = data(:,1:n);
end

[G, Hty, Htu] = getHUUH(ty, tu, opt);
D = HHdist(G,[],opt);
displayD(D);

numNeighbors = var.numSample / 4;
[label,W] = ncutD(D, var.nSys, numNeighbors);
toc

nEigVal = 10;
d = sum(W);
DInvSqrt = diag( 1 ./ sqrt(d+eps) );
L = eye(size(W)) - DInvSqrt * W * DInvSqrt;
% [eigVec, EigVal] = eigs(L,nEigVal,'SM');
[eigVec, EigVal] = eig(L);
eigVal = diag(EigVal);
eigVal = sort(eigVal);
eigVal = eigVal(1:nEigVal);
displayEigenValue(eigVal, nEigVal);

label = [label(1)*ones(horizon-1, 1); label]';
% gt(1:horizon-1) = [];
% gtCut = gt(horizon:end);

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

displayRes(label, gt, accuracy);

fprintf('identification accuracy is %f\n', accuracy);

end

function displayD(D)

figure;
imagesc(D);
xlabel('indices of segments');
ylabel('indices of segments');
title('JBLD distance matrix of each pair of trajectory segments');
colorbar;

end

function displayRes(label, gt, accuracy)

figure;
plot(label,'x','MarkerSize',10);
if nargin > 1
    hold on;
    plot(gt, 'o');
    hold off;
end
xlabel('time');
ylabel('group label');
if nargin < 3
    title('Switched system identification with JBLD');
elseif nargin == 3
    title(sprintf('Switched system identification with JBLD, Accuracy = %2.2f%%',accuracy*100));
end

hTitle = get(gca,'Title');
P = get(hTitle,'Position');
set(hTitle,'Position',[P(1), P(2)+0.05, P(3)]);

legend('identified group', 'ground truth group');

end

function displayEigenValue(ev, n)

if nargin < 2
    n = length(ev);
end

figure;
plot(ev(1:n), '*');
xlabel('Indices of eigenvalues (sorted in ascending order)');
ylabel('Eigenvalues');
title(sprintf('First %d eigenvalues of normalized Laplacian matrix',n));

end