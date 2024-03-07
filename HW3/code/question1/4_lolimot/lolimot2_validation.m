clc
clear all
close all
addpath('F:\dars\MSc\4021\Identification\HW3_MohamadAlikhani_40109494\New folder\code\question1\4_lolimot\LMNtool_Version_1.5.2')
 
%load( 'Data_1' );
load( 'Data_noise_M' );
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
u_test = total_P(217:341,:);
y_test = total_T(217:341)';
u_val = total_P(342:end,:);
y_val = total_T(342:end)';
%%
rand('state',0)

x=3;
LMN = lolimot;
LMN.input = Proto;
LMN.output = Target;

LMN.xRegressorDegree = 1;       % use 1st order polynoms for local models (default: 1)
LMN.maxNumberOfLM = x;         % Termination criterion for maximal number of LLMs
LMN.minError = 0.01;            % Termination criterion for minimal error
LMN.kStepPrediction = 0;        % Static model
LMN.smoothness = 1;             % Less overlap between the validity functions
LMN.history.displayMode = true; % display information

LMN = LMN.train;
y_hat_val = calculateModelOutput(LMN, u_val, y_val);
y_hat_test = calculateModelOutput(LMN, u_test, y_test);

y_hat_train = calculateModelOutput(LMN, Proto, Target);

e= y_val'-y_hat_val;
MSE_Validation=mse(e);
SSE_Validation=mse(e)

e2= Target-y_hat_train;
MSE_Train=mse(e2);

figure
plot(y_val,'b')
hold on 
plot(y_hat_val,'r')
legend('Y_validation','Y_validation_Hat');
% set(findall(figure(1),'type','line'),'linewidth',2.5);
grid on;

data1=iddata(total_T(342:end,:),total_P(342:end,:));
data2=iddata(y_hat_val ,total_P(342:end,:));
figure
compare(data1,data2)
xlabel('Sample');  ylabel('Output');
legend('validation Real Output','validation NN Output'); 

figure
e1=e;
crosscorr(e1,e1,100)
title( 'crosscorr(e1,e1)')

data3=iddata(y_test',u_test);
data4=iddata(y_hat_test ,u_test);
figure
compare(data3,data4)
xlabel('Sample');  ylabel('Output');
legend('Test Real Output','Test NN Output'); 



