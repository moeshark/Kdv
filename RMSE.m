% calculates RMSE for non-linearity parameters
% input: non-linearity coefficients
function r = RMSE(XI)
    
    % FFT Parameters
    ModelParams.N = 64;  %size of time series data N
    ModelParams.P = 6*pi;  % periodicity length  =2L
    ModelParams.dt = .4/ModelParams.N^2; %% time step
    ModelParams.M = 80000 + 10000; % number of time steps to generate
    X = ModelParams.P/ModelParams.N*(-ModelParams.N/2:ModelParams.N/2-1)';
    init_cond = 7*sech(2*(X-2)).^2 + 3*sech((X+4)).^2 ;
    measured_vars = 1:1:ModelParams.N;
    
    % reservoir parameters
    resparams.radius = 6e-2; % spectral radius
    resparams.degree = 3; % connection degree
    approx_res_size = 2000; % reservoir size
    resparams.sigma = 0.01; % input weight scaling
    resparams.train_length = 80000; % number of points used to train
    resparams.predict_length = 10000; % number of predictions after training
    resparams.beta = 1e-4; %regularization parameter
    rmse_mat = zeros(length(XI),resparams.predict_length);% matrix of RMSE Vals

    % train the reservoir each time
    for n = 1:length(XI)
        ModelParams.xi = XI(n);
        data = kdv_solve(ModelParams,init_cond); 
        truedata = data(:,resparams.train_length+1:resparams.train_length + resparams.predict_length);
        measurements = data(measured_vars, :);
        [num_inputs,~] = size(measurements);
        resparams.num_inputs = num_inputs; 
        resparams.N = floor(approx_res_size/num_inputs)*num_inputs; % actual reservoir size divisible by number of inputs
        [x, wout, A, win] = train_reservoir(resparams, measurements(:, 1:resparams.train_length));
        [output,~] = predict(A,win,resparams,x,wout);

        error = (output - truedata).^2;
        rmse_mat(n,:) = sqrt(ModelParams.N^(-1)*sum(error,1));
    end

    r = rmse_mat;
