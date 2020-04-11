% training the reservoir to predict the KdV equation
% Author: Mahmoud Sharkawi
%% setting parameters
clear;
ModelParams.N = 64;  %size of time series data N
ModelParams.P = 2*3*pi;  % periodicity length  =2L
ModelParams.dt = .4/ModelParams.N^2; %% time step
ModelParams.M = 80000 + 10000; % number of time steps to generate
ModelParams.xi = 3.00; % kdV coeff

% initial condition
X = ModelParams.P/ModelParams.N*(-ModelParams.N/2:ModelParams.N/2-1)';
init_cond = 7*sech(2*(X-2)).^2 + 3*sech((X+4)).^2 ;
data = kdv_solve(ModelParams,init_cond); 

measured_vars = 1:1:ModelParams.N;
num_measured = length(measured_vars);
measurements = data(measured_vars, :);

%% reservoir-specific parameters
%Reservoir parameters
[num_inputs,~] = size(measurements);
resparams.radius = 6e-3; % spectral radius
resparams.degree = 3; % connection degree
approx_res_size = 2000; % reservoir size
resparams.N = floor(approx_res_size/num_inputs)*num_inputs; % actual reservoir size divisible by number of inputs
resparams.sigma = 0.01; % input weight scaling
resparams.train_length = 80000; % number of points used to train
resparams.num_inputs = num_inputs; 
resparams.predict_length = 10000; % number of predictions after training
resparams.beta = 1e-5; %regularization parameter

% training the reservoir
[x, wout, A, win] = train_reservoir(resparams, measurements(:, 1:resparams.train_length));

% prediction phase
[output,~] = predict(A,win,resparams,x,wout);
%% prediction 1 (full)
figure()
t = (1:1:resparams.predict_length)*ModelParams.dt;
truedata = data(:,resparams.train_length+1:resparams.train_length + resparams.predict_length);

% true solution (integrated solution)
subplot(3,1,1)
imagesc(t*1000,X,truedata)
title('Actual')
xlabel('time elapsed (ms)')
xlim([0, resparams.predict_length*ModelParams.dt*1000])
colorbar;
caxis([-3,10])
colormap('jet');

% prediction
subplot(3,1,2)
imagesc(t*1000,X,output)
title('Prediction')
xlabel('time elapsed (ms)')
xlim([0, resparams.predict_length*ModelParams.dt*1000])
colorbar;
caxis([-3,10])
colormap('jet');

% error
subplot(3,1,3)
%error = 100*abs(1 - output./truedata);
error = abs(output - truedata);
imagesc(t*1000,X,error)
title('Absolute Error')
xlabel('time elapsed (ms)')
colorbar;
xlim([0, resparams.predict_length*ModelParams.dt*1000])
colormap('jet')

%% prediction 2 (zoomed-in)
% optional: uncomment for a zoomed-in plot of the above
%{
figure()
scale = 2/5;
t2 = (1:1:(2/5)*resparams.predict_length)*ModelParams.dt;
truedata2 = data(:,resparams.train_length+1:resparams.train_length + scale*resparams.predict_length);
output2 = output(:,1:(2/5)*resparams.predict_length);


% true solution (integrated solution)
subplot(3,1,1)
imagesc(t*1000,X,truedata2)
title('Actual')
xlabel('time elapsed (ms)')
xlim([0, scale*resparams.predict_length*ModelParams.dt*1000])
colorbar;
caxis([-3,10])
colormap('jet');

% prediction
subplot(3,1,2)
imagesc(t*1000,X,output2)
title('Prediction')
xlabel('time elapsed (ms)')
xlim([0, scale*resparams.predict_length*ModelParams.dt*1000])
colorbar;
caxis([-3,10])
colormap('jet');

% error
subplot(3,1,3)
%error = 100*abs(1 - output./truedata);
error2 = abs(output2 - truedata2);
imagesc(t*1000,X,error)
title('Absolute Error')
xlabel('time elapsed (ms)')
colorbar;
xlim([0, scale*resparams.predict_length*ModelParams.dt*1000])
colormap('jet')
%}