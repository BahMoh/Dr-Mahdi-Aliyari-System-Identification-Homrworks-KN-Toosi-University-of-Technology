%% detrend command
% Generate input signal (example: linearly increasing trend)
Ts = 0.1;  % Sampling time
t = 0:Ts:10;  % Time vector
u_trend = 0.5 * t;  % Example: linearly increasing trend

% Combine the trend with the white noise input
u_with_trend = u + u_trend;

% Apply detrend to remove the linear trend
u_detrended = detrend(u_with_trend);

% Plot the original input and the detrended input
figure;
subplot(2, 1, 1);
plot(t, u_with_trend, 'b');
title('Original Input with Linear Trend');
xlabel('Time');
ylabel('Input');

subplot(2, 1, 2);
plot(t, u_detrended, 'r');
title('Detrended Input');
xlabel('Time');
ylabel('Detrended Input');


