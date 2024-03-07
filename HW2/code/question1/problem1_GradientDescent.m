clc
clear all
close all
%% input
load data
% u_1=data(:,1);
% u_2=data(:,2);
% u_3=data(:,3);
% u_4=data(:,4);
u=u_4;
%% second system
Ts=0.1;
sys=filt([0 0.48 -0.48],[1 -1.72 0.9],Ts);
y=lsim(sys,u);
%% iddata
data=iddata(y,u,Ts);
%% ARX with toolbox
na=2;nb=2;nk=1;
Y_arx=arx(data,[na nb nk]);
[num_arx,den_arx]=tfdata(Y_arx,'v');
sys_arx=tf(num_arx,den_arx,Ts);
y_arx=lsim(sys_arx,u);
%% ARX Gradient Descent Algorithm
X = GenData(na,nb,nk,u,y); 
theta=randi([-2 2],1,na+nb); % initial theta : random theta beetwin [-2 2]
Gradient=ones(1,nb+na);
Step= 0.0001;
while norm(Gradient)>1e-4
     Gradient = -2.*(y'-(theta*X'))*X; 
   theta=theta-Step*Gradient;
end
den_arx_Gradient=[1 theta(1:nb)];
num_arx_Gradient=[zeros(1,nk) theta(nb+1:nb+na)];
sys_arx_Gradient=filt(num_arx_Gradient,den_arx_Gradient,Ts);
y_arx_Gradient=lsim(sys_arx_Gradient,u);
%% plot
figure
plot(y,'-r','linewidth',2)
hold on
plot(y_arx,'*','linewidth',2)
hold on
plot(y_arx_Gradient,'--black','linewidth',2)
title('Output of System and ARX Model')
xlabel('Samples')
legend('y','ARX Ident','ARX GD')

%% poles and zeros

zeros_sys=roots(sys.Numerator{1, 1})
zeros_arx_ident=roots(sys_arx.Numerator{1, 1})
zeros_arx_Gradient=roots(sys_arx_Gradient.Numerator{1, 1})

poles_sys=roots(sys.Denominator{1, 1})
poles_arx_ident=roots(sys_arx.Denominator{1, 1})
poles_arx_Gradient=roots(sys_arx_Gradient.Denominator{1, 1})