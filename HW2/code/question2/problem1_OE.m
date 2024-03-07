clc
clear all
close all
load('HW2_Q2');
%% parameter
%nb=3;nf=3;nk=0;
nb=3;nf=3;nk=1;

%%
% for i=1:5
%     for j=1:5
%     for k=1:1
%        y_oe=oe(z1(1:600),[nb nf nk]);;
%        [~, acc(i,j,k), ~]=compare(y_oe,z1(601:1000))
%        if acc(i,j,k)>70
%            b(i,:)=i;
%            f(j,:)=j;
%            kk(k,:)=k;
% 
%        end
%     end
%     end
% end
%% oe
Ts=0.5;
y_oe=oe(z1(1:600),[nb nf nk]);
sys_oe=filt(y_oe.b,y_oe.a,Ts);
est_y_oe=lsim(sys_oe,z1.u);
zeros_sys_oe=roots(y_oe.b);
poles_sys_oe=roots(y_oe.f);

figure
resid(y_oe,z1(601:1000))
figure
grid on
compare(y_oe,z1(601:1000))
title('Parameter Estimation Using OE Model')
figure
%zpplot(y_oe)
zplane(y_oe.b,y_oe.f)

title('zero pole OE Model')
%%
est_oe=lsim(sys_oe,z1.u(601:1000));

figure
autocorr(abs(est_oe-z1.y(601:1000)),399);