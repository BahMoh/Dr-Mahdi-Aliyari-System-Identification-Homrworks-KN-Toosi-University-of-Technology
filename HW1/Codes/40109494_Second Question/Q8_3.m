%% Recursive Least Square with exponential forgetting factor, for fast
%% change in parameters of system


clc, clear all, close all
format long
%% Load Data
load data
%% 
y_Low=data(:,3);
y_Medium=data(:,4);
y_High=data(:,5);
u=data(:,1);
N = 750;       ro = 1e8;     g=1;     landa = 0.3;       
% % **************** Input Signal ******************
% % ************************************************
utr=u(1:750);  % training data
ut=u(751:end); % test data

% % ******************** System Definition ************************
theta1=-1.5*ones(750,1);                    %thata^0
theta2=-0.8*ones(750,1);                    %theta^1
theta3(:,1)=0.5+tansig(g*((1:750)-400))';   %theta^3  
theta4=-0.65*ones(750,1);                   %theta^5
theta5=2.25*ones(750,1);                    %theta^6
theta6=-1.7*ones(750,1);                    %theta^8
theta_true=[theta1 theta2 theta3 theta4 theta5 theta6]';

for t = 1:750
    y(t) = theta1(t)*utr(t).^(0) + theta2(t)*utr(t).^(1) ...
           + theta3(t)*utr(t).^(3) + theta4(t)*utr(t).^(5)...
           +theta5(t)*utr(t).^(6) + theta6(t)*utr(t).^(8); 
end
y= y';

for t = 1:250             % Using this for Model verification
    ytrue(t) = theta1(t)*ut(t).^(0) + theta2(t)*ut(t).^(1) ...
           + theta3(t)*ut(t).^(3) + theta4(t)*ut(t).^(5)...
           +theta5(t)*ut(t).^(6) + theta6(t)*ut(t).^(8); 
    theta_true(:,t) = [theta1(t) theta2(t) theta3(t) theta4(t) theta5(t) theta6(t)]';
end
y= y';

P=ro*eye(6,6);
K=zeros(6,N);
theta=zeros(6,N+1);
for i=1:N
%    landa = 1-.99*exp(-mod(i,100)/20);    % exponential forgetting factor
    X = [utr(i).^(0); utr(i).^(1);utr(i).^(3); utr(i).^(5);utr(i).^(6); utr(i).^(8)];
    P=P/landa-(P*X*X'*P)/(landa*(landa+X'*P*X));
    theta(:,i+1) = theta(:,i) + P*X*(y(i)-X'*theta(:,i));
    NormP(i) = trace(P);
end

%----------------- Showing Results-------------------%
[theta_true theta(:,end)];

%-------------- Parameters Convergence---------------%
k=5 ;N=750; % starting point for plot
for i=1:min(size(theta))
figure(1)
subplot(2,3,i)
plot(k:N,theta(i,k:N),k:N,theta_true(i,k:N)','-.','LineWidth',2)
legend(sprintf('Estimate %s_{%d} %s data','\theta',i),'Real \theta')
grid on
end
xlim([k N])
%---------- Covariance matrix Convergence-----------%
figure(2)
plot(NormP(10:end),'LineWidth',2.5);
grid on
legend('trace(P)')
title('Covariance matrix Convergence')
set(gcf,'Color',[1,1,1])