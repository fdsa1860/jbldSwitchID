function sys_par = jbldSwitchID_stitchMHAD
% test graph cut with JBLD distance

close all;
dbstop if error

addpath(genpath(fullfile('..','3rdParty')));
addpath(genpath('metric'));

[data, gt] = genDataStitchMHAD;
% nPCA = 50;
data3 = bsxfun(@minus, data, mean(data,2));
[U,S,V] = svd(data3);
s = diag(S); cs = cumsum(s) / sum(s); 
nPCA = nnz(cs<0.9)+1;
data3 = U(:,1:nPCA)' * data3;
data = data3;
% [coef,score,latent,~,~,mu] = pca(data');
% % data = score(:,1:nPCA)';
% data2 = bsxfun(@minus, data, mu');
% data2 = coef(:,1:nPCA)'*data2;
% data = data2;
% whitenScore = score*diag(1./latent.^0.5);
% data = whitenScore(:,1:3)';
numFrame = size(data, 2);
opt.H_structure = 'HHt';
% opt.H_structure = 'HtH';
% opt.metric = 'binlong';
opt.metric = 'JBLD';
% opt.metric = 'AIRM';
% opt.metric = 'LERM';
% opt.metric = 'KLDM';
% opt.Hsize = 3;
% opt.H_rows = 20;
opt.H_rows = 3;
opt.sigma = 1e-4;
horizon = 20;

tic
t = cell(1,numFrame-horizon+1);
for n = horizon : numFrame
    t{n-horizon+1} = data(:,n-horizon+1:n);
%     t{n-horizon} = data(:,1:n);
end

v = getVelocity(t);
G = getHH(v, opt);

if strcmp(opt.metric,'LERM')
    logG = getLogHH(G);
    D = pdist2(logG.', logG.');
else
    D = HHdist(G,[],opt);
end

displayD(D);

rng(0);
% numNeighbors = 100;
numNeighbors = ceil(0.15 * numFrame);
[label,W] = ncutD(D, 4, numNeighbors);
toc

nEigVal = 10;
d = sum(W);
DInvSqrt = diag( 1 ./ sqrt(d+eps) );
L = eye(size(W)) - DInvSqrt * W * DInvSqrt;
[eigVec, EigVal] = eigs(L,nEigVal,'SM');
eigVal = diag(EigVal);
eigVal = sort(eigVal);
displayEigenValue(eigVal, nEigVal);

% label = [label(1)*ones(horizon-1, 1); label]';
gt(1:horizon-1) = [];

v = perms(1:length(unique(label)));
acc = zeros(1,size(v,1));
for i = 1:length(acc)
    acc(i) = nnz(v(i,label)==gt)/length(gt);
end
[accuracy,ind] = max(acc);
% accuracy
label = v(ind,label);

displayLabel(label, gt, accuracy);

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

function displayLabel(label, gt, accuracy, nPCA)

figure;
plot(label,'x','MarkerSize',10);
if nargin > 2
    hold on;
    plot(gt, 'o');
    hold off;
end
xlabel('time');
ylabel('group label');
if nargin < 3
    title('Switched system identification with JBLD');
elseif nargin == 3
    title(sprintf('Switched system identification with JBLD Graphcut, Accuracy = %2.2f%%',accuracy * 100));
elseif nargin == 4
    title(sprintf('Switched system identification with JBLD Graphcut, Accuracy = %2.2f%% (%d PCA component)',accuracy * 100, nPCA));
else
    
end

hTitle = get(gca,'Title');
P = get(hTitle,'Position');
set(hTitle,'Position',[P(1), P(2)+0.05, P(3)]);

legend('identified group', 'ground truth group');

end

function displayPCA(data)

figure;
plot(data');
xlabel('Frame indices');
ylabel('First three components of PCA');
title('First three components of PCA')
legend('Dim 1', 'Dim 2', 'Dim 3');

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