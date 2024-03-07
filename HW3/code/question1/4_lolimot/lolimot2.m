clc
clear all 
close all

%load( 'Data_1' );
load( 'Data_noise_H' );
addpath('F:\dars\MSc\4021\Identification\HW3_MohamadAlikhani_40109494\New folder\code\question1\4_lolimot\LMNtool_Version_1.5.2')

%load( 'Data_noise_M' );
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
%%
rand('state',0)

for x=1:30
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
y_hat_test = calculateModelOutput(LMN, u_test, y_test);

y_hat_train = calculateModelOutput(LMN, Proto, Target);

e(:,x)= y_test'-y_hat_test;
MSE_Validation(:,x)=mse(e(:,x))

e2(:,x)= Target-y_hat_train;
MSE_Train(:,x)=mse(e2(:,x))
end
figure
plot(y_test,'b')
hold on 
plot(y_hat_test,'r')
legend('Ytest','YtestHat');
% set(findall(figure(1),'type','line'),'linewidth',2.5);
grid on;

figure
plot(MSE_Train,'b','linewidth',1.5)
hold on 
plot(MSE_Validation,'r','linewidth',1.5)
legend('TrainData','TestData');
xlabel('Number of LMN')
ylabel('MSE')
title( 'Find Optimal LMN ')
grid on;




