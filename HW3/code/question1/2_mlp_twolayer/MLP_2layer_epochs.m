clc
clear all
close all
%load( 'Data_1' );
load( 'Data_noise_H' );
%load(  'Data_noise_H' );


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
u_test = total_P(217:341,:);
y_test = total_T(217:341)';

total_P=total_P';
total_T=total_T';

rand('state',0)
num_neuron=10;
for epoch = 1:200
    % Defining network
    net = newff(total_P,total_T,[5 num_neuron],{'tansig','tansig','purelin'},'traingd','learngd','mse');
    net.trainParam.epochs = epoch;

    net.trainParam.lr = 0.01;
    net.dividefcn = '';

    net = train(net , Proto' , Target');
    y_hat_train = sim(net , Proto');
    e1 = Target' - y_hat_train;
    E_train(epoch) = mse(e1);
    y_hat_test = sim(net,u_test');
    e2 = -y_hat_test + y_test;
    E_test(epoch) = mse(e2);
end

figure(1);
plot(E_train,'r');
hold on;
plot(E_test,'b');
legend('TrainData','TestData');
xlabel('Number of Epoch')
ylabel('MSE')
title( 'Find Optimal Epoch ')
set(findall(figure(1),'type','line'),'linewidth',1.5);
grid on;
figure
plotregression(Target(:,1),y_hat_train(1,:))	%Plot linear regression
variance_error = var(e2)
E_test(epoch) = mse(e2);


