clc
clear all
close all
%% inputs
% u_1=binrand(1:800,10,40,1,'normal');
% u_2=binrand(1:800,30,10,1,'normal');
% u_3=normrnd(0,1,800,1);
% u_4=unifrnd(-1,1,800,1);
%% load data_p2
load data
% u_1=data(:,1);
% u_2=data(:,2);
% u_3=data(:,3);
% u_4=data(:,4);

% figure(1)
% plot(u_1,'linewidth',2)
% title('binrand Input 1 with Normal Distribution')
% figure(2)
% plot(u_2,'linewidth',2)
% title('binrand Input 2 with Normal Distribution')
%% system
Ts=0.1;
sys=filt([0 0.48 -0.48],[1 -1.72 0.9],Ts);

y_1=lsim(sys,u_1);
y_2=lsim(sys,u_2);
y_3=lsim(sys,u_3);
y_4=lsim(sys,u_4);

%%
%% iddata
data_1=iddata(y_1,u_1,Ts);
data_2=iddata(y_2,u_2,Ts);
data_3=iddata(y_3,u_3,Ts);
data_4=iddata(y_4,u_4,Ts);

%% ARX
na=2;
nb=2;
nc=1;
nk=1;
estimated_y_1_arx=arx(data_1,[na nb nk]);
estimated_y_2_arx=arx(data_2,[na nb nk]);
estimated_y_3_arx=arx(data_3,[na nb nk]);
estimated_y_4_arx=arx(data_4,[na nb nk]);

[est_num_1_arx,est_den_1_arx]=tfdata(estimated_y_1_arx,'v');
[est_num_2_arx,est_den_2_arx]=tfdata(estimated_y_2_arx,'v');
[est_num_3_arx,est_den_3_arx]=tfdata(estimated_y_3_arx,'v');
[est_num_4_arx,est_den_4_arx]=tfdata(estimated_y_4_arx,'v');

est_sys_1_arx=tf(est_num_1_arx,est_den_1_arx,Ts);
est_sys_2_arx=tf(est_num_2_arx,est_den_2_arx,Ts);
est_sys_3_arx=tf(est_num_3_arx,est_den_3_arx,Ts);
est_sys_4_arx=tf(est_num_4_arx,est_den_4_arx,Ts);

est_y_1_arx=lsim(est_sys_1_arx,u_1);
est_y_2_arx=lsim(est_sys_2_arx,u_2);
est_y_3_arx=lsim(est_sys_3_arx,u_3);
est_y_4_arx=lsim(est_sys_4_arx,u_4);

%% ARMAX
estimated_y_1_armax=armax(data_1,[na nb nc nk]);
estimated_y_2_armax=armax(data_2,[na nb nc nk]);
estimated_y_3_armax=armax(data_3,[na nb nc nk]);
estimated_y_4_armax=armax(data_4,[na nb nc nk]);

sys1_armax=filt(estimated_y_1_armax.b,estimated_y_1_armax.a,Ts);
sys2_armax=filt(estimated_y_2_armax.b,estimated_y_2_armax.a,Ts);
sys3_armax=filt(estimated_y_3_armax.b,estimated_y_3_armax.a,Ts);
sys4_armax=filt(estimated_y_4_armax.b,estimated_y_4_armax.a,Ts);

est_y_1_armax=lsim(sys1_armax,u_1);
est_y_2_armax=lsim(sys2_armax,u_2);
est_y_3_armax=lsim(sys3_armax,u_3);
est_y_4_armax=lsim(sys4_armax,u_4);

%% poles and zeros
zeros_sys=roots([0 0.48 -0.48]);
poles_sys=roots([1 -1.72 0.9]);

zeros_arx_1=roots([estimated_y_1_arx.b]);
poles_arx_1=roots(estimated_y_1_arx.a);

zeros_arx_2=roots([estimated_y_2_arx.b]);
poles_arx_2=roots(estimated_y_2_arx.a);

zeros_arx_3=roots([estimated_y_3_arx.b]);
poles_arx_3=roots(estimated_y_3_arx.a);

zeros_arx_4=roots([estimated_y_4_arx.b]);
poles_arx_4=roots(estimated_y_4_arx.a);

zeros_armax_1=roots([estimated_y_1_armax.b]);
poles_armax_1=roots(estimated_y_1_armax.a);

zeros_armax_2=roots([estimated_y_2_armax.b]);
poles_armax_2=roots(estimated_y_2_armax.a);

zeros_armax_3=roots([estimated_y_3_armax.b]);
poles_armax_3=roots(estimated_y_3_armax.a);

zeros_armax_4=roots([estimated_y_4_armax.b]);
poles_armax_4=roots(estimated_y_4_armax.a);

%% Errors
error_arx_1=(1/800)*sqrt(sum((est_y_1_arx-y_1).^2))
error_arx_2=(1/800)*sqrt(sum((est_y_2_arx-y_2).^2))
error_arx_3=(1/800)*sqrt(sum((est_y_3_arx-y_3).^2))
error_arx_4=(1/800)*sqrt(sum((est_y_4_arx-y_4).^2))

error_armax_1=(1/800)*sqrt(sum((est_y_1_armax-y_1).^2))
error_armax_2=(1/800)*sqrt(sum((est_y_2_armax-y_2).^2))
error_armax_3=(1/800)*sqrt(sum((est_y_3_armax-y_3).^2))
error_armax_4=(1/800)*sqrt(sum((est_y_4_armax-y_4).^2))

