% Generate input signal (example: random input)
Ts = 0.1;  % Sampling time
t = 0:Ts:10;  % Time vector
u = randn(size(t));  % Example: random input signal

% Define a system with a known impulse response (example)
sys_true = tf([1 0.5], [1 -0.8 0.2], Ts);  % Example: a second-order system

% Generate output signal using the true system
y_true = lsim(sys_true, u, t);

% Add white noise to the output signal
noise_std = 0.1;
y_noisy = y_true + noise_std * randn(size(t));

% Ensure that u and y_noisy have the same number of rows
min_length = min(length(u), length(y_noisy));
u = u(1:min_length);
y_noisy = y_noisy(1:min_length);

% Create iddata object for system identification
data = iddata(y_noisy, u, Ts);

% Use impulseest to estimate an impulse response model
na = 2;  % Number of poles in the model
nb = 2;  % Number of zeros in the model
nk = 1;  % Delay in the model
sys_est = impulseest(data, [na, nb, nk]);

% Compare true and estimated impulse responses
figure;
impulse(sys_true, '-', t);
hold on;
impulse(sys_est, '--', t);
legend('True System', 'Estimated System');
title('True and Estimated Impulse Responses');
