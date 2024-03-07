clc
clear all
close all
load('HW2_Q2');
%% parameter
na=5;nb=5;nd=7;nk=1;
%%
% for i=1:10
%     for j=1:10
%         for l=1:10
%     for k=1:1
%        y_ararx=pem(z1(1:600),[i j 0 l 0 k]);
%        [~, acc(i,j,l,k), ~]=compare(y_ararx,z1(601:1000))
%        if acc(i,j,l,k)>70
%            a(i,:)=i;
%            b(j,:)=j;
%            d(l,:)=l;
%            kk(k,:)=k;
% 
%        end
%     end
%     end
%     end
% end
%% ARARX
Ts=0.5;
y_ararx=pem(z1(1:600),[na nb 0 nd 0 nk]);
sys_ararx=filt(y_ararx.b,y_ararx.a,Ts);
est_y_ararx=lsim(sys_ararx,z1.u);
zeros_sys_ararx=roots(y_ararx.b);
poles_sys_ararx=roots(y_ararx.a);

figure
resid(y_ararx,z1(601:1000))
figure
grid on
compare(y_ararx,z1(601:1000))
title('Parameter Estimation Using ARARX Model')
figure
%zpplot(y_ararx)
zplane(y_ararx.b,y_ararx.a)

title('zero pole ARARX Model')