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
%================================ NOE ====================================%
Ytr = con2seq(T');
Utr = con2seq(P');
a=1;
d1 = [1:a];  %%ziad=deghat kam mishe
d2 = [1:1];
rand('state',0)
neuron = 10;   %%nabayad ziad kard kheili
%train
narx_net = narxnet(d1,d2,neuron);
% narx_net = newnarx(U_tr,Y_tr,d1,d2,neuron);
narx_net.trainParam.min_grad = 1e-3;
narx_net.trainParam.epochs = 10;
%narx_net.layers{1}.transferFcn='logsig';
narx_net.dividefcn = '';

[Xs,Xi,Ai,t] = preparets(narx_net,Utr,{},Ytr);


%view(narx_net)
narx_net = train(narx_net,Xs,t,Xi);
[Y,Xf,Af] = narx_net(Xs,Xi,Ai);
[netc,Xic,Aic] = closeloop(narx_net,Xf,Af);
% netb = train(netc,Xs,t,As);
%%
Y_hat = sim(narx_net,Xs,Xi);
%%
Er_tr = cell2mat(Y_hat)-cell2mat(t);

%test
Yts = con2seq(Ttest');
Uts = con2seq(Ptest');
[p_te,Pi_te,Ai_te,t_te] = preparets(narx_net,Uts,{},Yts);
Y_hat_Test = narx_net(p_te,Pi_te,Ai_te);
Er_te = cell2mat(Y_hat_Test)-cell2mat(t_te);
Y_hat_te = cell2mat(Y_hat_Test);
Yts = cell2mat(Yts);

ER_M_tr = mse (Er_tr);
ER_M_te = mse (Er_te);
%================================ NOE ====================================%
Yts = Yts';
Y_hat_te = Y_hat_te';
Uts=cell2mat(Uts);
Data_te = iddata (Yts(1:end-a,:),Uts(:,1:end-a)',3);

figure(1)
data2=iddata(Y_hat_te,Uts(:,1:end-a)',3);
compare(Data_te,data2)

figure(2)
e1=Er_te(1,:);
crosscorr(e1,e1,200)
title( 'crosscorr(e1,e1)')


