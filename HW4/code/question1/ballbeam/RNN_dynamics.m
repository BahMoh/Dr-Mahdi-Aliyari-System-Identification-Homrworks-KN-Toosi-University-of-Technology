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
for i=1:3
    U1_tr(:,i)=[zeros(i,1); Utr(1:nTrain-i,1)];
    Y1_tr(:,i)=[zeros(i,1); Ytr(1:nTrain-i,1)];
    U1_ts(:,i)=[zeros(i,1); Uts(1:nTest-i,1)];
    Y1_ts(:,i)=[zeros(i,1); Yts(1:nTest-i,1)];

end

P=[ U1_tr(:,1) U1_tr(:,2) U1_tr(:,3)  Y1_tr(:,1) Y1_tr(:,2) Y1_tr(:,3)];
T=Ytr;
Ptest=[U1_ts(:,1) U1_ts(:,2) U1_ts(:,3) Y1_ts(:,1) Y1_ts(:,2) Y1_ts(:,3)];
Ttest=Yts;
%%
rand('state',0)

net = newelm(P',T',5,{});

net.layers{1}.transferFcn = 'tansig';
net.trainFcn = 'trainlm';
net.trainParam.epochs=100;
net.dividefcn = '';

[net , tr]= train(net,P',T');
%%
ytest = sim(net,Ptest');
ytrain = sim(net,P');
perf = perform(net,ytest,Ttest');
e = Ttest' - ytest;

data1=iddata(Ttest,Ptest,0.1)
data2=iddata(ytest',Ptest,0.1)

figure(1)
compare(data1,data2)
figure(2)
e1=e(1,:)
crosscorr(e1,e1,100)
title( 'crosscorr(e1,e1)')
