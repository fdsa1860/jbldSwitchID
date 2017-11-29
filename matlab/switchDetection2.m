function sIndex = switchDetection2(G, horizon, order)

n = length(G);
sIndex = zeros(n, 1);
d = 100*ones(n, 1);

thres = 4.8;
i1 = 1; % anchor point
i2 = 1;
i = 1;
while i2 <= n
    d(i) = JBLD(G{i1}, G{i2});
    if d(i) > thres
        i1 = i + horizon - order - 1;
        d(i+1:i1-1) = thres;
        i2 = i1;
        i = i1;
    else
        i2 = i2 + 1;
        i = i + 1;
    end
    
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