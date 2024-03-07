clc
clear
close all
load powerplant.dat
U=powerplant(:,1:5);
Y=powerplant(:,6:8);
Y = Y(:,2);
Ts=1228.8
data = iddata(Y,U,Ts);

na=4;
nb=3;
nc=2;
nf=3;
nd=4;
nk=1;
%% ARX
estimated_y_1_arx=arx(data,[na, na, na, na, na, nk]);
% Num and Denum of the arx estimation
[est_num_1_arx,est_den_1_arx] = tfdata(estimated_y_1_arx,'v');
% Estmateed system using the time constant and num, denum
est_sys_1_arx=tf(est_num_1_arx,est_den_1_arx,Ts);
% Estimated output using lsim
est_y_1_arx=lsim(est_sys_1_arx,data.InputData);
%% ARMAX
na=na;
nb=[nb, nb, nb, nb, nb];
nk=[1, 1, 1, 1, 1];
estimated_y_1_armax=armax(data,[na nb nc nk]);
sys1_armax=filt(estimated_y_1_armax.b,estimated_y_1_armax.a,Ts);
est_y_1_armax=lsim(sys1_armax,data.InputData);

%% BJ
y_bj=bj(data,[nb nc nd nf nk]);
sys_bj=filt(y_bj.b,y_bj.f,Ts);
est_y_bj=lsim(sys_bj,data.InputData);
zeros_sys_bj=roots(y_bj.b)
poles_sys_bj=roots(y_bj.f)
%% ARARX
y_ararx=pem(data,[na nb 0 nd 0 nk]);
sys_ararx=filt(y_ararx.b,y_ararx.a,Ts);
est_y_ararx=lsim(sys_ararx,data.InputData);
zeros_sys_ararx=roots(y_ararx.b)
poles_sys_ararx=roots(y_ararx.a)

%% OE
y_oe=oe(data,[nb nf nk]);
sys_oe=filt(y_oe.b,y_oe.f,Ts);
est_y_oe=lsim(sys_oe,data.InputData);
zeros_sys_oe=roots(y_oe.b)
poles_sys_oe=roots(y_oe.f)

