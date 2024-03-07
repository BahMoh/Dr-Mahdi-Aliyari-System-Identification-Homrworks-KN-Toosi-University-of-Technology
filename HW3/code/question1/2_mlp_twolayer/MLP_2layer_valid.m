clc
clear
close all
load( 'Data_1' );
%load( 'Data_noise_H' );
%load(  'Data_noise_H' );


total_P=[trn_P tst_P vrf_P];
total_T=[trn_T tst_T vrf_T];

%% Normalize input data

total_P(1,:)=(total_P(1,:)-min(total_P(1,:)))/(max(total_P(1,:))-min(total_P(1,:)));
total_P(2,:)=(total_P(2,:)-min(total_P(2,:)))/(max(total_P(2,:))-min(total_P(2,:)));
total_P(3,:)=(total_P(3,:)-min(total_P(3,:)))/(max(total_P(3,:))-min(total_P(3,:)));

total_T=(total_T-min(total_T))/(max(total_T)-min(total_T));

total_P=total_P;
total_T=total_T;
rand('state',0)

%% Parameter Identification of MLP
HiddenLayer_Neurons = 5;
net = newff(total_P(:,1:216),total_T(:,1:216),[5 HiddenLayer_Neurons],{'tansig','tansig','purelin'},'trainbfg','learngd','mse');

net.trainParam.epochs = 20;
net.dividefcn = '';
ref_mse = inf;
for cnt = 1:10             % Training 10 times NN by all the trn data and choosing the best
    net = init(net);        % Initializing network
    [net,tr_record] = train(net,total_P,total_T);
    if tr_record.perf(end) < ref_mse
        ref_mse = tr_record.perf(end);
        final_net = net;
        trn_final_record = tr_record;
    end
end
save Data_Part_1_A

%% Plots
load Data_Part_1_A
close all

trn_Y = sim(final_net,total_P(:,1:216));

error_train = total_T(:,1:216)-trn_Y;
MSE_train = mse(error_train)
var_train = var(error_train)

figure      % Output of real & model system
plot(1:length(total_T(:,1:216)),total_T(:,1:216),'-b',1:length(trn_Y),trn_Y,'--r','LineWidth',1.5)
xlabel('Sample');  ylabel('Output');
legend('Training Real Output','Training NN Output');  xlim([1 length(total_T(:,1:216))]);
grid on

tst_Y = sim(final_net,total_P(:,217:341));
error_test = total_T(:,217:341)-tst_Y;
MSE_test = mse(error_test)
var_test = var(error_test)


val_Y = sim(final_net,total_P(:,342:end));
error_val = total_T(:,342:end)-val_Y;
MSE_val = mse(error_val)
var_val = var(error_val)

figure
subplot(2,1,1);  
plot(total_T(:,217:341),'-b','LineWidth',1.5); hold on ; plot(tst_Y,'--r','LineWidth',1.5);
legend('test Real Output','test NN Output'); 
grid on
subplot(2,1,2);  
plot(total_T(:,342:end),'-b','LineWidth',1.5); hold on ; plot(val_Y,'--r','LineWidth',1.5);
xlabel('Sample');  ylabel('Output');
legend('validation Real Output','validation NN Output'); 
grid on

figure;
plotregression(total_T(:,342:end),(val_Y))%Plot linear regression

data1=iddata(total_T(:,342:end)',total_P(:,342:end)');
data2=iddata(val_Y',total_P(:,342:end)');
compare(data1,data2)
xlabel('Sample');  ylabel('Output');
legend('validation Real Output','validation NN Output'); 

figure
e1=error_val;
crosscorr(e1,e1,100)
title( 'crosscorr(e1,e1)')