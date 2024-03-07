clc 
close all 
clear all

load ballbeam.dat

nTest=350;
nTrain=650; 
U = ballbeam(:,1);
Y = ballbeam(:,2);
%% Normalizing Data
U(:,1)=(U(:,1)-min(U(:,1)))/(max(U(:,1))-min(U(:,1)));

Y(:,1)=(Y(:,1)-min(Y(:,1)))/(max(Y(:,1))-min(Y(:,1)));


Utr=U(1:650,:);
Ytr=Y(1:650,:);
Uts=U(651:end,:);
Yts=Y(651:end,:);

%%
P=Utr;
T=Ytr;
Ptest=Uts;
Ttest=Yts;
%%
epoch=30;
rand('state',0)
neuron = 2;

    net = newrb(P',T',0.001,1,[neuron]);
    net = init(net);
    net.dividefcn = '';
    net.trainFcn = 'trainlm';
    net.trainParam.epochs = 150;
    net.trainParam.lr = 0.01;
    net = train(net , P' , T');
    y_hat_train = sim(net , P');
    y_hat_test = sim(net,Ptest');
    e = -y_hat_test + Ttest';
    E1 = mse(e);


figure(1)
data1=iddata(Ttest,Ptest,0.1)
data2=iddata(y_hat_test',Ptest,0.1)
data1=detrend(data1)
data2=detrend(data2)
compare(data1,data2)

figure(2)
e1=e(1,:)
crosscorr(e1,e1,100)
title( 'crosscorr(e1,e1)')

