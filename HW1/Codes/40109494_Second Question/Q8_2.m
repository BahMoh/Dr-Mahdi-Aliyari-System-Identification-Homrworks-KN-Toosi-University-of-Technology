%---------------- RLS Algorithm --------------------%
clc
clear all
close all
format long
%% Load Data
load data
%% 
y_Low=data(:,3);
y_Medium=data(:,4);
y_High=data(:,5);
u=data(:,1);
%-------------- Data Generation --------------------%
g=0.01;   ro=1e8;
utr=u(1:750);  % training data
ut=u(751:end); % test data

theta1=-1.5*ones(750,1);                    %thata^0
theta2=-0.8*ones(750,1);                    %theta^1
theta3(:,1)=0.5+tansig(g*((1:750)-400))';   %theta^3  
theta4=-0.65*ones(750,1);                   %theta^5
theta5=2.25*ones(750,1);                    %theta^6
theta6=-1.7*ones(750,1);                    %theta^8
theta_true=[theta1 theta2 theta3 theta4 theta5 theta6]';

for t = 1:750
    Y(t) = theta1(t)*utr(t).^(0) + theta2(t)*utr(t).^(1) ...
           + theta3(t)*utr(t).^(3) + theta4(t)*utr(t).^(5)...
           +theta5(t)*utr(t).^(6) + theta6(t)*utr(t).^(8); 
end


for t = 1:250             % Using this for Model verification
    Ytrue(t) = theta1(t)*ut(t).^(0) + theta2(t)*ut(t).^(1) ...
           + theta3(t)*ut(t).^(3) + theta4(t)*ut(t).^(5)...
           +theta5(t)*ut(t).^(6) + theta6(t)*ut(t).^(8); 
end

P=ro*eye(6);              %Initial value for Covariance matrix
theta(:,1) =zeros(6,1);     %Initial value for parameters estimation

%---------------- RLS estimation --------------------%
for j = 2:750
    X = [utr(j).^(0); utr(j).^(1);utr(j).^(3); utr(j).^(5);utr(j).^(6); utr(j).^(8)];

    P=P-(P*X*X'*P)/(1+X'*P*X);
    theta(:,j) = theta(:,j-1) + P*X*(Y(j)-X'*theta(:,j-1))/(1+X'*P*X);
    NormP(j) = trace(P);
    
end

%--------------- Model Verification------------------%

Xver = [ut.^(0) ut.^(1) ut.^(3) ut.^(5) ut.^(6)  ut.^(8)];
Yver = Xver*theta(:,end);
err=Ytrue-Yver';

%----------------- Showing Results-------------------%
[theta_true theta(:,end)];

%-------------- Parameters Convergence---------------%
k=1 ;N=750; % starting point for plot
for i=1:min(size(theta))
figure(1)
subplot(2,3,i)
plot(k:N,theta(i,k:N),k:N,theta_true(i,k:N)','LineWidth',1.5)
legend(sprintf('Estimate %s_{%d} %s data','\theta',i),'Real \theta')
grid on
end
xlim([k N])
%---------- Covariance matrix Convergence-----------%
figure(4)
plot(NormP(100:end),'LineWidth',2.5);
grid on
legend('trace(P)')
title('Covariance matrix Convergence')
set(gcf,'Color',[1,1,1])
%--------------- Model Verification------------------%
figure(5)
subplot(2,1,1)
plot(Yver(1:100),'LineWidth',2.5);hold on
plot(Ytrue(1:100),'-.r','LineWidth',2.5)
title('Model Verification')
%axis([0 50 .5 4])
legend('y_e_s_t_i_m_a_t_e_d','y_t_r_u_e')
subplot(2,1,2)
plot(err(1:100),'LineWidth',2.5)
title('Error of estimation')
%axis([0 50 -1e-3 4e-3])
set(gcf,'Color',[1,1,1])