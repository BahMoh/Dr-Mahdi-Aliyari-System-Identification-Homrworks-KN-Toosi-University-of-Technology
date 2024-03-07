clc
close all
clear all
%% data
load steamgen
c=steamgen;
p=[c((166-2):(9600-2),2)';c((166-2):(9600-2),3)';c(166:9600,4)';c(1:(9600-165),4)';c((166-82):(9600-82),5)';c((166-13):(9600-13),6)';c((166-6):(9600-6),9)'];
T=c(166:9600,7)';
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
% %% figure
% figure
% plot(a2(1:3500))
% hold on
% plot(t2(1:3500),'r')
% figure
% plot(a3(1:500))
% hold on
% plot(t2(3501:4000),'r')
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