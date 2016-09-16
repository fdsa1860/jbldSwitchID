function jbldSwitchID_synthetic2
% test graph cut with JBLD distance

close all;
dbstop if error

addpath(genpath(fullfile('..','3rdParty')));
addpath(genpath('metric'));

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

plot(y);

opt.H_structure = 'HHt';
opt.metric = 'JBLD';
% opt.Hsize = 3;
opt.H_rows = 3;
opt.sigma = 1e-4;
horizon = 7;

tic
ty = cell(1,length(y)-horizon+1);
tu = cell(1,length(u)-horizon+1);
for i = 1 : length(ty)
    ty{i} = y(:,i:i+horizon-1);
    tu{i} = u(:,i:i+horizon-1);
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

c = cell(1, var.nSys);
Gm = cell(1, var.nSys);
label(1:horizon-1) = [];
for i = 1:var.nSys
    Gm{i} = steinMean(cat(3,G{label==i}));
    [U,S,V] = svd(Gm{i});
    c{i} = U(:,end).';
    c{i} = -c{i} / c{i}(var.den_ord(1)+1);
end
Hy = hankel(y(1:var.den_ord(1)+1),y(var.den_ord(1)+1:end));
Hu = hankel(u(1:var.den_ord(1)),u(var.den_ord(1):end-1));
H = [Hy; Hu];
figure;
plot(c{1}*H, '*');
hold on;
plot(c{2}*H, '*');
plot(c{3}*H, '*');
plot(gt(3:end), 'o');
hold off;
legend residue1 residue2 residue3 groundtruth

newLabel = zeros(size(label));
r = zeros(var.nSys, var.numSample - var.den_ord(1));
for i = 1:var.nSys
r(i,:) = c{i}*[Hy;Hu];
end
[~, newLabel] = min(abs(r));

clear label;
label = [newLabel(1)*ones(1, var.den_ord(1)), newLabel];
v = perms(1:length(unique(label)));
nMatch = zeros(1,size(v,1));
for i = 1:length(nMatch)
    nMatch(i) = nnz(v(i,label)==gt);
end
[~,ind] = max(nMatch);
% accuracy
label = v(ind,label);
accuracy = nnz(label==gt) / length(gt);
accuracy
55

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
    title('Switched system identification with JBLD Graphcut');
elseif nargin == 3
    title(sprintf('Switched system identification with JBLD Graphcut, Accuracy = %2.2f%%',accuracy*100));
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