close all 
clear   
clc

load data

%% Khorouji avval
% i=1;
% figure(i)
% i=i+1;
% crosscorr(u1,y1)
% title('Corrolation(u1,y1)')
% figure(i)
% i=i+1;
% crosscorr(u2,y1)
% title('Corrolation(u2,y1)')
% figure(i)
% i=i+1;
% crosscorr(u3,y1)
% title('Corrolation(u3,y1)')
% figure(i)
% i=i+1;
% crosscorr(y2,y1)
% title('Corrolation(y2,y1)')
% figure(i)
% i=i+1;
% crosscorr(y3,y1)
% title('Corrolation(y3,y1)')
% figure(i)
% i=i+1;
% crosscorr(y1,y1)
% title('Corrolation(y1,y1)')
% 
% 
% %% Khorouji Dovvom
% 
% figure(i)
% i=i+1;
% crosscorr(u1,y2)
% title('Corrolation(u1,y2)')
% figure(i)
% i=i+1;
% crosscorr(u2,y2)
% title('Corrolation(u2,y2)')
% figure(i)
% i=i+1;
% crosscorr(u3,y2)
% title('Corrolation(u3,y2)')
% figure(i)
% i=i+1;
% crosscorr(y1,y2)
% title('Corrolation(y1,y2)')
% figure(i)
% i=i+1;
% crosscorr(y3,y2)
% title('Corrolation(y3,y2)')
% figure(i)
% i=i+1;
% crosscorr(y2,y2)
% title('Corrolation(y2,y2)')
% 
% %% Khorouj Sevvom
% 
% figure(i)
% i=i+1;
% crosscorr(u1,y3)
% title('Corrolation(u1,y3)')
% figure(i)
% i=i+1;
% crosscorr(u2,y3)
% title('Corrolation(u2,y3)')
% figure(i)
% i=i+1;
% crosscorr(u3,y3)
% title('Corrolation(u3,y3)')
% figure(i)
% i=i+1;
% crosscorr(y1,y3)
% title('Corrolation(y1,y3)')
% figure(i)
% i=i+1;
% crosscorr(y2,y3)
% title('Corrolation(y2,y3)')
% figure(i)
% i=i+1;
% crosscorr(y3,y3)
% title('Corrolation(y3,y3)')

nTest=1891;
nTrain=4414;

for i=1:21
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

P=[ U1_tr(:,5)    U1_tr(:,8)    U1_tr(:,10)   U1_tr(:,16)  U1_tr(:,19)...
    U2_tr(:,1)    U2_tr(:,3)    U2_tr(:,4)    U2_tr(:,7)...
    U2_tr(:,8)    U2_tr(:,10)   U2_tr(:,14)   U2_tr(:,15)...
    U2_tr(:,18)   U2_tr(:,20)   U3_tr(:,2)    U3_tr(:,5)...
    U3_tr(:,6)    U3_tr(:,8)    U3_tr(:,9)    U3_tr(:,10)...
    U3_tr(:,14)   U3_tr(:,16)   U3_tr(:,18)   U3_tr(:,19) ...
    Y1_tr(:,1)    Y1_tr(:,2)    Y2_tr(:,1)    Y2_tr(:,4)   Y2_tr(:,15)...
    Y3_tr(:,1)    Y3_tr(:,20)];

T=[Ytr1 Ytr2 Ytr3];

Ptest=[ U1_ts(:,5)    U1_ts(:,8)    U1_ts(:,10)   U1_ts(:,16)...
        U1_ts(:,19)   U2_ts(:,1)    U2_ts(:,3)    U2_ts(:,4)...
        U2_ts(:,7)    U2_ts(:,8)    U2_ts(:,10)   U2_ts(:,14) ...
        U2_ts(:,15)   U2_ts(:,18)   U2_ts(:,20)   U3_ts(:,2) ...
        U3_ts(:,5)    U3_ts(:,6)    U3_ts(:,8)    U3_ts(:,9)  ...
        U3_ts(:,10)   U3_ts(:,14)   U3_ts(:,16)   U3_ts(:,18) ...
        U3_ts(:,19)   Y1_ts(:,1)    Y1_ts(:,2)    Y2_ts(:,1)   ...
        Y2_ts(:,4)    Y2_ts(:,15)   Y3_ts(:,1)    Y3_ts(:,20)];

Ttest=[Yts1 Yts2 Yts3];
rand('state',0)
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

    y_hat_train = sim(final_net , P');
    y_hat_test = sim(final_net,Ptest');
    e = -y_hat_test + Ttest';
    E1 = mse(e);

figure(1)
data1=iddata(Ttest,Ptest)
data2=iddata(y_hat_test',Ptest)
compare(data1,data2)

figure(2)
e1=e(1,:)
crosscorr(e1,e1)
title( 'crosscorr(e1,e1)')
figure(3)
e2=e(2,:)
crosscorr(e2,e2)
title( 'crosscorr(e2,e2)')
figure(4)
e3=e(3,:)
crosscorr(e3,e3)
title( 'crosscorr(e3,e3)')

