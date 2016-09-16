% test Necmeye's code

function [label, p] = NecmiyeGreedy_synthetic

close all;
dbstop if error

addpath(genpath(fullfile('..','3rdParty')));
addpath(genpath('metric'));

% var.nSys = 2; % number of systems
% var.den_ord = [2 2];
% var.num_ord = [1 1];
% var.numSample = 100; % number of data samples
% var.numDim = 1;
% var.switchInd = [26 51 76];
% var.hasInput = true;
% var.noiseLevel = 0.00;
% rng(17);
% [y, u, gt, a, b] = switchSysDataGen3(var);
% yOrder = 2;
% uOrder = 1;

var.nSys = 3; % number of systems
var.den_ord = [2 2 2];
var.num_ord = [2 2 2];
var.numSample = 100; % number of data samples
var.numDim = 1;
var.switchInd = [11 29 41 59 73 89];
var.hasInput = true;
var.noiseLevel = 0.1;

% rng(22);
% [y, u, gt, a, b] = switchSysDataGen2(var);
rng(22);
[y, u, gt, a, b] = switchSysDataGen4(var);
plot(y);

epsilon = 0.4;
norm_used = inf;
yOrder = 2;
uOrder = 2;

tic
[label, p] = greedySwitchID(y, u, yOrder, uOrder, epsilon);
toc

label = [label(1)*ones(1,yOrder), label];

% displayRes(label);

accuracy = nnz(label==gt) / length(gt);
displayRes(label, gt, accuracy);

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
fprintf('identification accuracy is %f\n', accuracy);

displayRes(label, gt, accuracy);

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
    title('Switched system identification with Optimal Greedy method');
elseif nargin == 3
    title(sprintf('Switched system identification with Optimal Greedy method, Accuracy = %2.2f%%',accuracy*100));
end

hTitle = get(gca,'Title');
P = get(hTitle,'Position');
set(hTitle,'Position',[P(1), P(2)+0.05, P(3)]);

if nargin > 1
    legend('identified group', 'ground truth group');
end

end