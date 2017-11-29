function sIndex = switchDetection3(D)

numSample = size(D, 1);
kNN = round(0.3 * numSample);
% [label,W] = ncutD(D, nSys, numNeighbors);

% KNN
D = D - min(D(:));
D2 = D;
for j = 1:numSample
    [~,ind] = sort(D(:,j));
    D2(ind(kNN+1:end),j) = Inf;
    D2(ind(1:kNN),j) = D(ind(1:kNN),j) / max(D(ind(1:kNN),j)) * 0.5;
end
D = (D2+D2')/2;


55

end