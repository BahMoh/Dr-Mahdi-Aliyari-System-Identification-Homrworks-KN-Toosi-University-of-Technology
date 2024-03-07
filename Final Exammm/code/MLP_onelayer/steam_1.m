clc
close all
clear all
%% data
load steamgen
c=steamgen;
p=[c((408-12):(9600-12),2)';c(408:9600,3)';c((408-97):(9600-97),3)';c(1:(9600-407),3)';c((408-7):(9600-7),4)';c((408-46):(9600-46),5)';c((408-9):(9600-9),9)'];
T=c(408:9600,6)';
% num_traindata=8000;
% num_testdata=1600;
num_traindata=3500;
num_testdata=4000;
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
% train
a2 = sim(net,p2(:,1:num_traindata));
e=a2-t2(1:num_traindata);
msetrain=mse(e)
% interpolate 
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