function index = getRobustIndex(label, horizon, order)

winSize = 2*(horizon-order)-1;
b = double(diff(label)~=0);
b = [0; b] + [b; 0];
f = ones(winSize, 1);
c = conv(b, f, 'same');
index = (c == 0);

end