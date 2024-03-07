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

% Num=randperm(1000);
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
for i=1:n
    %% 
    ud{i}=u((i-1)*Q+1:(i*Q));
    yd{i}=y((i-1)*Q+1:(i*Q));
    %% Test & Train
    u_Train{i}=ud{i}(1:ceil(Percent*length(ud{i})));
    u_Test{i}=ud{i}(ceil(Percent*length(ud{i}))+1:end);
    y_Train{i}=yd{i}(1:ceil(Percent*length(yd{i})));
    y_Test{i}=yd{i}(ceil(Percent*length(yd{i}))+1:end);
    U=[];
    for k=0:Reg
        U=[U (u_Train{i}).^k];
    end
    Y=y_Train{i};
    %% LS Algorithm 
    theta_save{i}=U\Y;
    %% 
    U_Test_all=[U_Test_all (u_Test{i})];
    U_Test_m=[U_Test_m;(u_Test{i})];
    temp=[temp;(y_Test{i})];
end
Y=temp;
theta=mean(cell2mat(theta_save),2)
Y_hat=[];
for i=1:n
%% matrix U for local u_Test 
U=[];
    for k=0:Reg
        U=[U U_Test_all(:,i).^k];
    end
            Y_hat=[Y_hat;U*theta_save{i}];
            Y_hat_save{i}=U*theta_save{i};
end
%% matrix U for all u_Test 
U_m=[];
    for k=0:Reg
        U_m=[U_m U_Test_m.^k];
    end
    Y_hat_m=U_m*theta;
%% plot the result 
%% Local theta
figure
plot(Y-Y_hat,'linewidth',2)
disp(sprintf('Error_local theta %s=%d',Switch{K},(Y-Y_hat)'*(Y-Y_hat)));
title(sprintf('Error by local %s in Q=%d for %s  data',' \theta',Q,Switch{K}))
grid on
figure
crosscorr(Y-Y_hat,Y-Y_hat)
title(sprintf('Cross correlation Error by local %s for %s data',' \theta',Switch{K}))
grid on
figure
plot(Y)
hold on
plot(Y_hat,':r')
legend('Y_{real}','Y_{Estimate in Lacal}')
title(sprintf('Estimate by local %s for %s  data', '\theta',Switch{K}))
grid on

%% Mean theta
figure
plot(Y-Y_hat_m,'linewidth',2)
title(sprintf('Error by mean %s for %s data',' \theta',Switch{K}))
grid on
figure
crosscorr(Y-Y_hat_m,Y-Y_hat_m)
title(sprintf('Cross correlation Error by mean %s for %s data',' \theta',Switch{K}))
grid on
disp(sprintf('Error_mean theta %s=%d',Switch{K},(Y-Y_hat_m)'*(Y-Y_hat_m)));
figure
plot(Y)
hold on
plot(Y_hat_m,':r')
legend('Y_{real}','Y_{Estimate by mean \theta}')
title(sprintf('Estimate by mean %s for %s data',' \theta',Switch{K}))
grid on
%%
%%  Data fo plot Error bar
    Y_hat=[];
    UU=sort(U_Test_all,1);   % for plot E.B. we need to sort the data
for i=1:n
%% matrix U for local u_Test 
U=[];
    for k=0:Reg
        U=[U UU(:,i).^k];
    end
            Y_hat_save_EB{i}=U*theta_save{i};
end
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
legend('y-hat_{mean}','y-hat_{mean}+\sigma_y','y-hat_{mean}-\sigma_y','Location','SouthEast')
end