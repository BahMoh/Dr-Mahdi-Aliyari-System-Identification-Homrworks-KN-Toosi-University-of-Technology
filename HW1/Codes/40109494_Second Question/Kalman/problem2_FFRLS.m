clc
close all
clear all
load ('data')
load('noise1')
load('noise2')
load('noise3')
u=data(:,1);
theta_a=[-0.5 -0.6 0 0.1 0 0 2.25 0 -1.7]'*ones(1,750);
%%
g=1;% 1, 0.1, 0.001
k=1:1:750;
theta_a(4,:)=0.5+tansig(g*(k-400));
% figure(1)
% plot(theta_a(4,:),'-')
% title('g=1')
% grid on
%%
lambda=0.994 ;
%P0=1e6*eye(5);
P0=10*eye(9); 
theta(:,1)=[0;0;0;0;0;0;0;0;0];
utrain=u(1:750,1)';
utest=u(751:1000,1)';
noise=noise3';% noise variance (transpose)

for i=1:750
    X=[1 utrain(i).^1 utrain(i).^2 utrain(i).^3 utrain(i).^4 utrain(i).^5 utrain(i).^6 utrain(i).^7 utrain(i).^8]';
    P=(P0/lambda)*(eye(9)-(X*X'*P0)/(lambda+X'*P0*X));
    Y= -0.5 - 0.6*utrain(i)^1 +(0.5+tansig(g*(i-400)))*utrain(i)^3 + 2.25*utrain(i)^6 -1.7*utrain(i)^8 + noise(1,i);
    theta(:,i+1)=theta(:,i)-P*X*(X'*theta(:,i)-Y);
    P0=P;
    Cov_eig(:,i) = eig(P);

%% reset
%    if mod(i,100)==0
%    P0=10*eye(9);
%    end
end

%% plot
figure(2)
for i=1:9
subplot(3,3,i)
plot(theta(i,:),'linewidth',1.5)
hold on
plot(theta_a(i,:),'linewidth',1.5)
h=[0;1;2;3;4;5;6;7;8]; 
a=strcat('\Theta',num2str(h(i)));
legend('\Theta','\Theta Real')
title(a)
grid on
end

figure(3)
for i=1:9
subplot(3,3,i)
plot(Cov_eig(i,:),'linewidth',1.5)
h=[0;1;2;3;4;5;6;7;8]; 
a=strcat('covariance eig',num2str(h(i)));
%axis([0 750 0 1500])
title(a)
grid on
end

for i=1:9
    m(i)=mse(theta_a(i,1:750)-theta(i,1:750));
end
display(mean(m),'Mean of parameter errors ')

%% test
X=[u.^0 u.^1 u.^2 u.^3 u.^4 u.^5 u.^6 u.^7 u.^8];
for i=0:9
    %utest(25*i+1:25*(i+1))=u(100*i+76:100*(i+1));
    %ytest(25*i+1:25*(i+1))=y4(100*i+76:100*(i+1));
    xtest(25*i+1:25*(i+1),(1:9))= X(1000-25*(i+1):1000-(25*i+1),(1:9));
end
for i=1:250
ytest= -0.5 - 0.6*utest(i)^1 +(0.5+tansig(g*(i-400)))*utest(i)^3 + 2.25*utest(i)^6 -1.7*utest(i)^8 + noise(1,i);
end
Tetha1 = theta(:,end);
Theta2 = [Tetha1(1) Tetha1(2) Tetha1(3) Tetha1(4) Tetha1(5) Tetha1(6) Tetha1(7) Tetha1(8) Tetha1(9)];
Yhatts=xtest*Theta2';
Error_Test = ytest' - Yhatts;

figure(4)
plot(Error_Test)

xlabel('input');
title('Error on test data');
%axis([0 250 -0.6 0.6])
grid on
display(mse(Error_Test),'Mean squared normalized Error on test data ')

figure(5)
plot(Error_Test)
hold on
plot(noise(751:1000))
legend('error on test data','noise')
title('comparison')
xlabel('input');
grid on
display(mse(abs(Error_Test-noise(751:1000)')),'MSE of difference between error and noise')

%%maghadir khob: P0=100*eye(5);  lambda=0.994;  %%bedon reset va g=1
%%maghadir khob: P0=1000*eye(5);  lambda=0.994;  %%bedon reset va g=1

%%baraye cov reset: P0=100*eye(5); lambda=0.98;     if mod(i,100)==0
    %P0=10^2*eye(5);

%%rah2: bar asas error test,lambda bezaram