clc
clear all
close all
load('HW2_Q2');
%% parameter
na=12;nb=12;nk=1;
%x=randperm(1000);
u=z1.u;
y=z1.y;

%%
% for i=1:15
%     for j=1:15
%     for k=1:1
%        y_arx=arx(z1(1:600),[i j k]);
%        [~, acc(i,j,k), ~]=compare(y_arx,z1(601:1000))
%        if acc(i,j,k)>70
%            m(i,:)=i;
%            n(j,:)=j;
%            q(k,:)=k;
% 
%        end
%     end
%     end
% end
%% ARX
Ts=0.5;
z1 = iddata(y,u,Ts)
y_arx=arx(z1(1:600),[na nb nk]);
sys_arx=filt(y_arx.b,y_arx.a,Ts);
est_y_arx=lsim(sys_arx,z1.u);
zeros_sys_arx=roots(y_arx.b);
poles_sys_arx=roots(y_arx.a);

figure
resid(y_arx,z1(601:1000))
figure
grid on
compare(y_arx,z1(601:1000))
title('Parameter Estimation Using ARX Model')
figure
%zpplot(y_arx)
zplane(y_arx.b,y_arx.a)
title('zero pole ARX Model')

figure
crosscorr(u,y)
figure
autocorr(y)
