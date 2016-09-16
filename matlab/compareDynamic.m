function compareDynamic(M1, M2)

figure;
% subplot(311);
plot(svd(M1/norm(M1,'fro')),'*');
hold on;
% subplot(312);
plot(svd(M2/norm(M2,'fro')),'*');
% subplot(313);
plot(svd([M1 M2]/norm([M1 M2],'fro')),'*');
hold off;
legend('Matrix 1', 'Matrix 2', 'Combined Matrix');

end