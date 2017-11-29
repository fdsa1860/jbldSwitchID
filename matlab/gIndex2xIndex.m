function [xLabel, xInd] = gIndex2xIndex(gLabel, gInd, horizon, order)

ng = length(gInd);
m = horizon - order - 1;
nx = ng + m;
xLabel = zeros(nx, 1);
xInd = false(nx, 1);
indexH = hankel(1:m+1, m+1:nx);
xInd(indexH(:, gInd)) = true;
for i = 1:ng
    if ~gInd(i)
        continue;
    end
    for j = 1:m+1
        if xLabel(indexH(j,i)) == 0
            xLabel(indexH(j,i)) = gLabel(i);
        elseif xLabel(indexH(j,i)) ~= gLabel(i)
            error('something wrong.\n');
        end
    end
end