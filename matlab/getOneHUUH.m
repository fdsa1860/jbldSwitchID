
function [HUUH, Hy, Hu] = getOneHUUH(y, u, opt)

if ~exist('opt','var')
    opt.H_structure = 'HHt';
    opt.metric = 'JBLD';
end

if strcmp(opt.H_structure,'HtH')
    Hsize = opt.H_rows;
    nc = Hsize;
    nr = size(y,1)*(size(y,2)-nc+1);
    if nr<1, error('hankel size is too large.\n'); end
    Hy = blockHankel(y,[nr nc]);
    Hu = blockHankel(u,[nr nc]);
    Hu_perp = null(Hu);
    HUp = Hy * Hu_perp;
    HHt = HUp' * HUp;
elseif strcmp(opt.H_structure,'HHt')
    nr = opt.H_rows * size(y,1);
    nc = size(y,2) - opt.H_rows + 1;
    if nc<1, error('hankel size is too large.\n'); end
    Hy = blockHankel(y,[nr, nc]);
    Hu = blockHankel(u,[nr-1, nc]);
    %         Hu_perp = null(Hu);
    %         HUp = Hy * Hu_perp;
    %         HHt = HUp * HUp';
    Hyu = [Hy; Hu];
    HHt = Hyu * Hyu';
end
HHt = HHt / norm(HHt,'fro');
if strcmp(opt.metric,'JBLD') || strcmp(opt.metric,'JBLD_denoise') ...
        || strcmp(opt.metric,'JBLD_XYX') || strcmp(opt.metric,'JBLD_XYY') ...
        || strcmp(opt.metric,'AIRM') || strcmp(opt.metric,'LERM')...
        || strcmp(opt.metric,'KLDM')
    I = opt.sigma*eye(size(HHt));
    HUUH = HHt + I;
elseif strcmp(opt.metric,'binlong') || strcmp(opt.metric,'SubspaceAngle') ||...
        strcmp(opt.metric,'SubspaceAngleFast')
    HUUH = HHt;
end


end