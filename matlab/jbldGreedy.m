function label = jbldGreedy(y, u, opt)

assert(size(y,1)==size(u,1) && size(y,2)==size(u,2));
h = opt.horizon;
N = size(y, 2) - h + 1;

label = zeros(N, 1);
k = 1;
tao_k = 1;
for i = 1:N
    fprintf('Processed %d/%d samples ... \n',i,N);
    if i <= tao_k
        continue;
    end
    G1 = getOneHUUH(y(tao_k:tao_k+h-1), u(tao_k:tao_k+h-1), opt);
    G2 = getOneHUUH(y(tao_k:i+h-1), u(tao_k:i+h-1), opt);
%     G1 = getOneHUUH(y(i-1:i+h-2), u(i-1:i+h-2), opt);
%     G2 = getOneHUUH(y(i:i+h-1), u(i:i+h-1), opt);
    d = JBLD(G1, G2);
    d
    if d > opt.thres
        label(tao_k:i-1) = k;
        k = k + 1;
        tao_k = min([i+h-1,N]);
        label(i:tao_k) = k;
    end
end
label(tao_k:N) = k;
fprintf('Finish!\n');

end