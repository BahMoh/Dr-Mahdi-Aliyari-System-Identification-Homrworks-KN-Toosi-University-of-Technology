close all 
clear all 
clc


load ballbeam.dat
U = ballbeam(:,1)';
Y = ballbeam(:,2)'; 
% Normalizing Data 

a = 0;
b = 1;
for i = 1:1
U(i,:) = a+(b-a)*((U(i,:)-min(U(i,:)))/(max(U(i,:))-min(U(i,:))));
end
for i = 1:1
Y(i,:) = a+(b-a)*((Y(i,:)-min(Y(i,:)))/(max(Y(i,:))-min(Y(i,:))));
end
%  Test and Train Data
N = length(ballbeam);
U_tr=U(:,1:650);
U_te=U(:,651:end);
Y_tr=Y(:,1:650);
Y_te=Y(:,651:end);

%================================ NOE ====================================%
Y_tr = con2seq(Y_tr);
U_tr = con2seq(U_tr);
a=1;
d1 = [1:a];  %%ziad=deghat kam mishe
d2 = [1:1];
rand('state',0)

neuron = 5;  %%nabayad ziad kard kheili
%train
narx_net = narxnet(d1,d2,neuron);
% narx_net = newnarx(U_tr,Y_tr,d1,d2,neuron);
narx_net.trainParam.min_grad = 1e-3;
narx_net.trainParam.epochs = 10;
%narx_net.layers{1}.transferFcn='logsig';
narx_net.dividefcn = '';
[Xs,Xi,Ai,t] = preparets(narx_net,U_tr,{},Y_tr);


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
Y_te = con2seq(Y_te);
U_te = con2seq(U_te);
[p_te,Pi_te,Ai_te,t_te] = preparets(narx_net,U_te,{},Y_te);
Y_hat_Test = narx_net(p_te,Pi_te,Ai_te);
Er_te = cell2mat(Y_hat_Test)-cell2mat(t_te);
Y_hat_te = cell2mat(Y_hat_Test);
Y_te = cell2mat(Y_te);

ER_M_tr = mse (Er_tr);
ER_M_te = mse (Er_te);
%================================ NOE ====================================%
Y_te = Y_te';
Y_hat_te = Y_hat_te';
U_te=cell2mat(U_te);
Data_te = iddata (Y_te(1:end-a,:),U_te(:,1:end-a)',3);

figure(1)
data2=iddata(Y_hat_te,U_te(:,1:end-a)',3);
compare(Data_te,data2)

figure(2)
e1=Er_te(1,:);
crosscorr(e1,e1,100)
title( 'crosscorr(e1,e1)')

