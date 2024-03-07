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
% n3 = wgn(1,1000,10);
% n3=(n3-mean(n3));
% mean_noise=mean(n3)
% var_noise=var(n3)

%% change noise (output)
y_without_noise=-0.6*u.^2 + 2.25*u.^3 - 0.1*u.^2 - 0.1*u.^3;
y=-0.6*u.^2 + 2.25*u.^3 - 0.1*u.^2 - 0.1*u.^3 - 0.1*n3';
X=[u.^2 u.^3 u.^2+u.^3];
std(y)/std(y_without_noise);

figure(1)
hist(X(:,1))
title('histogram of Regressor1')
figure(2)
hist(X(:,2))
title('histogram of Regressor2')
figure(3)
hist(X(:,3))
title('histogram of Regressor3')



%%
for k=0:1:9
xtrain=X(100*k+1:100*k+75,1:3);
ytrain=y(100*k+1:100*k+75);
xtest=X(100*k+76:100*(k+1),1:3);
ytest=y(100*k+76:100*(k+1));

teta(k+1,1:3)=(inv((xtrain)'*(xtrain)))*(xtrain)'*(ytrain);
end
display(det((xtrain)'*(xtrain)),'Det of X*X(T) ')
display(norm(inv((xtrain)'*(xtrain))),'norm of inv X*X(T) ')
tetahat=(mean(teta))';
for i=0:9
    utest(25*i+1:25*(i+1))=u(100*i+76:100*(i+1));
    ytest(25*i+1:25*(i+1))=y(100*i+76:100*(i+1));
    xtest(25*i+1:25*(i+1),(1:3))= X(100*i+76:100*(i+1),(1:3));
end
yhat=xtest*tetahat;
e=ytest-yhat;
I=e'*e;
%% figure
%%input_output
figure(4)
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

figure(5)
plot(utest,e,'ko');
legend('Error on test data');
%axis([0 1 -1.5 1.5])
display(mse(e),'Mean squared normalized error ')
grid on;
xlabel('input');
ylabel('Error');

sigma2=((e'*e)/(250-9));                     %%N-n
cov_tetahat=(sigma2)*(inv(xtest'*xtest));
covyhat=xtest*cov_tetahat*xtest';
error_band_pos=yhat+sqrt(diag(covyhat));
error_band_neg=yhat-sqrt(diag(covyhat));

figure(6)
plot(utest,error_band_pos,'ko',utest,error_band_neg,'ko',utest,yhat,'g*');
legend('Error Bar');
grid on;
xlabel('input');
%axis([0 1 -1 0])

title('Error Bar')

