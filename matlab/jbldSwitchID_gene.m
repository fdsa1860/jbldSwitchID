
function jbldSwitchID_gene
% test graph cut with JBLD distance

close all;
dbstop if error

addpath(genpath(fullfile('..','3rdParty')));
addpath(genpath('metric'));

% load data
load ClusteredData_Figure3.mat
DI=DIAUXIE_DATA_CLUST;
ec=EcocycNameofCLUST;
% v1=DI(897,:);  %%lacZ;
% v2=DI(898,:);  %%galE;
% v3=DI(760,:); %%galS;
% v=[v1;v2;v3];
 v1=DI(78,:);  %%rpsP;
 v2=DI(329,:);  %%rpsM;
 v3=DI(58,:); %%rplN;
 v4=DI(59,:); %%rplY
 v=[v1;v2;v3;v4];
% figure
% hold on
% plot(v1,'b');
% plot(v2,'g');
% plot(v3,'r');
% legend('lacZ','galE','galS');
% grid


y = v;
% identificaation
opt.H_structure = 'HHt';
opt.metric = 'JBLD';
% opt.Hsize = 3;
opt.H_rows = 3;
opt.sigma = 1e-4;
horizon = 15;
nSys = 3;

tic
ty = cell(1,length(y)-horizon+1);
for i = 1 : length(ty)
    ty{i} = y(:,i:i+horizon-1);
end

G = getHH(ty, opt);
D = HHdist(G,[],opt);
displayD(D);

numNeighbors = floor(size(y, 2) / 4);
[label,W] = ncutD(D, nSys, numNeighbors);
toc

nEigVal = 10;
d = sum(W);
DInvSqrt = diag( 1 ./ sqrt(d+eps) );
L = eye(size(W)) - DInvSqrt * W * DInvSqrt;
% [eigVec, EigVal] = eigs(L,nEigVal,'SM');
[eigVec, EigVal] = eig(L);
eigVal = diag(EigVal);
eigVal = sort(eigVal);
eigVal = eigVal(1:nEigVal);
displayEigenValue(eigVal, nEigVal);

label = [label(1)*ones(horizon-1, 1); label]';

displayRes(label);

figure
hold on
% plot(v1,'b');
% plot(v2,'g');
% plot(v3,'r');
plot(y');
plot((label-1) / (nSys-1),'o');
legend('lacZ','galE','galS','label');
grid
title('JBLD Graphcut results on gene data');


gt = ones(1, 97);

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

c = cell(1, nSys);
Gm = cell(1, nSys);
label(1:horizon-1) = [];
for i = 1:nSys
    Gm{i} = steinMean(cat(3,G{label==i}));
    [U,S,V] = svd(Gm{i});
    c{i} = U(:,end).';
    c{i} = -c{i} / c{i}(end);
end
Hy = blockHankel(y, [opt.H_rows*size(y,1), size(y,2)-opt.H_rows+1]);
figure;
plot(c{1}*Hy, '*');
hold on;
plot(c{2}*Hy, '*');
plot(c{3}*Hy, '*');
% plot(gt(3:end), 'o');
hold off;
legend residue1 residue2 residue3 groundtruth

newLabel = zeros(size(label));
r = zeros(nSys, size(y,2) - opt.H_rows + 1);
for i = 1:nSys
r(i,:) = c{i}*Hy;
end
[~, newLabel] = min(abs(r));

clear label;
label = [newLabel(1)*ones(1, opt.H_rows-1), newLabel];
v = perms(1:length(unique(label)));
nMatch = zeros(1,size(v,1));
for i = 1:length(nMatch)
    nMatch(i) = nnz(v(i,label)==gt);
end
[~,ind] = max(nMatch);
% accuracy
label = v(ind,label);
accuracy = nnz(label==gt) / length(gt);
accuracy
55

end

function displayD(D)

figure;
imagesc(D);
xlabel('indices of segments');
ylabel('indices of segments');
title('JBLD distance matrix of each pair of trajectory segments');
colorbar;

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
    title('Switched system identification with JBLD Graphcut');
elseif nargin == 3
    title(sprintf('Switched system identification with JBLD Graphcut, Accuracy = %2.2f%%',accuracy*100));
end

hTitle = get(gca,'Title');
P = get(hTitle,'Position');
set(hTitle,'Position',[P(1), P(2)+0.05, P(3)]);

legend('identified group', 'ground truth group');

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
