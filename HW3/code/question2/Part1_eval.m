clc
clear
close all
load( 'Data' );
%load( 'Data_noise_L' );
%load( 'Data_noise_H' ); 
 

total_P=[GS PA WS];
total_T=[TM];

%% Normalize input data

total_P(:,1)=(total_P(:,1)-min(total_P(:,1)))/(max(total_P(:,1))-min(total_P(:,1)));
total_P(:,2)=(total_P(:,2)-min(total_P(:,2)))/(max(total_P(:,2))-min(total_P(:,2)));
total_P(:,3)=(total_P(:,3)-min(total_P(:,3)))/(max(total_P(:,3))-min(total_P(:,3)));

total_T=(total_T-min(total_T))/(max(total_T)-min(total_T));

total_P=total_P';
total_T=total_T';

P=total_P(:,1:233);
T=total_T(:,1:233);

Ptest=total_P(:,234:367);
Ttest=total_T(:,234:367);

Pvalid=total_P(:,367:end);
Tvalid=total_T(:,367:end);

rand('state',0)


%% Parameter Identification of MLP
HiddenLayer_Neurons = 5;
net = newff(P,T,HiddenLayer_Neurons,{'tansig','purelin'},'trainlm','learngd','mse');
net.trainParam.epochs = 20;   %% optimum epochs!
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

trn_Y = sim(final_net,P);

error_train = T-trn_Y;
MSE_train = mse(error_train)
var_train = var(error_train)

figure      % Output of real & model system
plot(1:length(T),T,'-b',1:length(trn_Y),trn_Y,'--r','LineWidth',1.5)
xlabel('Sample');  ylabel('Output');
legend('Training Real Output','Training NN Output');  xlim([1 length(total_T(:,1:216))]);
grid on

tst_Y = sim(final_net,Ptest);
error_test = Ttest-tst_Y;
MSE_test = mse(error_test)
var_test = var(error_test)


val_Y = sim(final_net,Pvalid);
error_val = Tvalid-val_Y;
MSE_val = mse(error_val)
var_val = var(error_val)

figure
subplot(2,1,1);  
plot(Ttest,'-b','LineWidth',1.5); hold on ; plot(tst_Y,'--r','LineWidth',1.5);
legend('test Real Output','test NN Output'); 
grid on
subplot(2,1,2);  
plot(Tvalid,'-b','LineWidth',1.5); hold on ; plot(val_Y,'--r','LineWidth',1.5);
xlabel('Sample');  ylabel('Output');
legend('validation Real Output','validation NN Output'); 
grid on

%%

data1=iddata(Tvalid',Pvalid');
data2=iddata(val_Y',Pvalid');
figure
compare(data1,data2)
xlabel('Sample');  ylabel('Output');
legend('validation Real Output','validation NN Output'); 

figure
e1=error_val;
crosscorr(e1,e1,100)
title( 'crosscorr(e1,e1) on valid data')
%%
data3=iddata(Ttest',Ptest');
data4=iddata(tst_Y',Ptest');
figure
compare(data3,data4)
xlabel('Sample');  ylabel('Output');
legend('test Real Output','test NN Output'); 

figure
e1=error_test;
crosscorr(e1,e1,100)
title( 'crosscorr(e1,e1) on test data')
%%
data5=iddata(T',P');
data6=iddata(trn_Y',P');
figure
compare(data5,data6)
xlabel('Sample');  ylabel('Output');
legend('Train Real Output','Train NN Output'); 

figure
e1=error_train;
crosscorr(e1,e1,100)
title( 'crosscorr(e1,e1) on Train data')