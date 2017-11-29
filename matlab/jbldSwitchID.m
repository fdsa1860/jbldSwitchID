function [p, label] = jbldSwitchID(y, u, nSys, order)

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
[label,W] = ncutD(D, nSys, numNeighbors);

% get model parameters
nSys = length(unique(label));
p = cell(1, nSys);
Gm = cell(1, nSys);
for i = 1:nSys
    Gm{i} = steinMean(cat(3,G{label==i}));
    [U,S,V] = svd(Gm{i});
    p{i} = U(:,end).';
    p{i} = -p{i} / p{i}(order+1);
end

label = [label(1)*ones(ceil(horizon/2)-order, 1); label; label(end)*ones(ceil((horizon+1)/2)-order, 1)]';

end