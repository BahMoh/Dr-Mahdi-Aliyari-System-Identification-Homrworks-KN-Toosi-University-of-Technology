clc 
close all 
clear all

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
P=Utr;
T=Ytr;
Ptest=Uts;
Ttest=Yts;
epoch=30;
rand('state',0)

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
%%
load Data_Part_1_A
close all
    y_hat_train = sim(final_net , P');
    y_hat_test = sim(final_net,Ptest');
    e1 = -y_hat_train + T';
    e = -y_hat_test + Ttest';
 
% figure(5)
% plot(E2,':or'); hold on ; plot(E1,':ob')
% legend('Train','Test'); xlabel('Neuron'); ylabel('MSE'); grid on

figure(1)
data1=iddata(Ttest,Ptest,0.1)
data2=iddata(y_hat_test',Ptest,0.1)
data1=detrend(data1)
data2=detrend(data2)

compare(data1,data2)
title('test data')
figure(2)
e1=e(1,:)
crosscorr(e1,e1,100)
title( 'crosscorr(e1,e1)')


