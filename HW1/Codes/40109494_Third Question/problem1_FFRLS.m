%Generate Data
clc
clear all
close all
%u=unifrnd(0,1,1000,1);
load('u')
load('n1')
load('n2')
load('n3')
%% noise
% n1 = wgn(1,1000,1);
% n1=(n1-mean(n1));
% mean_noise=mean(n1)
% var_noise=var(n1)

%%
noise=n3';% noise variance (transpose)
y=-0.6*u.^2 + 2.25*u.^3 - 0.1*u.^2 - 0.1*u.^3 - 0.1*noise ;
X=[u.^2 u.^3 u.^2+u.^3];
theta_a=[-0.6 2.25 -0.1]'*ones(1,750);
lambda=0.99 ;
%P0=1e6*eye(5);
P0=1000*eye(3); 
theta(:,1)=[0;0;0];
utrain=u(1:750,1)';
utest=u(751:1000,1)';
xtest=X(751:1000,1:3);
ytest=y(751:1000,1);
%%
for i=1:750
    X=[utrain(i).^2 utrain(i).^3 utrain(i).^2 + utrain(i).^3]';
    P=(P0/lambda)*(eye(3)-(X*X'*P0)/(lambda+X'*P0*X));
    Y= -0.6*utrain(i).^2 + 2.25*utrain(i).^3 - 0.1*utrain(i).^2 - 0.1*utrain(i).^3 - 0.1*noise(i,1) ;
    theta(:,i+1)=theta(:,i)-P*X*(X'*theta(:,i)-Y);
    P0=P;
    Cov_eig(:,i) = eig(P);

%% reset
%    if mod(i,100)==0
%    P0=1^1*eye(3);
%    end
end
%% plot
figure(2)
for i=1:3
subplot(3,1,i)
plot(theta(i,:),'linewidth',1.5)
hold on
plot(theta_a(i,:),'linewidth',1.5)
h=[0;1;2]; 
a=strcat('\Theta',num2str(h(i)));
legend('\Theta','\Theta Real')
title(a)
grid on
end
for i=1:3
    m(i)=mse(theta_a(i,1:750)-theta(i,1:750));
end
display(mean(m),'Mean of parameter errors ')
%%
Tetha1 = theta(:,end);
Theta2 = [Tetha1(1) Tetha1(2) Tetha1(3)];
yhat=xtest*Theta2';
e=ytest-yhat;
I=e'*e;

%% figure
%%input_output
figure;
plot(utest,yhat,'r*');
%axis([0 1 -1 1])

hold on
plot(utest,ytest,'bO');
%axis([0 1 -1.5 1.5])

legend('Estimated','Real');
grid on;
xlabel('input');
ylabel('output');
%%error bar

figure;
plot(utest,e,'ko');
legend('Error on test data');
%axis([0 1 -1.5 1.5])
display(mse(e),'Mean squared normalized error ')
grid on;
xlabel('input');
ylabel('Error');

sigma2=((e'*e)/(250-3));                     %%N-n
cov_tetahat=(sigma2)*(inv(xtest'*xtest));
covyhat=xtest*cov_tetahat*xtest';
error_band_pos=yhat+sqrt(diag(covyhat));
error_band_neg=yhat-sqrt(diag(covyhat));

figure;
plot(utest,error_band_pos,'ko',utest,error_band_neg,'ko',utest,yhat,'g*');
legend('Error Bar');
grid on;
xlabel('input');
%axis([0 1 -1 0])

title('Error Bar')

