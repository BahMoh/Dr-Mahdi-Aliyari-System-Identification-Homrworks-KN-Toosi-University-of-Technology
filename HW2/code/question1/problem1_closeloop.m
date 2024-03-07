clc
clear all
close all
%% inputs
% u_1=binrand(1:800,10,40,1,'normal');
% u_2=binrand(1:800,30,10,1,'normal');
% u_3=normrnd(0,1,800,1);
% u_4=unifrnd(-1,1,800,1);
%% load data
load data
% u_1=data(:,1);
% u_2=data(:,2);
% u_3=data(:,3);
% u_4=data(:,4);
u=u_1;
%% Data
sigma1 = 0.01;     %minor noise
sigma2 = 0.0700;     %average noise
sigma3 = 0.12;     %major noise
sigma = sigma1;

%v=random('norm',0,0.12,length(u),1);
%% load noise
% load v_1   %%noise1
% load v_2   %%noise2
load v_3    %%noise3
v = v_3;
%% parameters
Ts=0.1;
sys=filt([0 0.48 -0.48],[1 -1.72 0.9],Ts);
csys = feedback(sys,1);
cnoise = feedback(1,sys);
y=lsim(csys,u)+lsim(cnoise,v);

%% iddata
data=iddata(y,u,Ts);
%% parameter
na=2;nb=2;nf=2;nc=1;nd=2;nk=1;
%% ARX
y_arx=arx(data,[na nb nk]);
sys_arx=filt(y_arx.b,y_arx.a,Ts);
est_y_arx=lsim(sys_arx,u);
zeros_sys_arx=roots(y_arx.b)
poles_sys_arx=roots(y_arx.a)
%% ARMAX
y_armax=armax(data,[na nb nc nk]);
sys_armax=filt(y_armax.b,y_armax.a,Ts);
est_y_armax=lsim(sys_armax,u);
zeros_sys_armax=roots(y_armax.b)
poles_sys_armax=roots(y_armax.a)
%% ARARX
y_ararx=pem(data,[na nb 0 nd 0 nk]);
sys_ararx=filt(y_ararx.b,y_ararx.a,Ts);
est_y_ararx=lsim(sys_ararx,u);
zeros_sys_ararx=roots(y_ararx.b)
poles_sys_ararx=roots(y_ararx.a)
%% OE
y_oe=oe(data,[nb nf nk]);
sys_oe=filt(y_oe.b,y_oe.f,Ts);
est_y_oe=lsim(sys_oe,u);
zeros_sys_oe=roots(y_oe.b)
poles_sys_oe=roots(y_oe.f)
%% BJ
y_bj=bj(data,[nb nc nd nf nk]);
sys_bj=filt(y_bj.b,y_bj.f,Ts);
est_y_bj=lsim(sys_bj,u);
zeros_sys_bj=roots(y_bj.b)
poles_sys_bj=roots(y_bj.f)
%% Errors
error_arx=(1/800)*sqrt(sum((est_y_arx-y).^2));
error_armax=(1/800)*sqrt(sum((est_y_armax-y).^2));
error_ararx=(1/800)*sqrt(sum((est_y_ararx-y).^2));
error_bj=(1/800)*sqrt(sum((est_y_bj-y).^2));
error_oe=(1/800)*sqrt(sum((est_y_oe-y).^2));

%% Figure and result
% figure
% plot(y,'--r','linewidth',2)
% hold on
% plot(est_y_arx,'-','linewidth',2)
% plot(est_y_armax,'m-.','linewidth',2)
% plot(est_y_ararx,'g-','linewidth',2)
% plot(est_y_oe,'c-.','linewidth',2)
% plot(est_y_bj,'k--','linewidth',2)
% title(['Output of System and Models with Noise (\mu=0 \sigma^2=0.5'])
% xlabel('Samples')
% legend('y','ARX','ARMAX','ARARX','OE','BJ')
% 
% 
% figure
% plot(y-est_y_arx,'-','linewidth',2)
% hold on
% plot(y-est_y_armax,'m-','linewidth',2)
% plot(y-est_y_ararx,'g-','linewidth',2)
% plot(y-est_y_oe,'c-','linewidth',2)
% plot(y-est_y_bj,'k-','linewidth',2)
% title(['Error of Identification with Noise (\mu=0 \sigma^2=0.5'])
% legend('ARX','ARMAX','ARARX','OE','BJ')
% xlabel('Samples')

figure
compare(y_arx,data)
title('ARX Model')
%xlabel('Samples')
legend('ARX','y')
figure
resid(y_arx,data)
title('ARX Model')

figure
compare(y_armax,data)
title('ARMAX Model')
%xlabel('Samples')
legend('ARMAX','y')
figure
resid(y_armax,data)
title('ARMAX Model')

figure
compare(y_ararx,data)
title('ARARX Model')
%xlabel('Samples')
legend('ARARX','y')
figure
resid(y_ararx,data)
title('ARARX Model')

figure
compare(y_oe,data)
title('OE Model')
%xlabel('Samples')
legend('OE','y')
figure
resid(y_oe,data)
title('OE Model')

figure
compare(y_bj,data)
title('BJ Model')
%xlabel('Samples')
legend('BJ','y')
figure
resid(y_bj,data)
title('BJ Model')

