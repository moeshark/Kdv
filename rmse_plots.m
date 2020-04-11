%% plotting the RMSE curves (positive non-linearity)
XI = (2.5:0.25:3.5);
rmse_p = RMSE(XI);
%%
figure();
resparams.predict_length = 10000;
t = (1:1:resparams.predict_length)*ModelParams.dt;
plot(t*1000,rmse_p(1,:),'Linewidth',1.5);
hold on;
plot(t*1000,rmse_p(2,:),'Linewidth',1.5);
hold on;
plot(t*1000,rmse_p(3,:),'Linewidth',1.5);
hold on;
plot(t*1000,rmse_p(4,:),'Linewidth',1.5);
hold on;
plot(t*1000,rmse_p(5,:),'Linewidth',1.5);

leg2 = legend({'$\xi = 2.50$', '$\xi = 2.75$', '$\xi = 3.00 $', '$\xi=3.25$','$\xi=3.50$'},'Location','northwest','NumColumns',2);
set(leg2,'Interpreter','latex','fontsize',15);
legend('boxoff');
xlabel('time (ms)');
ylabel('RMSE');
xlim([0, resparams.predict_length*ModelParams.dt*1000])
title('RMSE Plot For Various $\xi >0$ values','Interpreter','Latex');

%% plotting the RMSE Curves (negative non-linearity)

XI = -(2.5:0.25:3.5);
rmse_n = RMSE(XI);
%%
figure();
resparams.predict_length = 10000;
t = (1:1:resparams.predict_length)*ModelParams.dt;
plot(t*1000,rmse_n(1,:),'Linewidth',1.5);
hold on;
plot(t*1000,rmse_n(2,:),'Linewidth',1.5);
hold on;
plot(t*1000,rmse_n(3,:),'Linewidth',1.5);
hold on;
plot(t*1000,rmse_n(4,:),'Linewidth',1.5);
hold on;
plot(t*1000,rmse_n(5,:),'Linewidth',1.5);


leg2 = legend({'$\xi = -2.50$', '$\xi = -2.75$', '$\xi = -3.00 $', '$\xi= -3.25$','$\xi= -3.50$'},'Location','northwest','NumColumns',2);
set(leg2,'Interpreter','latex','fontsize',15);
legend('boxoff');
xlabel('time (ms)');
ylabel('RMSE');
xlim([0, resparams.predict_length*ModelParams.dt*1000])
title('RMSE Plot For Various $\xi < 0$ values','Interpreter','Latex');

