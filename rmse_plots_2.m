%% plotting the RMSE curves (positive non-linearity)
xip = 3;
L = [2 3 3.25 3.5];
rmse_p2 = RMSE2(xip, L);
%%
figure();
resparams.predict_length = 10000;
t = (1:1:resparams.predict_length)*ModelParams.dt;
plot(t*1000,rmse_p2(1,:),'Linewidth',1.5);
hold on;
plot(t*1000,rmse_p2(2,:),'Linewidth',1.5);
hold on;
plot(t*1000,rmse_p2(3,:),'Linewidth',1.5);
hold on;
plot(t*1000,rmse_p2(4,:),'Linewidth',1.5);


leg2 = legend({'$L=2\pi$', '$L = 3\pi$', '$L = 3.25\pi $', '$L=3.5\pi$'},'Location','northwest','NumColumns',1);
set(leg2,'Interpreter','latex','fontsize',15);
legend('boxoff');
xlabel('time (ms)');
ylabel('RMSE');
xlim([0, resparams.predict_length*ModelParams.dt*1000])
title('RMSE Plot For Various periodicities ($\xi = 3$)','Interpreter','Latex');

%% plotting the RMSE Curves (negative non-linearity)
xin = -1;
rmse_n2 = RMSE2(xin,L);
%%
figure();
t = (1:1:resparams.predict_length)*ModelParams.dt;
plot(t*1000,rmse_n2(1,:),'Linewidth',1.5);
hold on;
plot(t*1000,rmse_n2(2,:),'Linewidth',1.5);
hold on;
plot(t*1000,rmse_n2(3,:),'Linewidth',1.5);
hold on;
plot(t*1000,rmse_n2(4,:),'Linewidth',1.5);


leg2 = legend({'$L=2\pi$', '$L = 3\pi$', '$L = 3.25\pi $', '$L=3.5\pi$'},'Location','northwest','NumColumns',1);
set(leg2,'Interpreter','latex','fontsize',15);
legend('boxoff');
xlabel('time (ms)');
ylabel('RMSE');
xlim([0, resparams.predict_length*ModelParams.dt*1000])
title('RMSE Plot For Various periodicities ($\xi =-3$)','Interpreter','Latex');
