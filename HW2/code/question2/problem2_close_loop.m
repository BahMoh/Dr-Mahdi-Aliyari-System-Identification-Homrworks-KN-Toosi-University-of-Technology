clc
clear all
close all
load('HW2_Q2');
%% parameter
na=3;nb=3;nc=3;nk=1;
%% ARmaX
Ts=0.5;
y_armax=armax(z2(1:600),[na nb nc nk]);
sys_arx=filt(y_armax.b,y_armax.a,Ts);
est_y_arx=lsim(sys_arx,z2.u);
zeros_sys_arx=roots(y_armax.b);
poles_sys_arx=roots(y_armax.a);

figure
resid(y_armax,z2(601:1000))
figure
grid on
compare(y_armax,z2(601:1000))
title('Parameter Estimation Using ARMAX Model')