clc
clear all
close all
load('HW2_Q2');
%% parameter
nb=3;nc=1;nd=0;nf=3;nk=1;
%%
% for i=1:5
%     for j=1:5
%         for l=1:5
%     for k=1:5
%        y_bj=bj(z1(1:600),[i j l k 1]);
%        [~, acc(i,j,l,k), ~]=compare(y_bj,z1(601:1000))
%        if acc(i,j,l,k)>70
%            b(i,:)=i;
%            c(j,:)=j;
%            d(l,:)=l;
%            f(k,:)=k;
% 
%        end
%     end
%     end
%     end
% end

%% BJ
Ts=0.5;
y_bj=bj(z1(1:600),[nb nc nd nf nk]);
sys_bj=filt(y_bj.b,y_bj.a,Ts);
est_y_bj=lsim(sys_bj,z1.u);
zeros_sys_bj=roots(y_bj.b);
poles_sys_bj=roots(y_bj.f);

figure
resid(y_bj,z1(601:1000))
figure
grid on
compare(y_bj,z1(601:1000))
title('Parameter Estimation Using BJ Model')
figure
%zpplot(y_bj)
zplane(y_bj.b,y_bj.f)
title('zero pole BJ Model')