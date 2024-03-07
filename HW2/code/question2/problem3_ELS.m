clc
clear
close all
%%
Ts=0.5;
id_input=ones(1200,1);
id_input_test=ones(800,1);

% [y_id,t_id]=unknown_sys(id_input,Ts);
% [y_id_test,t_id_test]=unknown_sys(id_input_test,Ts);
load y_id
load y_id_test
%% train and test
%x=randperm(1000);
% x=1:1000;
% input=id_input(x);
% y_id=y_id(x);

utrain=id_input;
utest=id_input_test;
ytrain=y_id;
ytest=y_id_test;
%% step 1, initial condition
na = 1;
nb = 1;
nc=1;
nk = 1; % 1 step delay in u
data = iddata(ytrain,utrain,Ts);
data2 = iddata(ytest,utest,Ts);

ARX = arx(data,[na,nb,nk]); % estimate ARX with noisy train data
e = pe(ARX,data,1);
e = e.OutputData;
yahead= e-ytrain;
%% step2, yahead
A=ARX.a;
B=ARX.b;
C=[1 -0.5];
realparameter = [A(2);B(2);C(2)];
parametr = realparameter;
parametr(3) = 1;

for i=1:90

    y = ytest(1:800);
    u = utest(1:800);
    for k=2:800
        epsilon(k,1) = y(k) + parametr(1)*y(k-1) - parametr(2)*u(k-1) - parametr(3)*e(k-1);
        %e1(k,1)=par(1)*y(k-1)- par(2)*u(k-1)+(1-par(3))*e(k-1);
    end
    e = epsilon;
    y = ytrain;
    u = utrain;
    X = [];
    Y = [];
    for k=2:800
        x = [-y(k-1),u(k-1),e(k-1)];
        yahead = y(k)-e(k);
        X = [X;x];
        Y = [Y;yahead];
    end
    parametr = inv(X'*X)*X'*Y;
    Paramz(:,i) = parametr;
    %% finish!
end
%%
ARMAX_Real = armax(data,[na nb nc nk]); % estimate ARMAX
%%
z=tf('z');
den=[1 parametr(1)];num=[parametr(2)];
tf_d=z^-1*tf(num,den,Ts)
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