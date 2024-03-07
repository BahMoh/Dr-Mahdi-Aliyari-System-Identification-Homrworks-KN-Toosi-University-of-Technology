clc
clear all
close all
load ('data')
load('noise1')
load('noise2')
load('noise3')
u=data(:,1);
%%
g=0.01;
rand=0.75*length(u);
Eig=zeros(10,rand);
%noise=noise3';
for i=1:length(u)
    y(i,1)= -1.5 - 0.8*u(i)^1 +(0.5+tansig(g*(i-400)))*u(i)^3 + 2.25*u(i)^6 -1.7*u(i)^8 + noise3(i); %% noise
    Real_Theta(i,:)=[-1.5 -0.8 0 (0.5+tansig(g*(i-400))) 0 0 2.25 0 -1.7];

end

u_Train=u(1:rand,1);
y_Train=y(1:rand,1);
u_Test=u(rand+1:end,1);
y_Test=y(rand+1:end,1);

U=[ones(rand,1) u_Train.^1 u_Train.^2 u_Train.^3 u_Train.^4 u_Train.^5 u_Train.^6 u_Train.^7 u_Train.^8];
U_Test=[ones((1000-rand),1) u_Test.^1 u_Test.^2 u_Test.^3 u_Test.^4 u_Test.^5 u_Test.^6 u_Test.^7 u_Test.^8];
%%
theta0=zeros(9,1);
Q=cov(Real_Theta);
sigma=(10^3)*eye(9);
  theta_hat=theta0;
  for i=1:rand

       X=U(i,:);
       sigma=(sigma)*( eye(9)- (X'*X*sigma)/(1+X*sigma*X') )+Q;
       theta_hat=theta_hat-(sigma-Q)*X'*(X*theta_hat-y_Train(i,1));
%       Eig(:,i)=eig(sigma);
       Trace(i)=trace(sigma);
       Norm(i)=norm(sigma);
       theta_save(i,:)=theta_hat';

  end
Y_hat= U_Test*theta_hat;
Error=(y_Test-Y_hat)'*(y_Test-Y_hat);
coverror=cov(y_Test-Y_hat)
varerror=var(y_Test-Y_hat)
%%
figure(1)
plot(y_Test-Y_hat)
title('Error')
% hold on
% plot(noise1(a+1:end,1))
grid on
display(mse(y_Test-Y_hat),'Mean squared normalized Error on test data ')

figure(2)
plot(y_Test)
hold on
plot(Y_hat)
legend('real','Estimate')
title('Estimation')
grid on


for i=1:9
    j=3;
    if i>=5
        j=4;
    end
    if i>=9
        j=5;
    end
    figure(j)
    subplot(2,2,mod(i-1,4)+1)
    plot(theta_save(:,i))
    hold on
    plot(Real_Theta(:,i))
    rand=strcat('theta',num2str(i-1));
    title(rand)
    legend(sprintf('Estimate %s_{%d}','\theta',i-1),'Real \theta')
    grid on
end
figure(6)
plot(Norm)
title('Covariance matrix')
grid on
for i=1:9
    j=7;
    if i>=5
        j=8;
    end
    if i>=9
        j=9;
     end
%     figure(j)
%     subplot(2,2,mod(i-1,4)+1)
%     plot(Eig(1,:),'linewidth',2)
%     rand=strcat('lambda',num2str(i));
%     title(rand)
%     grid on
end
%%
h=[1;2;4;7;9]; 

for i=1:750
    m(1)=mse(theta_save(i,1)-Real_Theta(i,1));
    m(2)=mse(theta_save(i,2)-Real_Theta(i,2));
    m(3)=mse(theta_save(i,4)-Real_Theta(i,4));
    m(4)=mse(theta_save(i,7)-Real_Theta(i,7));
    m(5)=mse(theta_save(i,9)-Real_Theta(i,9));

end
display(mean(m),'Mean of parameter errors ')
Error_Test=y_Test-Y_hat;
figure(7)
plot(Error_Test)
hold on
plot(noise3(751:1000))
legend('error on test data','noise')
title('comparison')
xlabel('input');
grid on
display(mse(abs(Error_Test-noise3(751:1000)')),'MSE of difference between error and noise')