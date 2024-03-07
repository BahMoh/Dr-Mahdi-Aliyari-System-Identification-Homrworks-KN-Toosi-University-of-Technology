% Data Generating for system 2
clear; clc; close all;

load steamgen.dat 
data=steamgen;

for i=2:9
    data(:,i)=(data(:,i)-min(data(:,i)))/(max(data(:,i))-min(data(:,i)));
end

u1 = data(:,2)';
u2 = data(:,3)';
u3 = data(:,4)';
u4 = data(:,5)';
y = data(:,6:9)';

intraindata = [u1(1,1:6240);u2(1,1:6240);u3(1,1:6240);u4(1,1:6240)];
intestdata = [u1(1,6241:8160);u2(1,6241:8160);u3(1,6241:8160);u4(1,6241:8160)];
outtraindata = y(:,1:6240);
outtestdata = y(:,6241:8160);
%%
rand('state',0)

net = newelm(intraindata,outtraindata,10,{});

net.layers{1}.transferFcn = 'tansig';
net.dividefcn = '';
net.trainFcn = 'trainlm';
net.trainParam.epochs=150;
net.trainParam.lr = 0.01;

[net , tr]= train(net,intraindata,outtraindata);
%%
ytest = sim(net,intestdata);
ytrain = sim(net,intraindata);
perf = perform(net,ytest,outtestdata);
e = outtestdata - ytest;

data1=iddata(outtestdata',intestdata',3)
data2=iddata(ytest',intestdata',3)

figure(1)
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
