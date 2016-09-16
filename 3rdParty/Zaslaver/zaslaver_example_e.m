close all
clear all
load ClusteredData_Figure3.mat
 DI=DIAUXIE_DATA_CLUST;
 ec=EcocycNameofCLUST;
 v1=DI(78,:);  %%rpsP;
 v2=DI(329,:);  %%rpsM;
 v3=DI(58,:); %%rplN;
 v4=DI(59,:); %%rplY
%
%
disp('First trying Hankel Rank');
%
v=[v1;v2;v3;v4];
hr=HankelRankMIMO(v,0.18);
figure
 hold on
 plot(hr,'g*');
 mhr=max(hr);
 plot(mhr*v1,'b');
 plot(mhr*v2,'g');
 plot(mhr*v3,'r');
 plot(mhr*v4,'c');
 legend('segmentation','rpsP','rpsM','rplN','rplY');
 title('Hankel Rank Based Segmentation');
 grid
 input('hit any key to continue')
disp('now trying hyperplane based segmentation')
 group=l1_switch_detect(v',inf,0.16);
 mg=max(group);
 hold on;
 plot(mg*v1,'b');
 plot(mg*v2,'g');
 plot(mg*v3,'r');
 plot(mg*v4,'c');
 grid;
 legend('segmentation','rpsP','rpsM','rplN','rplY');
 %
 title('Hyperplane-Based Segmentation');
 input('press any key to continue');
 plot(hr,'g*');
 input('press any key to continue');
 title('Hyperplane-Based Segmentation');
 disp('now trying dynamic regressors, second order dynamics')
 group = indep_dyn_switch_detect_offset(v',inf,0.025,2);
 hold on
 mg=max(group);
 plot(mg*v1,'b');
 plot(mg*v2,'g');
 plot(mg*v3,'r');
 plot(mg*v4,'c');
 grid;
 title('Dynamic Regressors Based Segmentation, second order dynamics')
 input('press any key to continue');
 disp('now trying dynamic regressors with rpsP only')
 group = indep_dyn_switch_detect_offset(v1',2,0.05,2);
 mg=max(group);
 hold on
 plot(mg*v1,'b');
 plot(mg*v2,'g');
 plot(mg*v3,'r');
 plot(mg*v4,'c');
 legend('segmentation','rpsP','rpsM','rplN','rplY');
 title('Dynamic Regressors Based Segmentation, rpsP alone')
 grid;