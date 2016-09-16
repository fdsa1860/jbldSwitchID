% test video with caffe PCA feature

addpath(genpath(fullfile('..','3rdParty')));
addpath(genpath('metric'));

dataDir1 = fullfile('..','expData','FinalFeatures_generalizedPCA','Action1');
dataDir2 = fullfile('..','expData','FinalFeatures_generalizedPCA','Action2');

files1 = dir(fullfile(dataDir1, '*.mat'));
files2 = dir(fullfile(dataDir2, '*.mat'));
data = cell(1, length(files1)+length(files2));
for i = 1:length(files1)
   load(fullfile(dataDir1, files1(i).name), 'Y');
   data{i} = Y;
end
for i = 1:length(files2)
   load(fullfile(dataDir2, files2(i).name), 'Y');
   data{length(files1)+i} = Y;
end

opt.H_structure = 'HHt';
% opt.H_structure = 'HtH';
% opt.metric = 'JBLD';
opt.metric = 'binlong';
% opt.Hsize = 3;
opt.H_rows = 6;
opt.sigma = 1e-4;

G = getHH(data, opt);
D = HHdist(G,[],opt);
figure;imagesc(D); colorbar;
