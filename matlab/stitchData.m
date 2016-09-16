function newData = stitchData(data1, data2)
% stitch two skeleton data together

xyz_hip1 = data1(1:3,end);
xyz_hip2 = data2(1:3,1);
dxyz = xyz_hip2 - xyz_hip1;
data2 = data2 - kron(ones(35, size(data2,2)), dxyz);
newData = [data1 data2];

end