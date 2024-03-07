clc
clear all
close all

load ballbeam.dat

nTest=350;
nTrain=650;
U = ballbeam(:,1); 
Y = ballbeam(:,2);
%% Normalizing Data
U(:,1)=(U(:,1)-min(U(:,1)))/(max(U(:,1))-min(U(:,1)));

Y(:,1)=(Y(:,1)-min(Y(:,1)))/(max(Y(:,1))-min(Y(:,1)));


Utr=U(1:650,:);
Ytr=Y(1:650,:);
Uts=U(651:end,:);
Yts=Y(651:end,:);

for i=1:10 
    U1_tr(:,i)=[zeros(i,1); Utr(1:nTrain-i,1)];
    Y1_tr(:,i)=[zeros(i,1); Ytr(1:nTrain-i,1)];
    U1_ts(:,i)=[zeros(i,1); Uts(1:nTest-i,1)];
    Y1_ts(:,i)=[zeros(i,1); Yts(1:nTest-i,1)];

end 

Dynamics=[5 2];


P=[ U1_tr(:,Dynamics(1)) Y1_tr(:,Dynamics(2)) ];

T=[Ytr];

Ptest=[U1_ts(:,Dynamics(1)) Y1_ts(:,Dynamics(2))];

    
Ttest=[Yts];

rand('state',0);
neron = 6;
out=4;
HiddenLayer_Neurons = 4;
net = newff(P',T',[HiddenLayer_Neurons],{'tansig','purelin'},'trainlm','learngd','mse');

net.trainParam.epochs = 30;
net.trainParam.lr = 0.01;

net.dividefcn = '';
ref_mse = inf;
for cnt = 1:10              % Training 10 times NN by all the trn data and choosing the best
    net = init(net);        % Initializing network
    [net,tr_record] = train(net,P',T');
    if tr_record.perf(end) < ref_mse
        ref_mse = tr_record.perf(end);
        final_net = net;
        trn_final_record = tr_record;
    end
end
save Data_Part_1_A
%     W1 = rand(neron,8);
%     B1 = rand(neron,1);
%     W2 = rand(out,neron);
%     B2 = rand(out,1);
%     net = newff(minmax(P') , [neron out], {'tansig' 'purelin'});
%     net = init(net);
%     net.iw{1,1} = W1;
%     net.b{1} = B1;
%     net.lw{2,1} = W2;
%     net.b{2} = B2;
%     net.trainFcn = 'trainlm';
%     net.trainParam.epochs = 30;
%     net.trainParam.lr = 0.01;
%     net = train(net , P' , T');

%%
load Data_Part_1_A
close all
    y_hat_train = sim(final_net , P');
    y_hat_test = sim(final_net,Ptest');
    e = -y_hat_test + Ttest';
    E1 = mse(e);


figure(1)
data1=iddata(Ttest,Ptest,0.1);
data2=iddata(y_hat_test',Ptest,0.1);
compare(data1,data2)

figure(2)
e1=e(1,:);
crosscorr(e1,e1,100)
title( 'crosscorr(e1,e1)')


