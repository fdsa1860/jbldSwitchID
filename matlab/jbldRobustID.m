function [P, label] = jbldRobustID(y, u, nSys, order)

opt.H_structure = 'HHt';
opt.metric = 'JBLD';
% opt.Hsize = 3;
opt.H_rows = 3;
opt.sigma = 1e-4;
horizon = 7;

numSample = length(y);

ty = cell(1,length(y)-horizon+1);
tu = cell(1,length(u)-horizon+1);
for i = 1 : length(ty)
    ty{i} = y(:,i:i+horizon-1);
    tu{i} = u(:,i:i+horizon-1);
end

[G, Hty, Htu] = getHUUH(ty, tu, opt);
D = HHdist(G,[],opt);
% displayD(D);

numNeighbors = 0.15 * numSample;
[gLabel,W] = ncutD(D, nSys, numNeighbors);
% label = [label(1)*ones(ceil(horizon/2)-order, 1); label; label(end)*ones(ceil((horizon+1)/2)-order, 1)]';

% get robust indices
gIsRobust = getRobustIndex(gLabel, horizon, order);
[xLabel, xIsRobust] = gIndex2xIndex(gLabel, gIsRobust, horizon, order);

% get model parameters
nSys = length(unique(gLabel));
p = cell(1, nSys);
Gm = cell(1, nSys);
for i = 1:nSys
    Gm{i} = steinMean(cat(3,G{gLabel==i & gIsRobust}));
    [U,S,V] = svd(Gm{i});
    p{i} = U(:,end).';
    p{i} = -p{i} / p{i}(order+1);
end
P = cell2mat(p');

Hy = hankel(y(1:order+1), y(order+1:end));
Hu = hankel(u(1:order), u(order:end-1));
X = [Hy; Hu];

r = abs(P * X);
% [~, label] = min(r);
[~, label] = min(r);

label(xIsRobust) = xLabel(xIsRobust);

end