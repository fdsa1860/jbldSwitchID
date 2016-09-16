close all
clear all
load ClusteredData_Figure3.mat
 DI=DIAUXIE_DATA_CLUST;
 ec=EcocycNameofCLUST;
 v1=DI(346,:);  %%gmk;
 v2=DI(323,:);  %%pyrG;
 v3=DI(76,:); %%purM;
 v4=DI(347,:); %%amn
%
%
disp('First trying Hankel Rank');
%
v=[v1;v2;v3;v4];
hr=HankelRankMIMO(v,0.05);
figure
 hold on
 plot(hr,'g*');
 mhr=max(hr);
 plot(mhr*v1,'b');
 plot(mhr*v2,'g');
 plot(mhr*v3,'r');
 plot(mhr*v4,'k');
 legend('segmentation','gmk','pyrG','purM','amn');
 title('Hankel Rank Based Segmentation');
 xlabel('epochs')
 ylabel('normalize')
 grid
 input('hit any key to continue')
disp('now trying hyperplane based segmentation')
 figure
 hold on
 plot(v1,'b');
 plot(v2,'g');
 plot(v3,'r');
 plot(v4,'k');
 legend('segmentation','gmk','pyrG','purM','amn');
 grid
title('Hyperplane-Based Segmentation');
 v=[v1;v2;v4];
 group=l1_switch_detect(v',inf,0.25);
 mg=max(group);
 hold on;
 plot(mg*v1,'b');
 plot(mg*v2,'g');
 plot(mg*v3,'r');
 plot(mg*v4,'k');
 grid;
 legend('segmentation','gmk','pyrG','purM','amn');
 title('Hyperplane Based Segmentation')
 %
 
 input('press any key to continue')
 plot(hr,'g*');
 input('press any key to continue');
 
 disp('now trying dynamic regressors, second order dynamics')
 %group = indep_dyn_switch_detect_offset(v',inf,0.02,2);
 group = indep_dyn_switch_detect_offset(v',inf,0.010,2);
 hold on
 plot(mg*v1,'b');
 plot(mg*v2,'g');
 plot(mg*v3,'r');
 plot(mg*v4,'k');
 grid;
 title('Dynamic Regressors Based Segmentation, second order dynamics')
 legend('segmentation','gmk','pyrG','purM','amn');
 input('press any key to continue');
 disp('now trying dynamic regressors with gmk only')
 group = indep_dyn_switch_detect_offset(v1',2,0.05,2);
 mg=max(group);
 hold on
 plot(mg*v1,'b');
 plot(mg*v2,'g');
 plot(mg*v3,'r');
 plot(mg*v4,'k');
 legend('segmentation','gmk','pyrG','purM','amn');
 grid;
 title('Dynamic Regressors Based Segmentation, using gmk only')