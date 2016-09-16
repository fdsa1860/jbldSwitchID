close all
clear all
load ClusteredData_Figure3.mat
 DI=DIAUXIE_DATA_CLUST;
 ec=EcocycNameofCLUST;
 v1=DI(897,:);  %%lacZ;
 v2=DI(898,:);  %%galE;
 v3=DI(760,:); %%galS;
 figure
 hold on
 plot(v1,'b');
 plot(v2,'g');
 plot(v3,'r');
 legend('lacZ','galE','galS');
 grid
 v=[v1;v2;v3];
 group=l1_switch_detect(v',inf,0.16);
 hold on;
 plot(v1,'b');
 plot(v2,'g');
 plot(v3,'r');
 legend('lacZ','galE','galS');