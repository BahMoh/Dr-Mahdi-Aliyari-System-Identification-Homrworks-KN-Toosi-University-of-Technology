clc
clear all
close all 
%load( 'Data_1' );
load( 'Data_noise_H' );
%load( 'Data_noise_H' );

total_P=[trn_P tst_P vrf_P];
total_T=[trn_T tst_T vrf_T];

%% Normalize input data

total_P(1,:)=(total_P(1,:)-min(total_P(1,:)))/(max(total_P(1,:))-min(total_P(1,:)));
total_P(2,:)=(total_P(2,:)-min(total_P(2,:)))/(max(total_P(2,:))-min(total_P(2,:)));
total_P(3,:)=(total_P(3,:)-min(total_P(3,:)))/(max(total_P(3,:))-min(total_P(3,:)));

total_T=(total_T-min(total_T))/(max(total_T)-min(total_T));

total_P=total_P';
total_T=total_T';

Proto = total_P(1:216,:);
Target = total_T(1:216);
u_validation = total_P(217:341,:);
y_validation  = total_T(217:341)';
rand('state',0)
%%
in=3;
out=1;
for x = 1:200
% neron=16;
    net = newrb(Proto',Target',0.001,0.5,[5]);
    net.layers{1}.transferFcn = 'radbasn';

    net.trainFcn = 'trainlm';
    net.trainParam.epochs = x;
    net.trainParam.lr = 0.01;
    net.dividefcn = '';

    net = train(net , Proto' , Target');
    y_hat_train = sim(net , Proto');
    e1 = Target' - y_hat_train;
    E_train(x) = mse(e1);
    y_hat_test = sim(net,u_validation');
    e2 = -y_hat_test + y_validation;
    E_test(x) = mse(e2);
end

figure(1);
plot(E_train,'b');
hold on;
plot(E_test,'r');
legend('TrainData','TestData');
xlabel('Number of epochs')
ylabel('MSE')
title( 'Find Optimal epochs ')
set(findall(figure(1),'type','line'),'linewidth',2.5);
grid on;
figure(2)
plot(y_validation,'b')
hold on 
plot(y_hat_test,'r')
legend('Ytest','YtestHat');