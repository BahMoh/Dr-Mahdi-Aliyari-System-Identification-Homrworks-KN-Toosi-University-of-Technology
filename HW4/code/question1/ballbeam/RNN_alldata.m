% Data Generating for system 2
clear; clc; close all;

load ballbeam.dat
data=ballbeam;

for i=1:2
    data(:,i)=(data(:,i)-min(data(:,i)))/(max(data(:,i))-min(data(:,i))); 
end

u1 = data(:,1)';
y = data(:,2)';

intraindata = [u1(1,1:650)];
intestdata = [u1(1,651:end)];
outtraindata = y(:,1:650);
outtestdata = y(:,651:end);
%%
rand('state',0)

net = newelm(intraindata,outtraindata,10,{});

net.layers{1}.transferFcn = 'tansig';
net.dividefcn = '';
net.trainFcn = 'trainlm';
net.trainParam.epochs=50;
net.trainParam.lr = 0.01;

[net , tr]= train(net,intraindata,outtraindata);
%%
ytest = sim(net,intestdata);
ytrain = sim(net,intraindata);
perf = perform(net,ytest,outtestdata);
e = outtestdata - ytest;

data1=iddata(outtestdata',intestdata',0.1)
data2=iddata(ytest',intestdata',0.1)

figure(1)
compare(data1,data2)
figure(2)
e1=e(1,:)
crosscorr(e1,e1,100)
title( 'crosscorr(e1,e1)')

