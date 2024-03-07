clc
clear
close all

Ts=0.5;
id_input=ones(2000,1);
[y_id,t_id]=unknown_sys(id_input,Ts);
figure(1)
plot(t_id,y_id);
%hold on
%plot(t_id,id_input,'r');
title('step response')
xlabel('time (s) ')
ylabel('y')
grid on
%% transfer functions
%sys=tf(200,[200 1],'InputDelay',0);
sys=tf(200,[199 1],'InputDelay',1);
%% inputs
%var=0.05;
%input=sqrt(var)*randn(2000,1);

input=ones(3000,1);
% input1=input(1:1200);
% input2=input(1201:2000);

% t=0:1:1999;
% input=chirp(t,0.01,2000,500);
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
data3=iddata(y,input,Ts);
p1d=procest(data3,'P1D');
p1=procest(data3,'P1');

figure(4)
compare(data3,p1d)
title('compare of real system and estimate system (toolbox)')
legend('real','estimate (3 parameters)')

figure(5)
compare(data3,p1)
title('compare of real system and estimate system (toolbox)')
legend('real','estimate (2 parameters)')