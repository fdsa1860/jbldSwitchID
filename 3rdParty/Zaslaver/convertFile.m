f = dir('*.asv');
for i = 1:length(f)
    [a,b,c] = fileparts(f(i).name);
    newName = [b, '.m'];
    movefile(f(i).name, newName);
end