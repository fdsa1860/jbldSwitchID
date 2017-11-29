function accuracy = benchmark(option)

if option.dataIndex == 1
    
    var.nSys = 3; % number of systems
    % var.sysOrders = [3 3 3]; % order for each system, minimum 2
    % var.den_ord = [3 3 3];
    var.den_ord = [2 2 2];
    var.num_ord = [2 2 2];
    var.numSample = 100; % number of data samples
    var.numDim = 1;
    var.switchInd = [11 29 41 59 73 89] * 1;
    % var.switchInd = [ 20 40 60 80] * 1;
    % var.switchInd = [22 58 74 118 146 178];
    % var.switchInd = [100];
    var.hasInput = true;
    var.noiseLevel = 0.0;
    
    % [y, u, gt, sys_par] = switchSysDataGen(var);
    % [y, u, x, gt] = switchSysStateDataGen(var);
    % rng(22);
    % [y, u, gt, a, b] = switchSysDataGen2(var);
    rng(22);
    [y, u, gt, a, b, e] = switchSysDataGen4(var);
    gt = gt(3:end);
    
    Hy = hankel(y(1:3), y(3:end));
    Hu = hankel(u(1:2), u(2:end-1));
    X = [Hu; Hy];
    
end

if strcmp(option.method, 'contOpt')
    [W,label,obj] = cofsr(X(1:4,:)',X(end,:)',3,'ls');
    label = label';
elseif strcmp(option.method, 'kLinReg')
    [W,label] = klinreg(X(1:4,:)',X(end,:)',3); 
    label = label';
elseif strcmp(option.method, 'SON_EM')
    lambda1 = 1;
    p = 1;
    [~, W, label] = son_EM_son(X(end,:)', X(1:4,:)', size(X,2), 3, lambda1, p);
elseif strcmp(option.method, 'l1Switch');
    epsilon = 0.01;
    [W, label] = l1Switch(X(1:4,:)', X(end,:)', epsilon);
elseif strcmp(option.method, 'jbldSwitchID')
    [W, label] = jbldSwitchID(y, u, 3, 2);
elseif strcmp(option.method, 'jbldRobust')
    [W, label] = jbldRobustID(y, u, 3, 2);
elseif strcmp(option.method, 'jbldSwitchDetID')
    [W, label] = jbldSwitchDetID(y, u, 3, 2);
end

% match label and gt
v = perms(1:length(unique(label)));
nMatch = zeros(1,size(v,1));
for i = 1:length(nMatch)
    nMatch(i) = nnz(v(i,label)==gt);
end
[~,ind] = max(nMatch);
% accuracy
label = v(ind,label);
% label = [gt(1:horizon-1) label];
accuracy = nnz(label==gt) / length(gt) * 100;

format short
fprintf('identification accuracy is %.02f%%\n', accuracy);


% display
plot(label,'*')
hold on;
plot(gt,'o');
hold off;
legend label groundtruth
title(sprintf('Method: %s, Accuracy is %.02f%%',option.method,accuracy));

end