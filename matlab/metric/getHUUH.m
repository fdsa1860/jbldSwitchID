
function [HUUH, Hty, Htu] = getHUUH(ty, tu, opt)
% function [HUUH, H] = getHUUH(ty, tu, opt)

if ~exist('opt','var')
    opt.H_structure = 'HHt';
    opt.metric = 'JBLD';
end
if nargout > 1
    Hty = cell(1,length(ty));
    Htu = cell(1,length(tu));
%     H = cell(1, length(ty));
end

HUUH = cell(1,length(ty));
for i=1:length(ty)
    y = ty{i};
    u = tu{i};
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
        Hy = blockHankel(y,[nr nc]);
        Hu = blockHankel(u,[nr-1 nc]);
%         Hu_perp = null(Hu);
%         HUp = Hy * Hu_perp;
%         HHt = HUp * HUp';
        Hyu = [Hy; Hu];
        HHt = Hyu * Hyu';
%         Huy = [Hu; Hy];
%         HHt = Huy * Huy';
    end
    HHt = HHt / norm(HHt,'fro');
    if strcmp(opt.metric,'JBLD') || strcmp(opt.metric,'JBLD_denoise') ...
            || strcmp(opt.metric,'JBLD_XYX') || strcmp(opt.metric,'JBLD_XYY') ...
            || strcmp(opt.metric,'AIRM') || strcmp(opt.metric,'LERM')...
            || strcmp(opt.metric,'KLDM')
        I = opt.sigma*eye(size(HHt));
        HUUH{i} = HHt + I;
    elseif strcmp(opt.metric,'binlong') || strcmp(opt.metric,'SubspaceAngle') ||...
            strcmp(opt.metric,'SubspaceAngleFast')
        HUUH{i} = HHt;
    end
    if nargout > 1
        Hty{i} = Hy;
        Htu{i} = Hu;
%         H{i} = Huy;
    end
end

end