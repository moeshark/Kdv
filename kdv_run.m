% script to generate some plots of the integration scheme

ModelParams.N = 128;
ModelParams.P = 6*pi;
ModelParams.dt = .4/128^2;
ModelParams.M = 2*10^5;
ModelParams.xi = 3;

N = ModelParams.N; % size of time series data Q
P = ModelParams.P; % periodicity length
dt = ModelParams.dt; % time step
M = ModelParams.M; 
h = ModelParams.xi;

t= dt*(1:1:M); %time
x = P/N*(-N/2:N/2-1)'; 
u = 6*sech(2*(x-2)).^2 + 2*sech((x+2)).^2 ;
uu = kdv_solve(ModelParams,u);

%plot of initial condition
f0 = figure();
plot(x,u)
ylim([0,6.5])
title('Plot of initial condition');
xlabel('$$-3\pi < x < +3\pi$$', 'Interpreter', 'Latex')
ylabel('u')

% heat map of soliton solutions
f1 = figure();
imagesc(t,x,uu)
colorbar;
colormap(f1,'jet')
title('Heat map of travelling Rogue Waves')
xlabel('time elapsed (s)')
ylabel('$$-3\pi < x < +3\pi$$', 'Interpreter', 'Latex')


% surface plot of soliton solutions
f2 = figure();
[TT,XX] = meshgrid(t,x);
Z = surf(TT,XX,uu);
xlabel('time (s) ');
ylabel('Space');
zlabel('elevation');
title('travelling patterns of the rogue waves')
set(Z,'LineStyle','none')

