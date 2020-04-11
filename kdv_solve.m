%         Solve KdV eq. u_t + 2h*uu_x + u_xxx = 0 on [-L,L] by
%         FFT with integrating factor v = exp(-ik^3t)*u-hat. Code has been 
%         adapted from https://people.maths.ox.ac.uk/trefethen/spectral.html
%         p27.m and modified extensively to fit the KdV project

function uu = kdv_solve(ModelParams, init)

    N = ModelParams.N; % size of time series data Q
    P = ModelParams.P; % periodicity length = 2L
    dt = ModelParams.dt; % time step
    M = ModelParams.M; % number of time steps to generate
    xi = ModelParams.xi; % kdV coefficient

    v = fft(init); 
    
    % RK4 Parameter setup
    dk = (2*pi)/P; % frequency increment
    %k = [0:N/2-1 0 -N/2+1:-1]'; 
    k = [0:dk:N*dk/2 dk*(-N/2 +1):dk:-dk]';% points in the k-plane 
    ik3 = 1i*k.^3;
    G = -xi*1i*k*dt;
   
    % initialising fft-matrix
    vv = zeros(N, M);
    vv(:,1) = v;
  
  for j = 1:M
    % integrating factors
    E = exp(dt*ik3/2); 
    E2 = E.^2; 
    
    a = G.*fft(real( ifft(     v    ) ).^2);
    b = G.*fft(real( ifft(E.*(v+a/2)) ).^2);     % 4th-order
    c = G.*fft(real( ifft(E.*v + b/2) ).^2);     % Runge-Kutta
    d = G.*fft(real( ifft(E2.*v+E.*c) ).^2);
    
    v1 = E2.*v; % linear solution
    v =  v1 +(E2.*a + 2*E.*(b+c) + d)/6;
    vv(:,j) =v;
  end
  
  uu = real(ifft(vv));
  
