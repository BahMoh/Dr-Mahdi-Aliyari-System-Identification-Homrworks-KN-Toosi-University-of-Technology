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
u_validation = total_P(342:end,:);
y_validation  = total_T(342:end)';

rand('state',5)
%%
in=3;
out=1;
neuron=5;


    net = newrb(Proto',Target',0.001,0.5,[neuron]);
    net = init(net);
%   net.divideParam.trainRatio = 1;
    net.trainFcn = 'trainlm';
    net.trainParam.epochs = 60;
    net.trainParam.lr = 0.01;
    net.dividefcn = '';

    net = train(net , Proto' , Target');
    y_hat_train = sim(net , Proto');
    e1 = Target' - y_hat_train;
    E_train = mse(e1);
    y_hat_valid = sim(net,u_validation');
    e2 = y_validation -y_hat_valid ;
    MSE_Validation = mse(e2);
    

figure
plot(y_validation,'b')
hold on 
plot(y_hat_valid,'r')
title('Validation Output')
xlabel('Time')
ylabel('Out')
legend('Real Output','Estimated Output')
set(findall(figure(1),'type','line'),'linewidth',1.5);

data1=iddata(total_T(342:end,:),total_P(342:end,:));
data2=iddata(y_hat_valid',total_P(342:end,:));
compare(data1,data2)
xlabel('Sample');  ylabel('Output');
legend('validation Real Output','validation NN Output'); 

figure
e1=e2;
crosscorr(e1,e1,100)
title( 'crosscorr(e1,e1)')
