function sys_par = jbldSwitchID_RealData
% test graph cut with JBLD distance

close all;
dbstop if error

addpath(genpath(fullfile('..','3rdParty')));
addpath(genpath('metric'));

% dataPath = fullfile('..','..','..','data','OpenVideo');
% dataFile = 'family.mov';
% dataFile = 'roadtrip_data.mat';
dataPath = fullfile('..','..','..','data','UCF101');
dataFile = fullfile('videos','v_CleanAndJerk_g04_c01_raw_c.mov');
load(fullfile(dataPath,'groundtruth','gt_v_CleanAndJerk_g04_c01.mat'));
% dataPath = fullfile('..','..','..','data','THUMOS15');
% dataFile = 'thumos15_video_validation_0000700.mat';
data = parseData(dataPath, dataFile);
% data = bsxfun(@minus, data, mean(data,2));
% nPCA = 3;
% data = preprocess(data, nPCA);
[coef,score,latent,~,~,mu] = pca(data');
nPCA = 3;
data = score(:,1:nPCA)';
% whitenScore = score*diag(1./latent.^0.5);
% data = whitenScore(:,1:3)';
numFrame = size(data, 2);
tic
% opt.H_structure = 'HHt';
opt.H_structure = 'HtH';
% opt.metric = 'binlong';
opt.metric = 'JBLD';
% opt.Hsize = 3;
opt.H_rows = 7;
opt.sigma = 1e-4;

horizon = 15;
t = cell(1,numFrame-horizon+1);
for n = horizon : numFrame
    t{n-horizon+1} = data(:,n-horizon+1:n);
%     t{n-horizon} = data(:,1:n);
end

% v = getVelocity(t);
G = getHH(t, opt);
D = HHdist(G,[],opt);
% G1 = getHH(t, opt);
% D1 = HHdist(G1,[],opt);
% opt.H_structure = 'HtH';
% G2 = getHH(t, opt);
% D2 = HHdist(G2,[],opt);
% D = D1 + 10*D2;
displayD(D);
toc
rng(0);
[label,W] = ncutD(D, 5);
displayLabel(label);
toc
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

displayLabel(label, gt, accuracy, nPCA);

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
plot(label,'x');
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
    title(sprintf('Switched system identification with JBLD, Accuracy = %2.2f',accuracy));
elseif nargin == 4
    title(sprintf('Switched system identification with JBLD, Accuracy = %2.2f (%d PCA component)',accuracy, nPCA));
else
    
end
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