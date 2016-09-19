% test Necmeye's code

function [label, p] = NecmiyeMinSubmodel_stitchMHAD

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
% nPCA = 3;
data3 = U(:,1:nPCA)' * data3;
y = diff(data3,[],2);
ymax = max(abs(y), [], 2);
y = bsxfun(@rdivide, y, ymax);
plot(y');

epsilon = 0.1;
norm_used = inf;
yOrder = 2;
uOrder = 0;

tic
[label, p] = multi_minNumSubmodels(y, [], yOrder, uOrder, epsilon);
toc

label = [label(1)*ones(1,yOrder+1), label];

displayRes(label);

displayRes(label, gt);

% gt2 = diff(gt);
% gt2 = [0 gt2];
% gt2 = (gt2~=0);
% gt2 = cumsum(gt2) + 1;

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
    title('Switched system identification with Minimum Number Of Submodels');
elseif nargin == 3
    title(sprintf('Switched system identification with Minimum Number Of Submodels, Accuracy = %2.2f%%',accuracy*100));
end

hTitle = get(gca,'Title');
P = get(hTitle,'Position');
set(hTitle,'Position',[P(1), P(2)+0.05, P(3)]);

if nargin > 1
    legend('identified group', 'ground truth group');
end

end