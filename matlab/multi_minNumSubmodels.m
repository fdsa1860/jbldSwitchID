function [label, p_hat] = multi_minNumSubmodels(y, u, ny, nu, epsilon)
% multi dimension case

dimY = size(y, 1);
lenY = size(y, 2);
yt = y(:, ny+1:end);
Hy = zeros(dimY*ny, lenY-ny);
for i = 1:dimY
    Hy((i-1)*ny+1:i*ny, :) = hankel(y(i, 1:ny), y(i, ny:end-1));
end
if nu == 0
    H = Hy;
else
    if nu <= ny
%         Hu = hankel(u(ny-nu+1:ny), u(ny:end-1));
        Hu = zeros(dimY*nu, lenY-ny);
        for i = 1:dimY
            Hu((i-1)*nu+1:i*nu, :) = hankel(u(i, ny-nu+1:ny), u(i, ny:end-1));
        end
    else
%         Hu = hankel(u(1:ny+1), u(ny+1:end));
        Hu = zeros(dimY*nu, lenY-ny);
        for i = 1:dimY
            Hu((i-1)*nu+1:i*nu, :) = hankel(u(i, 1:ny+1), u(i, ny+1:end));
        end
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
maxIter = 30;
while nnz(ind) ~= 0
    fprintf('%d/%d samples need to be labeled\n',nnz(label==0), N);
    m = nnz(ind);
    w = ones(m, 1);
    H2 = H(:, ind);
    yt2 = yt(:, ind);
    obj_pre = inf;
    obj = 0;
    iter = 0;
    while abs(obj_pre - obj) > 1e-3 && iter < maxIter
        fprintf('iter = %d ...\n', iter);
        cvx_begin
        cvx_quiet true
        cvx_solver mosek
        obj_pre = obj;
        variables p(d*dimY, m);
        variables p_tilde(d*dimY, 1);
        variables z(m, 1);
        for i = 1:m
            for j = 1:dimY
                p((j-1)*d+1:j*d, i).' * H2((j-1)*d+1:j*d, i) - yt2(j, i) <= epsilon;
                p((j-1)*d+1:j*d, i).' * H2((j-1)*d+1:j*d, i) - yt2(j, i) >= -epsilon;
            end
            norm(p(:,i) - p_tilde, inf) <= z(i);
        end
    
        obj = w.'*z;
        minimize(obj)
        cvx_end
        w = 1 ./ (z + 1e-6);
        iter = iter + 1;
    end
    if iter == maxIter, warning('max iteration achieved.\n'); end
    E = zeros(size(yt));
    for i = 1:m
        for j = 1:dimY
            E(j, i) = p_tilde((j-1)*d+1:j*d).' * H2((j-1)*d+1:j*d, i) - yt2(j, i); 
        end
    end
    e = min(abs(E),[],1);
    indicator = (e <= epsilon) & (label == 0);
    label(indicator) = count;
    count = count + 1;
    ind(indicator) = false;
    p_hat = [p_hat, p_tilde];
end
fprintf('Finished!\n');

end