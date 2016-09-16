% test Necmeye's code

function NecmereSwitchID_RealData

close all;
dbstop if error

addpath(genpath(fullfile('..','3rdParty')));
addpath(genpath('metric'));

% dataPath = fullfile('..','..','..','data','OpenVideo');
% dataFile = 'family.mov';
% dataFile = 'roadtrip_data.mat';
dataPath = fullfile('..','..','..','data','UCF101');
dataFile = 'v_CleanAndJerk_g03_c01_raw_c.mov';
data = parseData(dataPath, dataFile);

% data = bsxfun(@minus, data, mean(data,2));
[coef,score,latent,~,~,mu] = pca(data');
data = score(:,1:3)';
numFrame = size(data, 2);
tic
epsilon = 0.3;
norm_used = inf;
order = 3;
% group = l1_switch_detect(data',norm_used,epsilon);
group = indep_dyn_switch_detect(data',norm_used,epsilon,order);
% group = indep_dyn_switch_detect_mosek(data',norm_used,epsilon,order);
% group = multidim_dyn_switch_detect(data',norm_used,epsilon,order);

plot(group,'*');
toc
end