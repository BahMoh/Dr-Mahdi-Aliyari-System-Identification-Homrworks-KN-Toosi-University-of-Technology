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
y=-1.5*ones(1000,1)-(0.8*u.^1)+(0.01*u.^3)+(2.25*u.^6)-(1.7*u.^8) + noise3;
U_Train=u(1:rand,1);
Y_Train=y(1:rand,1);
U_Test=u(rand+1:end,1);
Y_Test=y(rand+1:end,1);

X_Train=[ones(rand,1) U_Train.^1 U_Train.^2 U_Train.^3 U_Train.^4 U_Train.^5 U_Train.^6 U_Train.^7 U_Train.^8];
X_Test=[ones((1000-rand),1) U_Test.^1 U_Test.^2 U_Test.^3 U_Test.^4 U_Test.^5 U_Test.^6 U_Test.^7 U_Test.^8];
%%
Xtrain_new=[];
Xtest_new=[];
Xtrain_base=X_Train;
Xtest_base=X_Test;
for j=1:size(X_Train,2)
    
    for i=1:size(X_Train,2)
        tp_train=[Xtrain_new X_Train(:,i)];
        tp_test=[Xtest_new X_Test(:,i)];
        teta_hat=inv(((tp_train)')*tp_train)*((tp_train)')*Y_Train;
        y_hat=tp_test*teta_hat;
        er=Y_Test-y_hat;
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
    Xtrain_new=[Xtrain_new X_Train(:,r)];
    Xtest_new=[Xtest_new X_Test(:,r)];
    X_Train(:,r)=[];
    X_Test(:,r)=[];
end
disp(strcat('Order Of Important Regressors Forward Selection =  ',num2str(num)));
figure
plot(Error,'LineWidth',1.5)
xlabel('Number of Regressors')
title('Cost Function')
grid on
%%
se=4;
Xtrain_new=Xtrain_base(:,num(1:se));
Xtest_new=Xtest_base(:,num(1:se));
teta_hat=inv(((Xtrain_new)')*Xtrain_new)*((Xtrain_new)')*Y_Train;
y_hat=Xtest_new*teta_hat;

figure
plot(y_hat);
hold on;
plot(Y_Test);
grid on
legend('Estimated','Real')


e_new=Y_Test-y_hat;
E=(Y_Test-y_hat)'*(Y_Test-y_hat);
figure
plot(e_new)
grid on
title('Error on test data')
J_new=sum(e_new.^2);
display(Error,'Cost Function');
display(mse(e_new),'MSE of Error in Test Data');