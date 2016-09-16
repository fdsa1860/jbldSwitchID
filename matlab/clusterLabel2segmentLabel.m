function sLabel = clusterLabel2segmentLabel(cLabel, shortSegmentThres)
% clusterLabel2segmentLabel

if nargin < 2
    shortSegmentThres = 10;
end

if iscolumn(cLabel)
    cLabel = cLabel.';
end

sLabel = zeros(size(cLabel));
ind = find(diff(cLabel)) + 1; % indices of switches
ind = [1, ind, length(cLabel)]; % add head and end
ind = removeShortSegments(ind, shortSegmentThres);
sLabel(ind) = 1;
sLabel = cumsum(sLabel);

end

function ind = removeShortSegments(ind, shortSegmentThres)
% remove short segments

count = 2;
while count <= length(ind)
    if ind(count) - ind(count-1) < shortSegmentThres
        ind(count) = [];
    else
        count = count + 1;
    end
end
ind(end) = [];

end