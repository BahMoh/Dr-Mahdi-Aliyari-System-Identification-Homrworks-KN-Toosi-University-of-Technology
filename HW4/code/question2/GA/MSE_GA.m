function MSE = mse_test(x)

load data
 

nTest=1891;
nTrain=4414;


for i=1:41
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
x=x+1;
P=[U1_tr(:,x(1)) U2_tr(:,x(2)) U3_tr(:,x(3)) Y1_tr(:,x(4)) Y2_tr(:,x(5)) Y3_tr(:,x(6))];
Ptest=[U1_ts(:,x(1)) U2_ts(:,x(2)) U3_ts(:,x(3)) Y1_ts(:,x(4)) Y2_ts(:,x(5)) Y3_ts(:,x(6))];
T=[Ytr1 Ytr2 Ytr3];
Ttest=[Yts1 Yts2 Yts3];
epoch=10;
rand('state',0)
neron = 10;
out=3;
W1 = rand(neron,6);
B1 = rand(neron,1);
W2 = rand(out,neron);
B2 = rand(out,1);
net = newff(minmax(P') , [neron out], {'logsig' 'purelin'});
net = init(net);
net.iw{1,1} = W1;
net.b{1} = B1;
net.lw{2,1} = W2;
net.b{2} = B2;
net.trainFcn = 'trainlm';
net.trainParam.epochs = 10;
net.trainParam.lr = 0.01;
net = train(net , P' , T');
y_hat_train = sim(net , P');
y_hat_test = sim(net,Ptest');
e = -y_hat_test + Ttest';

MSE = mse(e);
end