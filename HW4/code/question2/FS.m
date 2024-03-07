clc 
close all  
clear all

load data

nTest=1891;
nTrain=4414;

for i=1:21
    U1_tr(:,i)=[zeros(i,1); Utr1(1:nTrain-i,1)];
    U2_tr(:,i)=[zeros(i,1); Utr2(1:nTrain-i,1)];
    U3_tr(:,i)=[zeros(i,1); Utr3(1:nTrain-i,1)];
    Y1_tr(:,i)=[zeros(i,1); Ytr1(1:nTrain-i,1)];
    Y2_tr(:,i)=[zeros(i,1); Ytr2(1:nTrain-i,1)];
    Y3_tr(:,i)=[zeros(i,1); Ytr3(1:nTrain-i,1)];
    U1_ts(:,i)=[zeros(i,1); Uts1(1:nTest-i,1)];
    U2_ts(:,i)=[zeros(i,1); Uts2(1:nTest-i,1)];
    U3_ts(:,i)=[zeros(i,1); Uts3(1:nTest-i,1)];
    Y1_ts(:,i)=[zeros(i,1); Yts1(1:nTest-i,1)];
    Y2_ts(:,i)=[zeros(i,1); Yts2(1:nTest-i,1)];
    Y3_ts(:,i)=[zeros(i,1); Yts3(1:nTest-i,1)];
end


P=[ U1_tr(:,5) U1_tr(:,8) U1_tr(:,10) U1_tr(:,16) U1_tr(:,19) U2_tr(:,1)    U2_tr(:,3)    U2_tr(:,4)    U2_tr(:,7)    U2_tr(:,8)    U2_tr(:,10)    U2_tr(:,14)    U2_tr(:,15)    U2_tr(:,18)    U2_tr(:,20)    U3_tr(:,2)    U3_tr(:,5)    U3_tr(:,6)    U3_tr(:,8)    U3_tr(:,9)    U3_tr(:,10)    U3_tr(:,14)    U3_tr(:,16)    U3_tr(:,18)    U3_tr(:,19)    Y1_tr(:,1)  Y1_tr(:,2)    Y2_tr(:,1)    Y2_tr(:,4)    Y2_tr(:,15)    Y3_tr(:,1)    Y3_tr(:,20)];
T=[Ytr1 Ytr2 Ytr3];
Ptest=[ U1_ts(:,5)    U1_ts(:,8)    U1_ts(:,10)    U1_ts(:,16)    U1_ts(:,19)    U2_ts(:,1)    U2_ts(:,3)    U2_ts(:,4)    U2_ts(:,7)    U2_ts(:,8)    U2_ts(:,10)    U2_ts(:,14)    U2_ts(:,15)    U2_ts(:,18)    U2_ts(:,20)    U3_ts(:,2)    U3_ts(:,5)    U3_ts(:,6)    U3_ts(:,8)    U3_ts(:,9)    U3_ts(:,10)    U3_ts(:,14)    U3_ts(:,16)    U3_ts(:,18)    U3_ts(:,19)    Y1_ts(:,1)  Y1_ts(:,2)   Y2_ts(:,1)    Y2_ts(:,4)    Y2_ts(:,15)    Y3_ts(:,1)    Y3_ts(:,20)];
Ttest=[Yts1 Yts2 Yts3];
epoch=10;
rand('state',0)
neron = 10;
out=3;
for h = 1:32
    W1 = rand(neron,1);
    B1 = rand(neron,1);
    W2 = rand(out,neron);
    B2 = rand(out,1);
    net = newff(minmax(P(:,h)') , [neron out], {'logsig' 'purelin'});
    net = init(net);
    net.iw{1,1} = W1;
    net.b{1} = B1;
    net.lw{2,1} = W2;
    net.b{2} = B2;
    net.trainFcn = 'trainlm';
    net.trainParam.epochs = 10;
    net.trainParam.lr = 0.01;
    net = train(net , P(:,h)' , T');
    y_hat_train = sim(net , P(:,h)');
    y_hat_test = sim(net,Ptest(:,h)');
    e2 = -y_hat_test + Ttest';
    E1(h) = mse(e2);
end
Dyna=1:1:32;
E_Total(1)=min(E1);
[a(1),b]=min(E1);
Reg(1)=Dyna(b);
Dyna(b)=[];
DynaFix=P(:,b);
P(:,b) = [];
DynaFix_test = Ptest(:,b)
Ptest(:,b) = [];
for i=1:31
   
rand('state',0)
for h = 1:32-i
    W1 = rand(neron,i+1);
    B1 = rand(neron,1);
    W2 = rand(3,neron);
    B2 = rand(3,1);
    net = newff(minmax([DynaFix';P(:,h)']) , [neron 3], {'logsig' 'purelin'});
    net = init(net);
    net.iw{1,1} = W1;
    net.b{1} = B1;
    net.lw{2,1} = W2;
    net.b{2} = B2;
    net.trainFcn = 'trainlm';
    net.trainParam.epochs = 10;
    net.trainParam.lr = 0.01;
    net = train(net , [DynaFix';P(:,h)'] , T');
    y_hat_train = sim(net ,[DynaFix';P(:,h)']);
    y_hat_test = sim(net,[DynaFix_test';Ptest(:,h)']);
    e2 = -y_hat_test + Ttest';
    E2(h) = mse(e2);
end
E_Total(i+1)=min(E2);

[a(i+1),b]=min(E2);
Reg(i+1)=Dyna(b);
Dyna(b)=[];
DynaFix=[DynaFix P(:,b)];
DynaFix_test=[DynaFix_test Ptest(:,b)];
P(:,b) = [];
Ptest(:,b) = [];
if(h>1)
E2=zeros(1,h-1)
end
end


figure(1)
plot(E_Total)
xlabel('shomare marhale')
ylabel('minimum khata')

figure(2)
plot(Reg)
xlabel('shomare marhale')
ylabel('regresore entekhab Shode')
