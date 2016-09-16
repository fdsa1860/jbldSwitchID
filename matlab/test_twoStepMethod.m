function test_twoStepMethod
% use histogram to get first level segments
% use dynamic to get second level segments

close all;
dbstop if error

addpath(genpath(fullfile('..','3rdParty')));
addpath(genpath('metric'));

% dataPath = fullfile('..','..','..','data','OpenVideo');
% dataFile = 'family.mov';
% dataFile = 'roadtrip_data.mat';
% dataPath = fullfile('..','..','..','data','UCF101');
% dataFile = fullfile('videos','v_CleanAndJerk_g04_c01_raw_c.mov');
% load(fullfile(dataPath,'groundtruth','gt_v_CleanAndJerk_g04_c01.mat'));
dataPath = fullfile('..','..','..','data','THUMOS15');
dataFile = 'thumos15_video_validation_0000700.mat';
data = parseData(dataPath, dataFile);
label = histSegmentation(data);
displayLabel(label);

numFrame = size(data, 2);
nPCA = 5;
data2 = zeros(nPCA, numFrame);
count = 0;
uL = unique(label);
for i = 1:length(uL)
    n = nnz(label == uL(i));
    temp = data(:,label == uL(i));
    [~,score] = pca(temp');
    data2(:,count+1:count+n) = score(:,1:nPCA)';
    count = count + n;
end
data = data2;


tic
% opt.H_structure = 'HHt';
opt.H_structure = 'HtH';
% opt.metric = 'binlong';
opt.metric = 'JBLD';
% opt.Hsize = 3;
opt.H_rows = 7;
opt.sigma = 1e-4;

horizon = 100;
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
[label,W] = ncutD(D, 6);
displayLabel(label);
toc

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