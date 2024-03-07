close all;clear all;clc
format long
%% Load Data
load data
%% 
y_Low=data(:,3);
y_Medium=data(:,4);
y_High=data(:,5);
u_Low=data(:,1);
u_Medium=data(:,1);
u_High=data(:,1);
% [-1.5, -0.8, 0, 0.01, 0, -0.65, 2.25, 0, -1.7]
theta_real=[-1.5, -0.8, 0, 0.01, 0, -0.65, 2.25, 0, -1.7]'*ones(1,1000);
%% Switch data
Switch={'Low';'Medium';'High'};
for K=1:length(Switch)
%% import 'Low' 'Medium' 'High'
u=sort((eval(strcat('u_',Switch{K}))));
y=sort((eval(strcat('y_',Switch{K}))));
data=sortrows(data);
Num=randperm(1000);
    u=u(Num);
    y=y(Num);
    %%
    Percent=0.75;  %  =>   75%  
    Reg=8;  % => [1 u u^2 ... u^8]
    %% Train 
    u_Train=u;
    y_Train=y;
    %% RLS parameter
    Y= y_Train;
    U=[];
    for k=0:Reg
        U=[U u_Train.^k];
    end
    theta0=zeros(size(U,2),1);
    lambda=1;
    power=11;
    epsilon=0.1;
   %% RLS Algorithm 
 [Y_hat,theta_save,P_save,Trace,Norm] = RLS(Y,U,theta0,[],lambda,power,epsilon);
%% plot the result 
figure(1)
plot(Y-Y_hat,'linewidth',2)
disp(sprintf('Error %s=%d',Switch{K},(Y-Y_hat)'*(Y-Y_hat)));
title(sprintf('Error for %s data',Switch{K}))
grid on
pause
figure(2)
plot(Y)
hold on
plot(Y_hat,':r')
legend('Y_{real}','Y_{Estimate by \theta}')
title(sprintf('Estimate  for %s data',Switch{K}))
grid on
pause
for i=1:length(theta0)
figure(3)
subplot(5,2,i)
plot(theta_save(:,i),'m','Linewidth',2),hold on,
plot(theta_real(i,:),'b','Linewidth',2)
legend(sprintf('Estimate %s_{%d} %s data','\theta',i,Switch{K}),'Real \theta')
grid on
end
pause
figure(4)
plot(Trace,'k','Linewidth',2)
title(sprintf('Trace(Covariance matrix) for %s data',Switch{K}))
grid on
pause
figure(5)
plot(Norm,'r','Linewidth',2)
title(sprintf('||Covariance matrix||_2 for %s data',Switch{K}))
grid on
pause
end