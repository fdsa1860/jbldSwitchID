close all
clear all
load ClusteredData_Figure3.mat
 DI=DIAUXIE_DATA_CLUST;
 ec=EcocycNameofCLUST;
  load diaux_der.mat;
DI=x;
 
 v1=DI(625,:);  %%cspD;
 v2=DI(930,:);  %%dps;
 v3=DI(951,:); %%cbpA;
 v4=DI(636,:); %%wrbA
%
%
disp('First trying Hankel Rank');
%
v=[v1;v2;v3;v4];
vm=max(max(v));
hr=HankelRankMIMO(v,0.11);
figure
 hold on
 mhr=max(hr);
 plot(mhr*v1,'b');
 plot(mhr*v2,'g');
 plot(mhr*v3,'r');
 plot(mhr*v4,'c');
 legend('cspD','dps','cbpA','wrbA');
 plot(hr,'g*');
 grid
 title('Hankel Rank Based Segmentation');
 input('hit any key to continue')
disp('now trying hyperplane based segmentation')
 figure
 hold on
 plot(v1,'b');
 plot(v2,'g');
 plot(v3,'r');
 plot(v4,'c');
  legend('cspD','dps','cbpA','wrbA');
 grid
 
 %v=[v1;v2];
 group=l1_switch_detect(v',inf,0.1);
 mg=max(group);
 hold on;
 plot(mg*v1,'b');
 plot(mg*v2,'g');
 plot(mg*v3,'r');
 plot(mg*v4,'c');
 grid;
  title('hyperplane-based segmentation')
  legend('segmentation','cspD','dps','cbpA','wrbA');
 %
 input('press any key to continue')
 plot(hr,'g*');
 title('hyperplane-based segmentation')
 %
 input('press any key to continue');
 
 disp('now trying dynamic regressors');
 group = indep_dyn_switch_detect_offset(v',inf,0.02,2);
 hold on
 plot(mg*v1,'b');
 plot(mg*v2,'g');
 plot(mg*v3,'r');
 plot(mg*v4,'c');
 grid;
  legend('segmentation','cspD','dps','cbpA','wrbA');
  title('Dynamic segmentation, second order dynamics');
 input('press any key to continue');
 disp('now trying dynamic regressors with cspD only')
% group = indep_dyn_switch_detect_offset(v1',2,0.05,2);
 group = indep_dyn_switch_detect_offset(v1',2,0.10,1);
 mg=max(group);
 hold on
 plot(mg*v1,'b');
 plot(mg*v2,'g');
 plot(mg*v3,'r');
 plot(mg*v4,'c');
 legend('segmentation','cspD','dps','cbpA','wrbA');
 title('Dynamic segmentation using cspD data only') 
 grid;