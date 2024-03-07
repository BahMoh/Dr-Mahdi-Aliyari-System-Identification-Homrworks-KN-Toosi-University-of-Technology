function MSE = MSE_sys1(x)

load ballbeam.dat
u1=ballbeam(:,1);
y1=ballbeam(:,2);

%% output1

% figure 
% crosscorr(u1,y1)
% title('Corrolation(u1,y1)')
% figure
% crosscorr(u1,y2)
% title('Corrolation(u1,y2)')
% 
% figure
% crosscorr(y1,y2)
% title('Corrolation(y1,y2)')
%%
nTest=350;
nTrain=650;
n=1000;
u1=(u1-min(u1))/(max(u1)-min(u1));
y1=(y1-min(y1))/(max(y1)-min(y1));
for i=1:3
    u1(:,i)=[zeros(i,1); u1(1:n-i,1)];
    y1(:,i)=[zeros(i,1); y1(1:n-i,1)];
end
u1_tr=u1(1:nTrain,:);
u1_ts=u1(nTrain+1:end,:);

y1_tr=y1(1:nTrain,:);
y1_ts=y1(nTrain+1:end,:);

%%
y1tr=ballbeam(1:nTrain,2);
y1ts=ballbeam(nTrain+1:end,2);

x=x+1;

P=[u1_tr(:,x(1)) u1_tr(:,x(2)) u1_tr(:,x(3)) y1_tr(:,x(4)) y1_tr(:,x(5)) y1_tr(:,x(6))];
T=[y1tr];

Ptest=[u1_ts(:,x(1)) u1_ts(:,x(2)) u1_ts(:,x(3)) y1_ts(:,x(4)) y1_ts(:,x(5)) y1_ts(:,x(6))];
Ttest=[y1ts];

rand('state',0)
neron = 4;
out=1;
W1 = rand(neron,6);
B1 = rand(neron,1);
W2 = rand(out,neron);
B2 = rand(out,1);
net = newff(minmax(P') , [neron out], {'tansig' 'purelin'});
net = init(net);
net.iw{1,1} = W1;
net.b{1} = B1;
net.lw{2,1} = W2;
net.b{2} = B2;
net.trainFcn = 'trainlm';
net.trainParam.epochs = 30;
net.trainParam.lr = 0.01;
net = train(net , P' , T');
y_hat_train = sim(net , P');
y_hat_test = sim(net,Ptest');
e = -y_hat_test + Ttest';

MSE = mse(e);
end