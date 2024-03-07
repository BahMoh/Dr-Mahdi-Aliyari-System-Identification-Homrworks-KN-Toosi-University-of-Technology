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
%% Divide Data
Q=100;
n=10;
Percent=0.75;  %  =>   75%    =>  Train:=75  Test:=25
Reg=8;  % => [1 u u^2 ... u^8]
U_Test_all=[];
U_Test_m=[];
temp=[];
    %% Test & Train
    u_Train=u(1:ceil(Percent*length(u)));
    u_Test=u(ceil(Percent*length(u))+1:end);
    y_Train=y(1:ceil(Percent*length(u)));
    y_Test=y(ceil(Percent*length(u))+1:end);
    %% WLS with sliding window parameter
    Window=300;
    lambda=0.95;
   for i=1:Window
       w(i)=lambda^(Window-i);
   end
   W=diag(w);
   %%
    for i=1:length(u_Train)-Window
     U=[];
        for k=0:Reg
    U=[U (u_Train(i:i+Window-1)).^k];
    end
   Y=y_Train(i:i+Window-1);
    
    %% WLS Algorithm 
    theta_save{i}=inv(U'*W*U)*U'*W*Y;
    %% 
    end
% Y=temp;
theta=mean(cell2mat(theta_save),2)
%% matrix U for all u_Test 
U=[];
    for k=0:Reg
        U=[U u_Test.^k];
    end
    Y_hat=U*theta;
    Y=y_Test;
%% plot the result 
%% Mean theta
figure
plot(Y-Y_hat,'linewidth',2)
disp(sprintf('Error_mean theta %s=%d',Switch{K},(Y-Y_hat)'*(Y-Y_hat)));
title(sprintf('Error by mean %s for %s data','\theta',Switch{K}))
grid on
figure
plot(Y)
hold on
plot(Y_hat,':r')
legend('Y_{real}','Y_{Estimate by mean \theta}')
title(sprintf('Estimate by mean %s for %s data','\theta',Switch{K}))
grid on
%%
     temp=sort(u_Test);
     U=[];
      for k=0:Reg
    U=[U temp.^k];
    end
    for i=1:length(u_Train)-Window
         Y_hat_save_EB{i}=U*theta_save{i};
    end
%%  Data fo plot Error bar
UU=sort(u_Test,1);   % for plot E.B. we need to sort the data
Mean=mean(cell2mat(Y_hat_save_EB),2);   % mean Local Y_hat
Delta = std(cell2mat(Y_hat_save_EB),0,2);   %  +- sigma
%% Normal the data 
 x=mean(mapminmax(UU',0,1),1);
 %% plot
figure
plot(x,Mean,'r','linewidth',1.5)
hold on
plot(x,Mean+Delta,':k','linewidth',1.5)
hold on
plot(x,Mean-Delta,':b','linewidth',1.5)
grid on
title(sprintf('Error Bar : choice %s data from [0 1]',Switch{K}))
legend('y-hat_{mean}','y-hat_{mean}+\sigma_y','y-hat_{mean}-\sigma_y','Location','NorthWest')
end