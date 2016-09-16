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
 v1=DI(897,:);  %%lacZ;
 v2=DI(898,:);  %%galE;
 v3=DI(760,:); %%galS;
 v4=DI(625,T1:T2);  %%cspD;
 v5=DI(636,T1:T2);  %%wrba
% v6=DI(630,T1:T2); %% sohB
 v6=DI(930,T1:T2); %%dps;
 v7=DI(951,T1:T2); %%cbpA
 
 %v1=DI(346,T1:T2);  %%gmk;
 %v2=DI(323,T1:T2);  %%pyrG;
 %v3=DI(76,T1:T2); %%purM;
 %v4=DI(347,T1:T2); %%amn
 %v5=DI(13,T1:T2);  %ilvL;
 %v6=DI(37,T1:T2);  %%dps;
 %v7=DI(71,T1:T2); %%cbpA;
 %v8=DI(131,T1:T2); %%wrbA
 % v1=DI(346,:);  %%gmk;
 %v2=DI(323,:);  %%pyrG;
 %v3=DI(76,:); %%purM;
 %v4=DI(347,:); %%amn
%%%%%%%%%%%%%%%%%%%
%% These are from a second plot
%% 
 %v5=DI(897,:);  %%lacZ;
 %v6=DI(898,:);  %%galE;
 %v7=DI(760,:); %%galS;
%%%%%%%%%%%%%%%%%%%
%% These are from a second plot
%% 
 
 %%%
  V=[v1' v2' v3' v4' v5' v6' v7'];
  L=motion_seg_maxorder_diff(V(1:97,:),1,0.02,8,15);
  display_seg(L,1);
  title('Dynamic Correlation Matrix')
  figure
  [L2 ix2]=matrix_reorder(L);
  [L3 ix3]=matrix_reorder(L2);
  for i=1:1:size(ix3,2)
      ix3(i)=ix2(ix3(i));
  end
  display_seg(L3,1)
  title('Reordered dynamic correlation matrix')