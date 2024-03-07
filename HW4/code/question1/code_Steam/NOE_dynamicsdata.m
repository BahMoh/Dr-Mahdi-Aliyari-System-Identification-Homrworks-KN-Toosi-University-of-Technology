clc;
clear all;
close all;
warning off

load steamgen.dat
T = steamgen(:,1)'; 
U = steamgen(:,2:5)';
Y = steamgen(:,6:9)';
% Normalize data
a = 0;
b = 1;
for i = 1:4
U(i,:) = a+(b-a)*((U(i,:)-min(U(i,:)))/(max(U(i,:))-min(U(i,:))));
end
for i = 1:4
Y(i,:) = a+(b-a)*((Y(i,:)-min(Y(i,:)))/(max(Y(i,:))-min(Y(i,:))));
end
%  Test and Train Data
N = length(steamgen);
Utr=U(:,1:6240)';
Uts=U(:,6241:8160)';
Ytr=Y(:,1:6240)';
Yts=Y(:,6241:8160)';
%%
nTest=1920;
nTrain=6240;
for i=1:89
    U1_tr(:,i)=[zeros(i,1); Utr(1:nTrain-i,1)];
    U2_tr(:,i)=[zeros(i,1); Utr(1:nTrain-i,2)];
    U3_tr(:,i)=[zeros(i,1); Utr(1:nTrain-i,3)];
    U4_tr(:,i)=[zeros(i,1); Utr(1:nTrain-i,4)];
    Y1_tr(:,i)=[zeros(i,1); Ytr(1:nTrain-i,1)];
    Y2_tr(:,i)=[zeros(i,1); Ytr(1:nTrain-i,2)];
    Y3_tr(:,i)=[zeros(i,1); Ytr(1:nTrain-i,3)];
    Y4_tr(:,i)=[zeros(i,1); Ytr(1:nTrain-i,4)];
    U1_ts(:,i)=[zeros(i,1); Uts(1:nTest-i,1)];
    U2_ts(:,i)=[zeros(i,1); Uts(1:nTest-i,2)];
    U3_ts(:,i)=[zeros(i,1); Uts(1:nTest-i,3)];
    U4_ts(:,i)=[zeros(i,1); Uts(1:nTest-i,4)];
    Y1_ts(:,i)=[zeros(i,1); Yts(1:nTest-i,1)];
    Y2_ts(:,i)=[zeros(i,1); Yts(1:nTest-i,2)];
    Y3_ts(:,i)=[zeros(i,1); Yts(1:nTest-i,3)];
    Y4_ts(:,i)=[zeros(i,1); Yts(1:nTest-i,4)];
end
%%
P=[ U1_tr(:,3) U1_tr(:,4)...
    U2_tr(:,3)...
    U3_tr(:,14)...
    U4_tr(:,4) U4_tr(:,87)...
    Y1_tr(:,1)...
    Y2_tr(:,1) Y2_tr(:,7)...
    Y3_tr(:,1)...
    Y4_tr(:,1)];
T=Ytr;
Ptest=[ U1_ts(:,3) U1_ts(:,4)...
    U2_ts(:,3)...
    U3_ts(:,14)...
    U4_ts(:,4) U4_ts(:,87)...
    Y1_ts(:,1)...
    Y2_ts(:,1) Y2_ts(:,7)...
    Y3_ts(:,1)...
    Y4_ts(:,1)];
Ttest=Yts;
%================================ NOE ====================================%
Ytr = con2seq(T');
Utr = con2seq(P');
a=1;
d1 = [1:a];  %%ziad=deghat kam mishe
d2 = [1:1];
rand('state',0)
neuron = 5;   %%nabayad ziad kard kheili
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
crosscorr(e1,e1)
title( 'crosscorr(e1,e1)')
figure(3)
e2=Er_te(2,:);
crosscorr(e2,e2)
title( 'crosscorr(e2,e2)')
figure(4)
e3=Er_te(3,:);
crosscorr(e3,e3)
title( 'crosscorr(e3,e3)')

figure(5)
e4=Er_te(4,:);
crosscorr(e4,e4)
title( 'crosscorr(e4,e4)')

