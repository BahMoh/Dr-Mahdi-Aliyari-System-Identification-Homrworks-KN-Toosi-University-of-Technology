clc
close all
clear all
%% data
load steamgen
c=steamgen;
U=[c((119-46):(9600-46),2),c(119:9600,2),c(119:9600,3),c((119-13):(9600-13),4),c(119:9600,5),c((119-33):(9600-33),5),c((1):(9600-118),5)];
T=c(119:9600,8);
% num_traindata=8000;
% num_testdata=1600;
num_traindata=3500;
num_testdata=4000;
%% normalizing
for i=1: num_testdata
u(i,1)=(U(i,1)-min(U(:,1)))/(max(U(:,1))-min(U(:,1)));
u(i,2)=(U(i,2)-min(U(:,2)))/(max(U(:,2))-min(U(:,2)));
u(i,3)=(U(i,3)-min(U(:,3)))/(max(U(:,3))-min(U(:,3)));
u(i,4)=(U(i,4)-min(U(:,4)))/(max(U(:,4))-min(U(:,4)));
u(i,5)=(U(i,5)-min(U(:,5)))/(max(U(:,5))-min(U(:,5)));
u(i,6)=(U(i,6)-min(U(:,6)))/(max(U(:,6))-min(U(:,6)));
u(i,7)=(U(i,7)-min(U(:,7)))/(max(U(:,7))-min(U(:,7)));
    z(i)=(T(i)-min(T))/(max(T)-min(T));
end
%% rbf
m=30
epoch=20;
etha1=.01;
etha=0.85;
sigma1=.5;
sigma2=.5;
sigma3=.5;
sigma4=.5;
sigma5=.5;
sigma6=.5;
sigma7=.5;
c=1+5*rand(7,m);
w=-1+2*rand(m,1);
p=1000*eye(m);
for k=1:epoch
for i=1:num_traindata
    for j=1:m
        t1(1,j)= ((u(i,1)-c(1,j))/sigma1)^2;
        t2(1,j)=((u(i,2)-c(2,j))/sigma2)^2;
        t3(1,j)=((u(i,3)-c(3,j))/sigma3)^2;
        t4(1,j)=((u(i,4)-c(4,j))/sigma4)^2;
        t5(1,j)=((u(i,5)-c(5,j))/sigma5)^2;
        t6(1,j)=((u(i,6)-c(6,j))/sigma6)^2;
        t7(1,j)=((u(i,7)-c(7,j))/sigma7)^2;
        phi(1,j)=exp(-.5*(sqrt(t1(j)+t2(j)+t3(j)+t4(j)+t5(j)+t6(j)+t7(j))));
    end
   
    xt=phi';
    yhat(i)=xt'*w;
    e1(i)=z(i)-yhat(i);
   for j=1:m
        c(:,j)=c(:,j)+etha*e1(i)*w(j,1)*[(u(i,1)-c(1,j))/(sigma1^2);(u(i,2)-c(2,j))/(sigma2^2);((u(i,3)-c(3,j))/sigma3)^2;(u(i,4)-c(4,j))/(sigma4^2);(u(i,5)-c(5,j))/(sigma2^5);((u(i,6)-c(6,j))/sigma6)^2;((u(i,7)-c(7,j))/sigma7)^2]*phi(j);
        sigma1=sigma1+etha1*e1(i)*w(j,1)*phi(j)*(1/(sigma1)^3)*((u(i,1)-c(1,j))^2);
        sigma2=sigma2+etha1*e1(i)*w(j,1)*phi(j)*(1/(sigma2)^3)*((u(i,2)-c(2,j))^2); 
        sigma3=sigma3+etha1*e1(i)*w(j,1)*phi(j)*(1/(sigma3)^3)*((u(i,3)-c(3,j))^2); 
        sigma4=sigma4+etha1*e1(i)*w(j,1)*phi(j)*(1/(sigma4)^3)*((u(i,4)-c(4,j))^2);
        sigma5=sigma5+etha1*e1(i)*w(j,1)*phi(j)*(1/(sigma5)^3)*((u(i,5)-c(5,j))^2); 
        sigma6=sigma6+etha1*e1(i)*w(j,1)*phi(j)*(1/(sigma6)^3)*((u(i,6)-c(6,j))^2);
        sigma7=sigma7+etha1*e1(i)*w(j,1)*phi(j)*(1/(sigma7)^3)*((u(i,7)-c(7,j))^2);
   end
    gama=p*xt/(1+xt'*p*xt);
    p=(eye(m)-gama*xt')*p;
    t(i)= trace(p);
    if t(i)>1000
        p=1000*eye(m);
    end
    w=w+gama*e1(i);
    
end
mse_train(k)=mse(e1);
for h=(num_traindata+1):num_testdata
    for g=1:m
     phi1(1,g)=exp(-.5*(sqrt(((u(h,1)-c(1,g))/sigma1)^2+((u(h,2)-c(2,g))/sigma2)^2+((u(h,3)-c(3,g))/sigma3)^2+((u(h,4)-c(4,g))/sigma4)^2+((u(h,5)-c(5,g))/sigma5)^2+((u(h,6)-c(6,g))/sigma6)^2+((u(h,7)-c(7,g))/sigma7)^2)));
    end
 
    xt1=phi1';
    yhat(h)=xt1'*w;
    e2(h)=z(h)-yhat(h);
    gama=p*xt1/(1+xt1'*p*xt1);
    p=(eye(m)-gama*xt1')*p;
    t(h)= trace(p);
    if t(h)>1000
        p=1000*eye(m);
    end
    w=w+gama*e2(h);
        
end
mse_test(k)=mse(e2((num_traindata+1):num_testdata));
end
%% mse
e_train=mse(mse_train)
e_test=mse(mse_test)
%% figure
figure
plot(yhat(1:3500))
hold on
plot(z(1:3500),'r')
figure
plot(yhat(3501:4000))
hold on
plot(z(3501:4000),'r')