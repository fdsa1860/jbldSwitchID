function jbldSwitchID_stitchMHAD_acc
% test graph cut with JBLD distance

close all;
dbstop if error

addpath(genpath(fullfile('..','3rdParty')));
addpath(genpath('metric'));

[data, gt] = genDataStitchMHAD;
numFrame = size(data, 2);
tic
% opt.H_structure = 'HHt';
opt.H_structure = 'HtH';
% opt.metric = 'binlong';
opt.metric = 'JBLD';
% opt.metric = 'AIRM';
% opt.metric = 'LERM';
% opt.metric = 'KLDM';
% opt.Hsize = 3;
opt.H_rows = 40;
% opt.H_rows = 5;
opt.sigma = 1e-4;

horizon = 50;
t = cell(1,numFrame-horizon+1);
for n = horizon : numFrame
    t{n-horizon+1} = data(:,n-horizon+1:n);
    %     t{n-horizon} = data(:,1:n);
end

v = getVelocity(t);
[G, H] = getHH(v, opt);

%%
idx = 500;
opt.metric = 'JBLD';
y1 = HHdist(G(idx),G,opt);
plot(y1, '*');
hold on;
opt.metric = 'JBLD_XYX';
y2 = HHdist(G(idx),G,opt);
plot(y2, '*');
opt.metric = 'JBLD_XYY';
y3 = HHdist(G(idx),G,opt);
plot(y3, '*');
hold off;
xlabel('Segment indices');
ylabel('Distance between anchor segment and all segments');
title(sprintf(['JBLD between anchor segment X (index 500) and all segments Y,'...
    '%s, Horizon=%d, H column = %d'],opt.H_structure, horizon, opt.H_rows));
legend('JBLD(X,Y)','JBLD((X+Y)/2,X)','JBLD((X+Y)/2,Y)');

figure;hold on;
s1 = svd(H{500});
s1 = s1 / norm(s1);
plot(s1(1:30),'*');
s2 = svd(H{200});
s2 = s2 / norm(s2);
plot(s2(1:30),'*');
s3 = svd([H{500}, H{200}]);
s3 = s3 / norm(s3);
plot(s3(1:30),'*');
hold off;
legend('svd(H\{500\}) (anchor segment)','svd(H\{200\})','svd([H\{500\}, H\{200\}])');
xlabel('indices of singular values');
ylabel('Singular values');
title(sprintf('SVD of Segment 500, Segment 200 and their combination, %s',opt.H_structure));
%%
% opt.metric = 'JBLD';
% D1 = HHdist(G,[],opt);
% figure; imagesc(D1); colorbar;
% opt.metric = 'JBLD_XYX';
% D2 = HHdist(G,G,opt);
% figure; imagesc(D2); colorbar;
% opt.metric = 'JBLD_XYY';
% D3 = HHdist(G,G,opt);
% figure; imagesc(D3); colorbar;
11
end