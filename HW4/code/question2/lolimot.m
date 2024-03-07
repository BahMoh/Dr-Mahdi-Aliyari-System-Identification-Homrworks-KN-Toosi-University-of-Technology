clc
close all 
clear all  

load data
addpath('C:\Users\Ghestionline.com\Downloads\LMNtool_Version_1.5.2')

nTest=1891;
nTrain=4414;

for i=1:41
    U1_tr(:,i)=[zeros(i,1); Utr1(1:nTrain-i,1)];
    U2_tr(:,i)=[zeros(i,1); Utr2(1:nTrain-i,1)];
    U3_tr(:,i)=[zeros(i,1); Utr3(1:nTrain-i,1)];
    Y1_tr(:,i)=[zeros(i,1); Ytr1(1:nTrain-i,1)];
    Y2_tr(:,i)=[zeros(i,1); Ytr2(1:nTrain-i,1)];
    Y3_tr(:,i)=[zeros(i,1); Ytr3(1:nTrain-i,1)];
    U1_ts(:,i)=[zeros(i,1); Uts1(1:nTest-i,1)];
    U2_ts(:,i)=[zeros(i,1); Uts2(1:nTest-i,1)];
    U3_ts(:,i)=[zeros(i,1); Uts3(1:nTest-i,1)];
    Y1_ts(:,i)=[zeros(i,1); Yts1(1:nTest-i,1)];
    Y2_ts(:,i)=[zeros(i,1); Yts2(1:nTest-i,1)];
    Y3_ts(:,i)=[zeros(i,1); Yts3(1:nTest-i,1)];
end
%% ON GA data
Dynamics=[10 14 1 1 1 1];

P=[ U1_tr(:,Dynamics(1)) U2_tr(:,Dynamics(2))    U3_tr(:,Dynamics(3))...
    Y1_tr(:,Dynamics(4))    Y2_tr(:,Dynamics(5))        Y3_tr(:,Dynamics(6))  ];

T=[Ytr1 Ytr2 Ytr3];

Ptest=[ U1_ts(:,Dynamics(1)) U2_ts(:,Dynamics(2))    U3_ts(:,Dynamics(3))...
        Y1_ts(:,Dynamics(4))  Y2_ts(:,Dynamics(5))         Y3_ts(:,Dynamics(6)) ];
    
Ttest=[Yts1 Yts2 Yts3];
%% find structure
% for x=1:30
% LMN = lolimot;
% LMN.input = P;
% LMN.output = T;
% 
% LMN.xRegressorDegree = 1;       % use 1st order polynoms for local models (default: 1)
% LMN.maxNumberOfLM = x;         % Termination criterion for maximal number of LLMs
% LMN.minError = 0.01;            % Termination criterion for minimal error
% LMN.kStepPrediction = 0;        % Static model
% LMN.smoothness = 1;             % Less overlap between the validity functions
% LMN.history.displayMode = true; % display information
% 
% LMN = LMN.train;
% y_hat_test = calculateModelOutput(LMN, Ptest, Ttest);
% 
% y_hat_train = calculateModelOutput(LMN, P, T);
% 
% e1= Ttest-y_hat_test;
% MSE1(x)=mse(e1);
% 
% e2= T-y_hat_train;
% MSE2(x)=mse(e2);
% end
% figure
% plot(Ttest,'b')
% hold on 
% plot(y_hat_test,'r')
% legend('Ytest','YtestHat');
% % set(findall(figure(1),'type','line'),'linewidth',2.5);
% grid on;
% 
% figure
% plot(MSE2,'b')
% hold on 
% plot(MSE1,'r')
% legend('TrainData','TestData');
% xlabel('Number of Neuron')
% ylabel('MSE')
% title( 'Find Optimal Neuron ')
% grid on;


%% 
rand('state',0)

LMN = lolimot;
LMN.input = P;
LMN.output = T;

LMN.xRegressorDegree = 1;       % use 1st order polynoms for local models (default: 1)
LMN.maxNumberOfLM = 2;         % Termination criterion for maximal number of LLMs
LMN.minError = 0.01;            % Termination criterion for minimal error
LMN.kStepPrediction = 0;        % Static model
LMN.smoothness = 1;             % Less overlap between the validity functions
LMN.history.displayMode = true; % display information

LMN = LMN.train;
y_hat_test = calculateModelOutput(LMN, Ptest, Ttest);


e= Ttest-y_hat_test;
MSE_Validation=mse(e)

figure
data1=iddata(Ttest,Ptest);
data2=iddata(y_hat_test,Ptest);
compare(data1,data2)

figure
e1=e(:,1);
crosscorr(e1,e1)
title( 'crosscorr(e1,e1)')
figure
e2=e(:,2);
crosscorr(e2,e2)
title( 'crosscorr(e2,e2)')
figure
e3=e(:,3);
crosscorr(e3,e3)
title( 'crosscorr(e3,e3)')




