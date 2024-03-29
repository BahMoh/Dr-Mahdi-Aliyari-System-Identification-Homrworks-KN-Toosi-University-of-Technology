clc 
close all 
clear all

load steamgen.dat

nTest=1920;
nTrain=6240; 
U = steamgen(:,2:5);
Y = steamgen(:,6:9);
%% Normalizing Data
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
%%
for i=1:89
    U1_tr(:,i)=[zeros(i,1); Utr(1:nTrain-i,1)];
    U2_tr(:,i)=[zeros(i,1); Utr(1:nTrain-i,2)];
    U3_tr(:,i)=[zeros(i,1); Utr(1:nTrain-i,3)];
    U4_tr(:,i)=[zeros(i,1); Utr(1:nTrain-i,4)];
    
    Y1_tr(:,i)=[zeros(i,1); Ytr(1:nTrain-i,1)];
    Y2_tr(:,i)=[zeros(i,1); Ytr(1:nTrain-i,2)];
    Y3_tr(:,i)=[zeros(i,1); Ytr(1:nTrain-i,3)];
    Y4_tr(:,i)=[zeros(i,1); Ytr(1:nTrain-i,4)];
    
    U1_ts(:,i)=[zeros(i,1); Uts(1:nTest-i,1)];
    U2_ts(:,i)=[zeros(i,1); Uts(1:nTest-i,2)];
    U3_ts(:,i)=[zeros(i,1); Uts(1:nTest-i,3)];
    U4_ts(:,i)=[zeros(i,1); Uts(1:nTest-i,4)];
    
    Y1_ts(:,i)=[zeros(i,1); Yts(1:nTest-i,1)];
    Y2_ts(:,i)=[zeros(i,1); Yts(1:nTest-i,2)];
    Y3_ts(:,i)=[zeros(i,1); Yts(1:nTest-i,3)];
    Y4_ts(:,i)=[zeros(i,1); Yts(1:nTest-i,4)];
end

P=[ U1_tr(:,3) U1_tr(:,4)  U1_tr(:,8)  U1_tr(:,13) U1_tr(:,47)...
    U2_tr(:,3) U2_tr(:,87) U2_tr(:,88) U2_tr(:,89)...
    U3_tr(:,8) U3_tr(:,14) U3_tr(:,82) U3_tr(:,85)...
    U4_tr(:,2) U4_tr(:,4)  U4_tr(:,33) U4_tr(:,47) U4_tr(:,82) U4_tr(:,87)...
    Y1_tr(:,1) Y1_tr(:,10) Y2_tr(:,72)...
    Y2_tr(:,1) Y2_tr(:,7)  Y2_tr(:,14) Y2_tr(:,44)...
    Y3_tr(:,1) Y3_tr(:,27) Y3_tr(:,44) Y3_tr(:,48) Y3_tr(:,50) Y3_tr(:,81)...
    Y4_tr(:,1) Y4_tr(:,34)];
T=Ytr;
Ptest=[ U1_ts(:,3) U1_ts(:,4)  U1_ts(:,8)  U1_ts(:,13) U1_ts(:,47)...
        U2_ts(:,3) U2_ts(:,87) U2_ts(:,88) U2_ts(:,89)...
        U3_ts(:,8) U3_ts(:,14) U3_ts(:,82) U3_ts(:,85)...
        U4_ts(:,2) U4_ts(:,4)  U4_ts(:,33) U4_ts(:,47) U4_ts(:,82) U4_ts(:,87)...
        Y1_ts(:,1) Y1_ts(:,10) Y2_ts(:,72)...
        Y2_ts(:,1) Y2_ts(:,7)  Y2_ts(:,14) Y2_ts(:,44)...
        Y3_ts(:,1) Y3_ts(:,27) Y3_ts(:,44) Y3_ts(:,48) Y3_ts(:,50) Y3_ts(:,81)...
        Y4_ts(:,1) Y4_ts(:,34)];
Ttest=Yts;
epoch=30;
rand('state',0)
neron = 6;
out=4;
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
    E1(neron) = mse(e);
    E2(neron) = mse(e1);
% figure(5)
% plot(E2,':or'); hold on ; plot(E1,':ob')
% legend('Train','Test'); xlabel('Neuron'); ylabel('MSE'); grid on

figure(1)
data1=iddata(Ttest,Ptest,3)
data2=iddata(y_hat_test',Ptest,3)
compare(data1,data2)

figure(2)
e1=e(1,:)
crosscorr(e1,e1)
title( 'crosscorr(e1,e1)')
figure(3)
e2=e(2,:)
crosscorr(e2,e2)
title( 'crosscorr(e2,e2)')
figure(4)
e3=e(3,:)
crosscorr(e3,e3)
title( 'crosscorr(e3,e3)')
figure(5)
e4=e(4,:)
crosscorr(e4,e4)
title( 'crosscorr(e4,e4)')

