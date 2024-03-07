function MSE = MSE_sys2(x)

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

%%
for i=1:3
    U1_tr(:,i)=[zeros(i,1); Utr(1:nTrain-i,1)];
    Y1_tr(:,i)=[zeros(i,1); Ytr(1:nTrain-i,1)];
    U1_ts(:,i)=[zeros(i,1); Uts(1:nTest-i,1)];
    Y1_ts(:,i)=[zeros(i,1); Yts(1:nTest-i,1)];

end

P=[ U1_tr(:,1) U1_tr(:,2) U1_tr(:,3)  Y1_tr(:,1) Y1_tr(:,2) Y1_tr(:,3)];
T=Ytr;
Ptest=[U1_ts(:,1) U1_ts(:,2) U1_ts(:,3) Y1_ts(:,1) Y1_ts(:,2) Y1_ts(:,3)];
Ttest=Yts;
epoch=30;
rand('state',0)

HiddenLayer_Neurons = 4;
net = newff(P',T',[HiddenLayer_Neurons],{'tansig','purelin'},'trainlm','learngd','mse');

net.trainParam.epochs = 30;
net.trainParam.lr = 0.01;

net.dividefcn = '';
ref_mse = inf;
for cnt = 1:1              % Training 10 times NN by all the trn data and choosing the best
    net = init(net);        % Initializing network
    [net,tr_record] = train(net,P',T');
    if tr_record.perf(end) < ref_mse
        ref_mse = tr_record.perf(end);
        final_net = net;
        trn_final_record = tr_record;
    end
end
save Data_Part_1_A
%%
load Data_Part_1_A
close all
    y_hat_train = sim(final_net , P');
    y_hat_test = sim(final_net,Ptest');
    e1 = -y_hat_train + T';
    e = -y_hat_test + Ttest';
 
MSE=mse(e)
end


