
function group = indep_dyn_switch_detect_withInput(data,norm_used,epsilon,yOrder,u,uOrder)

%without offset
[num_frame, num_pc] = size(data);
[num_frame_u, num_pc_u] = size(u);
assert(num_frame_u==num_frame && num_pc_u==num_pc);
num_frame = num_frame -yOrder;
%assume all coordinates evolve with independent dynamics 
l = yOrder + uOrder;

%num_pc = num_pc*order;
M1 = [zeros(num_frame,1) -eye(num_frame)];
M1 = eye(num_frame)+M1(:,1:end-1);
M1 = sparse(M1(1:end-1,:));
M1 = kron(M1,eye(num_pc*l));

%  S = SPARSE(i,j,s,m,n,nzmax)
A = sparse([],[],[],num_pc*num_frame,l*num_pc*num_frame);

rcount = 1;
ccount = 1;
for i = 1:num_frame
    for j = 1:num_pc
        A(rcount,ccount:ccount+yOrder-1) = data(i:i+yOrder-1,j)';
        A(rcount,ccount+yOrder:ccount+l-1) = u(i+yOrder-uOrder:i+yOrder-1,j)';
        rcount = rcount+1;
        ccount = ccount+l;
    end
end

rhs = data(yOrder+1:num_frame+yOrder,:)';
rhs = rhs(:);
W = ones(num_frame-1,1);
num_param = num_frame*num_pc*l;
%keyboard;
delta = 10^-5;
nnzs = [];
cvx_quiet(true);
conv_criteria = 3;
for k = 1:100
  cvx_begin
  cvx_solver mosek
    variable x_log(num_param)
    variable z(num_frame-1)
    c = reshape(abs(M1*x_log),[num_pc*l,num_frame-1]);
    minimize( sum( W.*z ) )
    subject to
      z >= max(c)';
      norm(A*x_log - rhs,norm_used) <= epsilon;
  cvx_end

  % display new number of nonzeros in the solution vector
  nnz = length(find( z > delta ));
  nnzs = [nnzs nnz];
  fprintf(1,'   found a solution with %d nonzeros...\n', nnz);
  if nnz==0
      break
  elseif (k>=conv_criteria)
      if sum(diff(nnzs(k-conv_criteria+1:k)))==0
          break
      end
  end
  % adjust the weights and re-iterate
  W = 1./(delta + z);
end
cvx_quiet(false);

x = x_log;
num_pc = num_pc*yOrder;
if isempty(x); display('infeasible!!'); group =[]; return; end

p_est = x(1:num_param);

% figure;
% plot(p_est(1:num_pc:end),'b*');
% % for i = 1:num_pc
% %     title('Segmentation Drama Sequence');
% %     subplot(num_pc,1,i);plot(p_est(i:num_pc:end),'b*');
% %     y = strcat('p_',num2str(i));
% %     ylabel(y);
% % end
% figure;plot(A*x-rhs)

ind1 = find( z > delta );
ind = [1 ind1' num_frame];
l = length(ind);

ind(l) = num_frame+1;
group = [];
for i = 1:l-1;
    group = [group i*ones(1,ind(i+1)-ind(i))];
end
figure; plot(group,'b*');