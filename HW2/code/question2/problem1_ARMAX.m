clc
clear all
close all
load('HW2_Q2');
%% parameter
na=3;nb=3;nc=3;nk=1;
%%
for i=1:5
    for j=1:5
        for l=1:5
    for k=1:1
       y_armax=armax(z1(1:600),[i j l k]);
       [~, acc(i,j,l,k), ~]=compare(y_armax,z1(601:1000))
       if acc(i,j,l,k)>70
           a(i,:)=i;
           b(j,:)=j;
           c(l,:)=l;
           kk(k,:)=k;

       end
    end
    end
    end
end
%% ARMAX
Ts=0.5;
y_armax=armax(z1(1:600),[na nb nc nk]);
sys_armax=filt(y_armax.b,y_armax.a,Ts);
est_y_armax=lsim(sys_armax,z1.u);
zeros_sys_armax=roots(y_armax.b);
poles_sys_armax=roots(y_armax.a);

figure
resid(y_armax,z1(601:1000))
figure
grid on
compare(y_armax,z1(601:1000))
title('Parameter Estimation Using ARMAX Model')
figure
%zpplot(y_armax)
zplane(y_armax.b,y_armax.a)

title('zero pole ARMAX Model')