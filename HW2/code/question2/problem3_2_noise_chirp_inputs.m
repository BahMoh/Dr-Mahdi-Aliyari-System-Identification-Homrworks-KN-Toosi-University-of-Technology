clc
clear
close all
load('HW2_Q2');

Ts=0.5;
id_input=ones(2000,1);
[y_id,t_id]=unknown_sys(id_input,Ts);

figure(1)
plot(t_id,y_id);
hold on
plot(t_id,id_input,'r');
grid on
%% transfer functions
sys=tf(200,[200 1],'InputDelay',0);
%sys=tf(200,[200 1],'InputDelay',1);
%% inputs
% var=0.05;
% input=sqrt(var)*randn(2000,1);

load input_noise

%input=ones(2000,1);

% t=0:1:1999;
% input=chirp(t,0.01,2000,500)';
%load input_chirp

%%
Dis_sys=c2d(sys,Ts);
[y,t]=unknown_sys(input,Ts);
[y2,t2]=lsim(c2d(sys,Ts),input');

figure(2)
plot(t,y,'r',t2,y2,'b')
grid on

data1=iddata(y,t',Ts);
data2=iddata(y2,t2,Ts);

figure(3)
compare(data1,data2)
title('compare of real system and estimate system')
legend('real','estimate')
%%
%% train and test
%x=randperm(1000);
x=1:2000;
input=input(x);
y_id=y_id(x);

input1=input(1:1200);
input2=input(1201:2000);
ytrain=y(1:1200);
ytest=y(1201:2000);

data3=iddata(ytrain,input1,Ts);
data4=iddata(ytest,input2,Ts);
p1d=procest(data3,'P1D');
p1=procest(data3,'P1');

figure(4)
compare(data4,p1d)

figure(5)
compare(data4,p1)

% figure(6)
% compare(p1d,z1(601:1000))

