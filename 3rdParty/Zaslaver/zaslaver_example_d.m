close all
clear all
%load ClusteredData_Figure3.mat
 %DI=DIAUXIE_DATA_CLUST;
 %ec=EcocycNameofCLUST;
 load diaux_der.mat
 DI=x;
 v1=DI(897,:);  %%lacZ;
 v2=DI(898,:);  %%galE;
 v3=DI(760,:); %%galS;
%
%
v=[v1' v2' v3'];
v=v/max(v);
disp('First trying Hankel Rank on lacZ only');
%
hr=HankelRankMIMO(v,0.18);
figure
 hold on
 plot(hr,'g*');
 mhr=max(hr);
 plot(mhr*v1,'b');
 plot(mhr*v2,'g');
 plot(mhr*v3,'r');
 legend('lacZ','galE','galS');
 grid
 input('hit any key to continue')
disp('now trying hyperplane based segmentation')
 figure
 hold on
 plot(v1,'b');
 plot(v2,'g');
 plot(v3,'r');
 legend('lacZ','galE','galS');
 grid
 v=[v1;v2;v3];
 group=l1_switch_detect(v',inf,0.16);
 mg=max(group);
 hold on;
 plot(mg*v1,'b');
 plot(mg*v2,'g');
 plot(mg*v3,'r');
 grid;
 legend('lacZ','galE','galS');
 %
 input('hit any key to continue');
 plot(hr,'g*');
 input('hit any key to continue');
 
 disp('now trying dynamic regressors, first order dynamics');
 group = indep_dyn_switch_detect_offset(v',inf,0.03,2);
 mg=max(group);
 hold on
 plot(mg*v1,'b');
 plot(mg*v2,'g');
 plot(mg*v3,'r');
 grid;
  legend('lacZ','galE','galS');
  grid;
 input('press any key to continue');
 disp('now trying dynamic regressors with lacZ only')
 group = indep_dyn_switch_detect_offset(v1',2,0.325,1);
 mg=max(group);
 hold on
 plot(mg*v1,'b');
 plot(mg*v2,'g');
 plot(mg*v3,'r');
 legend('lacZ','galE','galS');
  
 grid;