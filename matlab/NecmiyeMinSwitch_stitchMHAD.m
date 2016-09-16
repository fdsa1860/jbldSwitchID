% test Necmeye's code

function NecmereSwitchID_stitchMHAD

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

% data = data(1,:);
data = data / max(max(data));

epsilon = 0.1;
norm_used = inf;
order = 3;

tic
% label = l1_switch_detect(data',norm_used,epsilon);
% label = indep_dyn_switch_detect(data',norm_used,epsilon,order);
label = indep_dyn_switch_detect_mosek(data',norm_used,epsilon,order);
% label = multidim_dyn_switch_detect(data',norm_used,epsilon,order);
toc

label = [label(1)*ones(1,order), label];

displayRes(label);

displayRes(label, gt);

gt2 = diff(gt);
gt2 = [0 gt2];
gt2 = (gt2~=0);
gt2 = cumsum(gt2) + 1;

v = perms(1:length(unique(label)));
nMatch = zeros(1,size(v,1));
for i = 1:length(nMatch)
    nMatch(i) = nnz(v(i,label)==gt2);
end
[~,ind] = max(nMatch);
% accuracy
label = v(ind,label);
% label = [gt(1:horizon-1) label];
accuracy = nnz(label==gt2) / length(gt2);
fprintf('identification accuracy is %f\n', accuracy);

displayRes(label, gt2, accuracy);

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
    title('Switched system identification with Minimum Switches Method');
elseif nargin == 3
    title(sprintf('Switched system identification with Minimum Switches Method, Accuracy = %2.2f%%',accuracy*100));
end

hTitle = get(gca,'Title');
P = get(hTitle,'Position');
set(hTitle,'Position',[P(1), P(2)+0.05, P(3)]);

if nargin > 1
    legend('identified group', 'ground truth group');
end

end