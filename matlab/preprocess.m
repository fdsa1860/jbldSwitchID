function data = preprocess(data, nPCA)
% preprocess THUMOS 700

if nargin < 2
    nPCA = 3;
end

data1 = data(:, 520:600); % first person
[coef1,score1,latent1,~,~,mu1] = pca(data1');
data1 = score1(:,1:nPCA)';

data2 = data(:, 1260:1360); % second person
[coef2,score2,latent2,~,~,mu2] = pca(data2');
data2 = score2(:,1:nPCA)';

data3 = data(:, 2360:2440); % third person
[coef3,score3,latent3,~,~,mu3] = pca(data3');
data3 = score3(:,1:nPCA)';

data4 = data(:, 2441:2600);
[coef4,score4,latent4,~,~,mu4] = pca(data4');
data4 = score4(:,1:nPCA)';

% data = [data1, data2, data3];
data = [data1, data2, data3, data4];

end