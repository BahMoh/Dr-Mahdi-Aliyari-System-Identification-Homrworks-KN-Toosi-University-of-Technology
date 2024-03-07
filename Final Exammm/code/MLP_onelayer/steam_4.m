clc
close all
clear all
%% data
load steamgen
c=steamgen;
p=[c((87-7):(9600-7),2)';c(87:9600,3)';c(87:9600,4)';c((87-1):(9600-1),5)';c((1):(9600-86),5)';c((87-9):(9600-9),6)';c((87-6):(9600-6),7)';c((87-49):(9600-49),8)'];
T=c(87:9600,9)';
num_traindata=3500;
num_testdata=4000;
% num_traindata=8000;
% num_testdata=1600;
%% normalizing
[p2,ps] = mapminmax(p);
[t2,ts] = mapminmax(T);
%% newff
m=25;
epochs =150;
net=newff(minmax(p2),[20 1],{'tansig'   'purelin'},'trainlm')
net.trainParam.epochs = epochs;
net.trainParam.lr=0.00001;
[net,tr]=train(net,p2(:,1:num_traindata),t2(1:num_traindata));
a2 = sim(net,p2(:,1:num_traindata));
e=a2-t2(1:num_traindata);
msetrain=mse(e)
a3 = sim(net,p2(:,(num_traindata+1):num_testdata));
e1=a3-t2((num_traindata+1):num_testdata);
msetest=mse(e1)
%% figure
figure
plot(a2(1:3500))
hold on
plot(t2(1:3500),'r')
title("train")
legend("network output","real system")
figure
plot(a3(1:500))
title("extrapolate")
hold on
plot(t2(3501:4000),'r')