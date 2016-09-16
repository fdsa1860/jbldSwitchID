function [label, p_hat] = greedySwitchID(y, u, ny, nu, epsilon)

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

d = ny + nu;
N = length(y) - ny;

label = zeros(1, N);
p_hat = [];
k = 1;
tao_k = 1;
for i = 1:N
    fprintf('Processed %d/%d samples ... \n',i,N);
    cvx_begin
    cvx_quiet true
    cvx_solver mosek
    variable p(d, 1);
    abs(p.' * H(:,tao_k:i) - yt(tao_k:i)) <= epsilon;
    minimize(0);
    cvx_end
    if cvx_optval ~= 0
        label(tao_k:i-1) = k;
        k = k + 1;
        tao_k = i;
        p_hat = [p_hat, p];
    end
end
label(tao_k:N) = k;
p_hat = [p_hat, p];
fprintf('Finish!\n');
end