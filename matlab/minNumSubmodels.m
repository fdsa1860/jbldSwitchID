function [label, p_hat] = minNumSubmodels(y, u, ny, nu, epsilon)

yt = y(ny+1:end);
Hy = hankel(y(1:ny), y(ny:end-1));
if nu == 0
    H = Hy;
else
    if nu <= ny
        Hu = hankel(u(ny-nu+1:ny), u(ny:end-1));
    else
        Hu = hankel(u(1:ny+1), u(ny+1:end));
    end
    H = [Hy; Hu];
end

% d = ny + nu + 1;
d = ny + nu;
N = length(y) - ny;

% epsilon = 1e-3;

label = zeros(1, N);
ind = true(1, N);
p_hat = [];
count = 1;
maxIter = 10;
while nnz(ind) ~= 0
    fprintf('%d/%d samples need to be labeled\n',nnz(label==0), N);
    m = nnz(ind);
    w = ones(m, 1);
    H2 = H(:, ind);
    yt2 = yt(ind);
    obj_pre = inf;
    obj = 0;
    iter = 0;
    while abs(obj_pre - obj) > 1e-3 && iter < maxIter
        cvx_begin
        cvx_quiet true
        cvx_solver mosek
        obj_pre = obj;
        variables p(d, m);
        variables p_tilde(d, 1);
        variables z(m, 1);
        for i = 1:m
            abs(p(:,i).' * H2(:,i) - yt2(i)) <= epsilon;
            norm(p(:,i) - p_tilde, inf) <= z(i);
        end
        
        obj = w.'*z;
        minimize(obj)
        cvx_end
        w = 1 ./ (z + 1e-6);
        iter = iter + 1;
    end
    if iter == maxIter, warning('max iteration achieved.\n'); end
    indicator = (abs(p_tilde.' * H - yt) <= epsilon) & (label == 0);
    label(indicator) = count;
    count = count + 1;
    ind(indicator) = false;
    p_hat = [p_hat, p_tilde];
end
fprintf('Finished!\n');

end