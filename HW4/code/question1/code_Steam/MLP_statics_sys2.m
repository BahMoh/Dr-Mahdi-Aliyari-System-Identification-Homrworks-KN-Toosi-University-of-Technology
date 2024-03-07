clc 
close all 
clear all

load steamgen.dat

nTest=1920; 
nTrain=6240;
U = steamgen(:,2:5);
Y = steamgen(:,6:9);
% Normalizing Data
U(:,1)=(U(:,1)-min(U(:,1)))/(max(U(:,1))-min(U(:,1)));
U(:,2)=(U(:,2)-min(U(:,2)))/(max(U(:,2))-min(U(:,2)));
U(:,3)=(U(:,3)-min(U(:,3)))/(max(U(:,3))-min(U(:,3)));
U(:,4)=(U(:,4)-min(U(:,4)))/(max(U(:,4))-min(U(:,4)));

Y(:,1)=(Y(:,1)-min(Y(:,1)))/(max(Y(:,1))-min(Y(:,1)));
Y(:,2)=(Y(:,2)-min(Y(:,2)))/(max(Y(:,2))-min(Y(:,2)));
Y(:,3)=(Y(:,3)-min(Y(:,3)))/(max(Y(:,3))-min(Y(:,3)));
Y(:,4)=(Y(:,4)-min(Y(:,4)))/(max(Y(:,4))-min(Y(:,4)));

Utr=U(1:6240,:);
Ytr=Y(1:6240,:);
Uts=U(6241:8160,:);
Yts=Y(6241:8160,:);
Uval=U(8161:end,:);
Yval=Y(8161:end,:);


P=Utr;
T=Ytr;
Ptest=Uts;

Ttest=Yts;

rand('state',0)

HiddenLayer_Neurons = 6;
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
data1=iddata(Ttest,Ptest)
data2=iddata(y_hat_test',Ptest)
data1=detrend(data1)
data2=detrend(data2)
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
