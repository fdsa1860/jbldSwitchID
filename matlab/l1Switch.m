function [Theta, label] = l1Switch(X, y, epsilon)

delta = 1e-6;
thres = 1e-6;
n = size(X, 1);
d = size(X, 2);

w = ones(n-1, 1);

ind0 = zeros(n-1, 1);
count = 0;
maxIter = 100;
for iter = 1:maxIter
    fprintf('running Iter %d ...\n', iter);
    cvx_begin quiet
    variable Theta(n, d)
    variable v(n-1, 1)
    e = sum(X.*Theta, 2) - y;
    e >= -epsilon
    e <= epsilon
    obj = sum(w .* sum((Theta(2:n,:) - Theta(1:n-1,:)).^2, 2));
    minimize(obj);
    cvx_end
    
    v = sum((Theta(2:n,:) - Theta(1:n-1,:)).^2, 2);
    %     Theta
    ind = (v > thres);
    if all(ind == ind0)
        count = count + 1;
    else
        count = 0;
    end
    
    if count > 3;
        break;
    end
    fprintf('Get %d nonzeros\n', nnz(ind));
    
    ind0 = ind;
    w = 1 ./ (v + delta);
end


label = cumsum([1; ind]);