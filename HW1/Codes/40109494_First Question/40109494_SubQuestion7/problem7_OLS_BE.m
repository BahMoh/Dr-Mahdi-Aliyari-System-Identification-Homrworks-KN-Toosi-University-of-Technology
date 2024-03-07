clc
clear all
close all
%%
load ('data')
load ('noise1')
load ('noise2')
load ('noise3')
u=data(:,1);
rand=0.75*length(u);
%%
y=-1.5*ones(1000,1)-(0.8*u.^1)+(0.01*u.^3)-0.65*(u.^5)+(2.25*u.^6)-(1.7*u.^8);
u_train=u(1:rand,1);
y_train=y(1:rand,1);
u_test=u(rand+1:end,1);
y_test=y(rand+1:end,1);

x_train=[ones(rand,1) u_train.^1 u_train.^2 u_train.^3 u_train.^4 u_train.^5 u_train.^6 u_train.^7 u_train.^8];
x_test=[ones((1000-rand),1) u_test.^1 u_test.^2 u_test.^3 u_test.^4 u_test.^5 u_test.^6 u_test.^7 u_test.^8];
%%
%% ols

N_Regs=9;
x_ols=[x_train;x_test]';
x_test_ols= x_test;
v1=x_ols';
Real_Teta=[-1.5 -0.8 0 0.01 0 -0.65 2.25 0 -1.7]';
I=zeros(1,N_Regs);

for i=1:1000
    teta(:,i)=[-1.5 -0.8 0 0.01 0 -0.65 2.25 0 -1.7];
    Y(i,1)=x_ols(:,i)'*teta(:,i);
end

for i=1:N_Regs
    E1(i)=(v1(:,i)'*Y(:,1))/(v1(:,i)'*v1(:,i));
    err1(i)=E1(i)^2*norm(v1(:,i),2);
end

[m,I(1)]=max(err1);
V(:,1)=v1(:,I(1));

%%

for k=1:N_Regs
    alfa=zeros(1,k-1);
    for i=1:N_Regs
        for z=1:k-1
            if(i==I(z))
                err1(i)=0;
                break
            else
                for j=1:k-1
                    alfa(j)=(V(:,j)'*x_ols(i,:)')/(V(:,j)'*V(:,j));
                end
                al=0;
                for j=1:k-1
                    al=al+alfa(j)*V(:,j);
                end
                v1(:,i)=x_ols(i,:)'-al;
                E1(i)=(v1(:,i)'*Y(:,1))/(v1(:,i)'*v1(:,i));
                err1(i)=E1(i)^2*norm(v1(:,i),2);
            end
        end
        
    end
    [mk ,I(k)]=max(err1);
    V(:,k)=v1(:,I(k));
    T=inv(x_ols*x_ols')*x_ols*V;
    Eta=inv(V'*V)*V'*Y;
    tetahat=T*Eta;
end
for i=1:9
    V_orthogonal(:,I(i))=V(:,i);
end
%% BE
X_Train=V_orthogonal(1:rand,1:9);
X_Test=V_orthogonal(rand+1:end,1:9);
Xtrain_new=X_Train;
Xtest_new=X_Test;
Xtrain_base=X_Train;
Xtest_base=X_Test;
for j=1:size(X_Train,2)
    
    for i=1:size(X_Train,2)
        tp_train=Xtrain_new;
        tp_test=Xtest_new;
        tp_train(:,i)=[];
        tp_test(:,i)=[];
        teta_hat=inv(((tp_train)')*tp_train)*((tp_train)')*y_train;
        y_hat=tp_test*teta_hat;
        er=y_test-y_hat;
        J(i)=sum(er.^2);
    end
    
    [m,r]=min(J);
    Error(j)=m;
    J(r)=[];
    for k=1:size(Xtrain_base,2)
        if X_Train(:,r)==Xtrain_base(:,k)
            num(j)=k;
        end
    end
    Xtrain_new(:,r)=[];
    Xtest_new(:,r)=[];
    X_Train(:,r)=[];
    X_Test(:,r)=[];
end
disp(strcat('Order Regressors Backward Elimination (In orthogonal space)=  ',num2str(num)));
figure
plot(Error,'LineWidth',1.5)
xlabel('Number of Regressors')
title('Cost Function')
%% plots
se=6;
Xtrain_new=Xtrain_base(:,num(se+1:end));
Xtest_new=Xtest_base(:,num(se+1:end));
teta_hat=inv(((Xtrain_new)')*Xtrain_new)*((Xtrain_new)')*y_train
y_hat=Xtest_new*teta_hat;

figure
plot(y_hat);
hold on;
plot(y_test);
legend('Estimated','Real')


e_new=y_test-y_hat;
E=(y_test-y_hat)'*(y_test-y_hat)
figure
plot(e_new)
title('Error on Test Data')
J_new=sum(e_new.^2);
display(Error,'Cost Function')
display(mse(e_new),'MSE of Error in Test Data')
%% real space
X_Train=V_orthogonal(1:rand,1:9);
X_Test=V_orthogonal(rand+1:end,1:9);
Xtrain_new=X_Train;
Xtest_new=X_Test;
Xtrain_base=X_Train;
Xtest_base=X_Test;
y_train=X_Train*Real_Teta;
y_test=X_Test*Real_Teta;
for j=1:size(X_Train,2)
    
    for i=1:size(X_Train,2)
        tp_train=Xtrain_new;
        tp_test=Xtest_new;
        tp_train(:,i)=[];
        tp_test(:,i)=[];
        teta_hat=inv(((tp_train)')*tp_train)*((tp_train)')*y_train;
        y_hat=tp_test*teta_hat;
        er=y_test-y_hat;
        J(i)=sum(er.^2);
    end
    
    [m,r]=min(J);
    Error(j)=m;
    J(r)=[];
    for k=1:size(Xtrain_base,2)
        if X_Train(:,r)==Xtrain_base(:,k)
            num(j)=k;
        end
    end
    Xtrain_new(:,r)=[];
    Xtest_new(:,r)=[];
    X_Train(:,r)=[];
    X_Test(:,r)=[];
end
disp(strcat('Order Regressors Backward Elimination (In Real space)=  ',num2str(num)));
