close all
clear all
T1=1;
T2=97;
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

%%%%%%%%%%%%%%%
%% Plot h genes: stationary, non growth

 v5=DI(13,T1:T2);  %%cspD;
 v6=DI(37,T1:T2);  %%dps;
 v7=DI(71,T1:T2); %%cbpA;
 v8=DI(131,T1:T2); %%wrbA


 %%%%%%%%%%%%%%%%%%%
%% These are from a second plot
%% 
 
 %%%
  V=[v1' v2' v3' v4' v5' v6' v7' v8'];
  Ld=motion_seg_MIMO_pairs_diff_nonormal(V,1,0.2);
  display_seg(Ld,1);
  title('Dynamic Correlation Matrix using differences')
  figure
  [Ld2 ixd]=matrix_reorder(Ld);
  display_seg(Ld2,1)
  title('Reordered dynamic correlation matrix using differences')
  Lpos=motion_seg_MIMO_pairs_sbs(V,1,0.1);
  figure
   display_seg(Lpos,1);
  title('Dynamic Correlation Matrix using positions')
  figure
  [Lp2 ixp]=matrix_reorder(Lpos);
  display_seg(Lp2,1)
  title('Reordered dynamic correlation matrix using positions')