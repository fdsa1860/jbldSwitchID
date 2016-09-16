function jbldGreedy_synthetic
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
% var.switchInd = [22 58 74 118 146 178];
% var.switchInd = [100];
var.hasInput = true;
var.noiseLevel = 0.1;

% rng(22);
% [y, u, gt, a, b] = switchSysDataGen2(var);
rng(22);
[y, u, gt, a, b] = switchSysDataGen4(var);

plot(y);

opt.H_structure = 'HHt';
opt.metric = 'JBLD';
opt.H_rows = 3;
opt.sigma = 1e-4;
opt.horizon = 7;
opt.thres = 1.3;
% opt.thres = 2.3;

tic
label = jbldGreedy(y, u, opt);
toc

label = [label(1)*ones(opt.horizon-1, 1); label]';
% gt(1:horizon-1) = [];
% gtCut = gt(horizon:end);

displayRes(label, gt);

gt = diff(gt);
gt = [0 gt];
gt = (gt~=0);
gt = cumsum(gt) + 1;

if length(unique(label)) > 10, error('too many clusters!\n'); end
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
    title('Switched system identification with JBLD greedy method');
elseif nargin == 3
    title(sprintf('Switched system identification with JBLD greedy method, Accuracy = %2.2f%%',accuracy*100));
end

hTitle = get(gca,'Title');
P = get(hTitle,'Position');
set(hTitle,'Position',[P(1), P(2)+0.05, P(3)]);

legend('identified group', 'ground truth group');

end