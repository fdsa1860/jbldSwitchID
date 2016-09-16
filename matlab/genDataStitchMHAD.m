function [newData, gt] = genDataStitchMHAD

addpath(genpath('.'));

load ../expData/MHAD_data_whole;

indSet = [1 1+5 1+5*2 2+5 1+5*3 3+5];
% indSet = [1 1+5 1+5*2 2+5+55 1+5*3 3+5+55*2];

newData = data{indSet(1)};
gt = label_act(indSet(1)) * ones(1,size(newData,2));
for i = 2:length(indSet)
    newData = stitchData(newData, data{indSet(i)});
    gt = [gt, label_act(indSet(i)) * ones(1,size(data{indSet(i)},2))];
end

if 0
    show_skel_MHAD(newData);
end

end