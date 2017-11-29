% test benchmark

addpath(genpath('../matlab'));
addpath(genpath(fullfile('..','3rdParty')));

option.dataIndex = 1;

% option.method = 'contOpt';
% option.method = 'kLinReg';
% option.method = 'SON_EM';
% option.method = 'l1Switch';
% option.method = 'jbldSwitchID';
% option.method = 'jbldRobust';
option.method = 'jbldSwitchDetID';

accuracy = benchmark(option);