%% Plotting for first input
% figure
% plot(y_1,'--r','linewidth',2)
% hold on
% plot(est_y_1_arx,'b','linewidth',2)
% plot(est_y_1_armax,'k','linewidth',2)
% title('ARX and ARMAX Model (binrand Input (tmin=40,N=10))')
% xlabel('Samples')
% legend('y','ARX','ARMAX')
% 
% figure
% plot(y_1-est_y_1_arx,'linewidth',2)
% hold on
% plot(y_1-est_y_1_armax,'k','linewidth',2)
% title('Error ARX and ARMAX (binrand Input (tmin=40,N=10))')
% legend('ARX','ARMAX')
% xlabel('Samples')

%% Plotting for second input
%  figure
% plot(y_2,'--r','linewidth',2)
% hold on
% plot(est_y_2_arx,'b','linewidth',2)
% plot(est_y_2_armax,'k','linewidth',2)
% title('ARX and ARMAX Model (binrand Input (tmin=10,N=30))')
% xlabel('Samples')
% legend('y','ARX','ARMAX')
% 
% figure
% plot(y_2-est_y_2_arx,'linewidth',2)
% hold on
% plot(y_2-est_y_2_armax,'k','linewidth',2)
% title('Error ARX and ARMAX (binrand Input (tmin=10,N=30))')
% legend('ARX','ARMAX')
% xlabel('Samples')

%% Plotting for THIRD input
%  figure
% plot(y_3,'--r','linewidth',2)
% hold on
% plot(est_y_3_arx,'b','linewidth',2)
% plot(est_y_3_armax,'k','linewidth',2)
% title('ARX and ARMAX Model (normrnd Input')
% xlabel('Samples')
% legend('y','ARX','ARMAX')
% 
% figure
% plot(y_3-est_y_3_arx,'linewidth',2)
% hold on
% plot(y_3-est_y_3_armax,'k','linewidth',2)
% title('Error ARX and ARMAX (normrnd Input')
% legend('ARX','ARMAX')
% xlabel('Samples')

% Plotting for fourth input
 figure
plot(y_4,'--r','linewidth',2)
hold on
plot(est_y_4_arx,'b','linewidth',2)
plot(est_y_4_armax,'k','linewidth',2)
title('ARX and ARMAX Model (unifrnd Input')
xlabel('Samples')
legend('y','ARX','ARMAX')

figure
plot(y_4-est_y_4_arx,'linewidth',2)
hold on
plot(y_4-est_y_4_armax,'k','linewidth',2)
title('Error ARX and ARMAX (unifrnd Input')
legend('ARX','ARMAX')
xlabel('Samples')

%% plot 1
% figure
% compare(estimated_y_1_arx,data_1)
% title('ARX Model (binrand Input (tmin=40,N=10))')
% %xlabel('Samples')
% legend('y','ARX')
% figure
% resid(estimated_y_1_arx,data_1)
% title('ARX Model (binrand Input (tmin=40,N=10))')
% %xlabel('Samples')
% %legend('y','ARX','ARMAX')
% 
% figure
% compare(estimated_y_1_armax,data_1)
% title('ARMAX Model (binrand Input (tmin=40,N=10))')
% %xlabel('Samples')
% legend('y','ARMAX')
% figure
% resid(estimated_y_1_armax,data_1)
% title('ARMAX Model (binrand Input (tmin=40,N=10))')
% %xlabel('Samples')
% %legend('y','ARX','ARMAX')

%% plot 2
% figure
% compare(estimated_y_2_arx,data_2)
% title('ARX Model (binrand Input (tmin=10,N=30))')
% xlabel('Samples')
% legend('y','ARX')
% figure
% resid(estimated_y_2_arx,data_2)
% title('ARX Model (binrand Input (tmin=10,N=30))')
% %xlabel('Samples')
% %legend('y','ARX','ARMAX')
% 
% figure
% compare(estimated_y_2_armax,data_2)
% title('ARMAX Model (binrand Input (tmin=10,N=30))')
% xlabel('Samples')
% legend('y','ARMAX')
% figure
% resid(estimated_y_2_armax,data_2)
% title('ARMAX Model (binrand Input (tmin=10,N=30))')
% %xlabel('Samples')
% %legend('y','ARX','ARMAX')

%% plot 3
% figure
% compare(estimated_y_3_arx,data_3)
% title('ARX Model (normrnd Input)')
% %xlabel('Samples')
% legend('y','ARX')
% figure
% resid(estimated_y_3_arx,data_3)
% title('ARX Model (normrnd Input)')
% %xlabel('Samples')
% %legend('y','ARX','ARMAX')
% 
% figure
% compare(estimated_y_3_armax,data_3)
% title('ARMAX Model (normrnd Input)')
% %xlabel('Samples')
% legend('y','ARMAX')
% figure
% resid(estimated_y_3_armax,data_3)
% title('ARMAX Model (normrnd Input)')
% %xlabel('Samples')
% %legend('y','ARX','ARMAX')

%% plot 4
figure
compare(estimated_y_4_arx,data_4)
title('ARX Model (unifrnd Input)')
%xlabel('Samples')
legend('y','ARX')
figure
resid(estimated_y_4_arx,data_4)
title('ARX Model (unifrnd Input)')
%xlabel('Samples')
%legend('y','ARX','ARMAX')

figure
compare(estimated_y_4_armax,data_4)
title('ARMAX Model (unifrnd Input)')
%xlabel('Samples')
legend('y','ARMAX')
figure
resid(estimated_y_4_armax,data_4)
title('ARMAX Model (unifrnd Input)')
%xlabel('Samples')
%legend('y','ARX','ARMAX')