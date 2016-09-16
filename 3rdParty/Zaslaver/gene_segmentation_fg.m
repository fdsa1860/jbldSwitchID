close all
clear all
T1=1;
T2=50;
load ClusteredData_Figure3.mat
 DI=DIAUXIE_DATA_CLUST;
 ec=EcocycNameofCLUST;
%%%%%%%%%
%% these are from one plot
%%
v1=DI(346,T1:T2);  %%gmk;
 v2=DI(323,T1:T2);  %%pyrG;
 v3=DI(76,T1:T2); %%purM;
 v4=DI(347,T1:T2); %%amn
 v5=DI(13,T1:T2);  %%cspD;
 v6=DI(37,T1:T2);  %%dps;
 v7=DI(71,T1:T2); %%cbpA;
 v8=DI(131,T1:T2); %%wrbA
%%%%%%%%%%%%%%%%%%%
%% These are from a second plot
%% 
 
 %%%
  V=[v1' v2' v3' v4'];
  %[v5' v6' v7' v8'];
  L=motion_seg_MIMO_pairs_diff(V,1,0.3);
  display_seg(L,1);
  title('Dynamic Correlation Matrix using difference')
  figure
  [L2 ix]=matrix_reorder(L);
  display_seg(L2,1)
  title('Reordered dynamic correlation matrix')