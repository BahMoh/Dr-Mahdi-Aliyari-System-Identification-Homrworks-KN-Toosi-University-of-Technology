% Generate input signal (example: random input)
Ts = 0.1;  % Sampling time
t = 0:Ts:10;  % Time vector
u = randn(size(t));  % Example: random input signal

% Define a system with a known frequency response (example)
sys_true = tf([1 0.5], [1 -0.8 0.2], Ts);  % Example: a second-order system

% Generate output signal using the true system
y_true = lsim(sys_true, u, t);
y_true = y_true';
% Add white noise to the output signal
noise_std = 0.1;
y_noisy = y_true + noise_std * randn(size(t));

% Create iddata object for system identification
data = iddata(y_noisy, u, Ts);

% Use spa to estimate the frequency response
% Choose appropriate options for your specific case
opts = spaOptions('FrequencyVector', logspace(-2, 2, 100), 'SID', 'periodogram');
sys_est = spa(data, opts);

% Plot the true and estimated frequency responses
bode(sys_true, '-r', sys_est, '--b');
legend('True System', 'Estimated System');
title('True and Estimated Frequency Responses');
