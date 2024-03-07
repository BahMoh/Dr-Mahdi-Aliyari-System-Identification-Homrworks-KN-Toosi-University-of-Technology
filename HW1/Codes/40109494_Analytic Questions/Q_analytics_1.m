clc
clear

theta3 = 0.1;
theta2 = 0.3;
theta1 = theta2 + theta3;

theta = [theta1, theta2, theta3];
% theta_hat = inv(X_trans*X)*X_trans*y
X1 = normrnd(0.5,1,100,1);
X2 = normrnd(0.5,1,100,1);
X3 = normrnd(0.5,1,100,1);
X = [X1, X2, X3];
y = theta1*X1 + theta2*X2 + theta3*X3 + 0.01*randn(100,1);

theta_hat = inv(X'*X)*X'*y

