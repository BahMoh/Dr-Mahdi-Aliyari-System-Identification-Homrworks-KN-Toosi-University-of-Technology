close all 
clear all 
clc

 
load data


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

Dynamics=[10 14 1 1 1 1];

P=[ U1_tr(:,Dynamics(1)) U2_tr(:,Dynamics(2))    U3_tr(:,Dynamics(3))...
    Y1_tr(:,Dynamics(4))    Y2_tr(:,Dynamics(5))        Y3_tr(:,Dynamics(6))  ];

T=[Ytr1 Ytr2 Ytr3];

Ptest=[ U1_ts(:,Dynamics(1)) U2_ts(:,Dynamics(2))    U3_ts(:,Dynamics(3))...
        Y1_ts(:,Dynamics(4))  Y2_ts(:,Dynamics(5))         Y3_ts(:,Dynamics(6)) ];
    
Ttest=[Yts1 Yts2 Yts3];

rand('state',0);
%%
max_epochs = 50;       % Maximum number of epochs
max_hidden = 20;        % Maximum number of hidden layer neurons
HiddenLayer_Neurons = [10];
net = newff(P',T',HiddenLayer_Neurons,{'tansig','purelin'},'trainlm','learngd','mse');
net.trainParam.epochs = max_epochs;
net.trainParam.lr = 0.01;

net.dividefcn = '';
%net.divideParam.trainRatio = 0.4636;  net.divideParam.valRatio = 0.2682;  net.divideParam.testRatio = 0.2682;
ref_mse = inf;
for cnt = 1:5              % Training 10 times NN by all the trn data and choosing the best
    net = init(net);        % Initializing network
    [net,tr_record] = train(net,P',T');
    if tr_record.perf(end) < ref_mse
        ref_mse = tr_record.perf(end);
        final_net = net;
        trn_final_record = tr_record;
    end
end
%%
    y_hat_train = sim(net , P');
    y_hat_test = sim(net,Ptest');
    e = -y_hat_test + Ttest';
    E1 = mse(e);


figure(1)
data1=iddata(Ttest,Ptest);
data2=iddata(y_hat_test',Ptest);
compare(data1,data2)

figure(2)
e1=e(1,:);
crosscorr(e1,e1)
title( 'crosscorr(e1,e1)')
figure(3)
e2=e(2,:);
crosscorr(e2,e2)
title( 'crosscorr(e2,e2)')
figure(4)
e3=e(3,:);
crosscorr(e3,e3)
title( 'crosscorr(e3,e3)')

