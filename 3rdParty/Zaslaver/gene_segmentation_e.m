close all
clear all
load ClusteredData_Figure3.mat
 DI=DIAUXIE_DATA_CLUST;
 ec=EcocycNameofCLUST;
%%%%%%%%%
%% these are from one plot
%%
v1=DI(346,:);  %%gmk;
 v2=DI(323,:);  %%pyrG;
 v3=DI(76,:); %%purM;
 v4=DI(347,:); %%amn
 v5=DI(13,:);  %%cspD;
 v6=DI(37,:);  %%dps;
 v=DI(71,:); %%cbpA;
 v4=DI(131,:); %%wrbA
%%%%%%%%%%%%%%%%%%%
%% These are from a second plot
%% 
 
 %%%
  V=[v1' v2' v3' v4'];
  L=motion_seg_MIMO(V,1,0.5);
  display_seg(L,1);
  title('Dynamic Correlation Matrix')
  figure
  L2=matrix_reorder(L);
  display_seg(L2,1)
  title('Reordered dynamic correlation matrix')