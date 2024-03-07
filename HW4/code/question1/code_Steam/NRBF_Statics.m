clc 
close all 
clear all

load steamgen.dat

nTest=1920;
nTrain=6240; 
U = steamgen(:,2:5);
Y = steamgen(:,6:9);
% Normalizing Data
U(:,1)=(U(:,1)-min(U(:,1)))/(max(U(:,1))-min(U(:,1)));
U(:,2)=(U(:,2)-min(U(:,2)))/(max(U(:,2))-min(U(:,2)));
U(:,3)=(U(:,3)-min(U(:,3)))/(max(U(:,3))-min(U(:,3)));
U(:,4)=(U(:,4)-min(U(:,4)))/(max(U(:,4))-min(U(:,4)));

Y(:,1)=(Y(:,1)-min(Y(:,1)))/(max(Y(:,1))-min(Y(:,1)));
Y(:,2)=(Y(:,2)-min(Y(:,2)))/(max(Y(:,2))-min(Y(:,2)));
Y(:,3)=(Y(:,3)-min(Y(:,3)))/(max(Y(:,3))-min(Y(:,3)));
Y(:,4)=(Y(:,4)-min(Y(:,4)))/(max(Y(:,4))-min(Y(:,4)));

Utr=U(1:6240,:);
Ytr=Y(1:6240,:);
Uts=U(6241:8160,:);
Yts=Y(6241:8160,:);
Uval=U(8161:end,:);
Yval=Y(8161:end,:);


P=Utr;
T=Ytr;
Ptest=Uts;

Ttest=Yts;

%%
epoch=30;
rand('state',0)
neuron = 6;
out=4;

    net = newrb(P',T',0.001,1,[neuron]);
    net.layers{1}.transferFcn = 'radbasn';
    net = init(net);
    net.dividefcn = '';
    net.trainFcn = 'trainlm';
    net.trainParam.epochs = 50;
    net.trainParam.lr = 0.01;
    net = train(net , P' , T');
    y_hat_train = sim(net , P');
    y_hat_test = sim(net,Ptest');
    e = -y_hat_test + Ttest';
    E1 = mse(e);


figure(1)
data1=iddata(Ttest,Ptest)
data2=iddata(y_hat_test',Ptest)
data1=detrend(data1)
data2=detrend(data2)
compare(data1,data2)

figure(2)
e1=e(1,:)
crosscorr(e1,e1,100)
title( 'crosscorr(e1,e1)')
figure(3)
e2=e(2,:)
crosscorr(e2,e2,100)
title( 'crosscorr(e2,e2)')
figure(4)
e3=e(3,:)
crosscorr(e3,e3,100)
title( 'crosscorr(e3,e3)')
figure(5)
e4=e(4,:)
crosscorr(e4,e4,100)
title( 'crosscorr(e4,e4)')
