clc
clear
close all
%%
Ts=0.5;
% t=0:1:1999;
% id_input=chirp(t,0.01,2000,500)';
% [y_id,t_id]=unknown_sys(id_input,Ts);
load id_input_chirp
load y_id_chirp
%% train and test
%x=randperm(1000);
x=1:2000;
% input=id_input(x);
% y_id=y_id(x);

utrain=id_input(1:1200);
utest=id_input(1201:2000);
ytrain=y_id(1:1200);
ytest=y_id(1201:2000);
%% step 1, initial condition
na = 3;
nb = 2;
nc=1;
nk =3; % 1 step delay in u
data = iddata(ytrain,utrain,Ts);
data2 = iddata(ytest,utest,Ts);

ARX = arx(data,[na,nb,nk]); % estimate ARX with noisy train data
error = pe(ARX,data,1);
error = error.OutputData;
yahead= error-ytrain;
%% step2, yahead
A=ARX.a;
B=ARX.b;
C=[1 -0.5];
realparameter = [A(2);A(3);A(4);B(4);B(5);C(2)];
parametr = realparameter;
parametr(6) = 1;

for i=1:90
    y = ytest(i:i+709);
    u = utest(i:i+709);
    y = ytest(1:800);
    u = utest(1:800);
    for k=5:800
       epsilon(k,1) = y(k) + parametr(1)*y(k-1) + parametr(2)*y(k-2) + parametr(3)*y(k-3) - parametr(4)*u(k-3)-parametr(5)*u(k-4) - parametr(6)*error(k-1);
        %e1(k,1)=par(1)*y(k-1)- par(2)*u(k-1)+(1-par(3))*e(k-1);
    end
    error = epsilon;
    y = ytrain;
    u = utrain;
    X = [];
    Y = [];
    for k=5:800
        x = [-y(k-1),-y(k-2),-y(k-3),u(k-3),u(k-4),error(k-1)];
        yahead = y(k)-error(k);
        X = [X;x];
        Y = [Y;yahead];
    end
    parametr = inv(X'*X)*X'*Y;
    Paramz(:,i) = parametr;
end
%%
ARMAX_Real = armax(data,[na nb nc nk]); % estimate ARMAX
%%
z=tf('z');
den=[1 parametr(1) parametr(2) parametr(3)];num=[parametr(4) parametr(5)];
tf_d=z^-3*tf(num,den,Ts)
yout=lsim(tf_d,utest);
yout2=lsim(tf_d,utrain);
data3=iddata(yout,utest,Ts)

figure
plot(yout)
hold on 
plot(ytest,'r')
grid on
xlabel('sample')
title('real output and estimate output (ELS) on test data')
legend('estimate','real')

figure
compare(data2,data3)

title('real output and estimate output (ELS) on test data')
legend('real','estimate')

figure
compare(data2,ARMAX_Real)
title('real output and estimate output (ARMAX) on test data')
legend('real','estimate')