function label = histSegmentation(data)

binEdges = 0:0.01:1;
shortSegThres = 10;
nCluster = 6;

dim = length(binEdges) - 1;
data2 = zeros(dim, size(data,2));
for i = 1:size(data, 2)
    data2(:,i) = histcounts(data(:,i), binEdges);
end
data = data2;

D = pdist2(data', data');
displayD(D);
rng(0);
[label,W] = ncutD(D, nCluster, 1000);
% displayLabel(label);

label = clusterLabel2segmentLabel(label, shortSegThres);
displayLabel(label);

end

function displayD(D)

figure;
imagesc(D);
xlabel('indices of segments');
ylabel('indices of segments');
title('Histogram euclidean distance matrix of each pair of frames');
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