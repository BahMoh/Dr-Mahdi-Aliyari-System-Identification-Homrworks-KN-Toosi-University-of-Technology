close all;clear all;clc
format long
warning off
%% Load Data
load data
%% 
y_Low=data(:,3);
y_Medium=data(:,4);
y_High=data(:,5);
u_Low=data(:,1);
u_Medium=data(:,1);
u_High=data(:,1);
data=sortrows(data);
Num=randperm(1000);

%% Switch data
Switch={'Low';'Medium';'High'};
for K=1:length(Switch)
%% import 'Low' 'Medium' 'High'
u=sort((eval(strcat('u_',Switch{K}))));
y=sort((eval(strcat('y_',Switch{K}))));

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
   %% Ridge Regresion Algorithm 
   for i=1:1001
   alpha=(i-1)*0.001;
   theta_save(:,i)=inv((U'*U+alpha*eye(size(U,2))))*U'*Y;
%    b(:,i)=ridge(Y,U,alpha);
   end
% b=ridge(Y,U,alpha);
b= theta_save';
alpha=0:0.001:1;
%% matrix U for all u_Test 
%% plot the result 
figure
plot(alpha,b,'LineWidth',2)
ylim([-5 5])
title(sprintf('Ridge Regresion for %s data',Switch{K}))
legend('\theta_0','\theta_1','\theta_2','\theta_3','\theta_4','\theta_5','\theta_6','\theta_7','\theta_8','\theta_9')
grid on
end