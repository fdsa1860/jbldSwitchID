function sIndex = switchDetection(G, horizon, order, opt)

n = length(G);
sIndex = zeros(n, 1);
d = zeros(n-1, 1);
% for i = 1:n-horizon+order
for i = 1:n-1
    i1 = i;
    i2 = i + 1;
%     i2 = i + horizon - order;
    d(i) = JBLD(G{i1}, G{i2});
%     d(i) = gramDist_cccp(G{i1}, G{i2}, opt);
end

nVar = 1;
mOrd = 2;
[basis, ~] = momentPowers(0, nVar, mOrd);
[L, Minv] = getInverseMomentMat(d, mOrd);

thres = nchoosek(mOrd+nVar, mOrd);

n2 = length(d);
V = zeros(size(basis, 1), n2);
for i = 1:n2
    x = d(i);
    v = prod( bsxfun( @power, x, basis), 2);
    V(:, i) = v;
%     P(i) = v' * Minv * v;  
end
Q = L * V;
q = sum(Q.^2);


plot(q, '*');hold on; plot(1:93,3*ones(1,93)); hold off;

55

end