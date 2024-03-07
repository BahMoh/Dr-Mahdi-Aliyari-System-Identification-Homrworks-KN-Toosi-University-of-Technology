clc
clear all
close all


load data_steamgen

Utr1 = (utr1-min(utr1))/(max(utr1)-min(utr1)); 
Utr2 = (utr2-min(utr2))/(max(utr2)-min(utr2));
Utr3 = (utr3-min(utr3))/(max(utr3)-min(utr3));
Utr4 = (utr4-min(utr4))/(max(utr4)-min(utr4));

Ytr1 = (ytr1-min(ytr1))/(max(ytr1)-min(ytr1));
Ytr2 = (ytr2-min(ytr2))/(max(ytr2)-min(ytr2));
Ytr3 = (ytr3-min(ytr3))/(max(ytr3)-min(ytr3));
Ytr4 = (ytr4-min(ytr4))/(max(ytr4)-min(ytr4));

Uts1 = (uts1-min(uts1))/(max(uts1)-min(uts1));
Uts2 = (uts2-min(uts2))/(max(uts2)-min(uts2));
Uts3 = (uts3-min(uts3))/(max(uts3)-min(uts3));
Uts4 = (uts4-min(uts4))/(max(uts4)-min(uts4));

Yts1 = (yts1-min(yts1))/(max(yts1)-min(yts1));
Yts2 = (yts2-min(yts2))/(max(yts2)-min(yts2));
Yts3 = (yts3-min(yts3))/(max(yts3)-min(yts3));
Yts4 = (yts4-min(yts4))/(max(yts4)-min(yts4));

Uval1 = (uval1-min(uval1))/(max(uval1)-min(uval1));
Uval2 = (uval2-min(uval2))/(max(uval2)-min(uval2));
Uval3 = (uval3-min(uval3))/(max(uval3)-min(uval3));
Uval4 = (uval4-min(uval4))/(max(uval4)-min(uval4));

Yval1 = (yval1-min(yval1))/(max(yval1)-min(yval1));
Yval2 = (yval2-min(yval2))/(max(yval2)-min(yval2));
Yval3 = (yval3-min(yval3))/(max(yval3)-min(yval3));
Yval4 = (yval4-min(yval4))/(max(yval4)-min(yval4));
nTest=1920;
nTrain=6240;
nVal=1440;
for i=1:89 %%limit of dynamic
    U1_tr(:,i)=[zeros(i,1); Utr1(1:nTrain-i,1)];
    U2_tr(:,i)=[zeros(i,1); Utr2(1:nTrain-i,1)];
    U3_tr(:,i)=[zeros(i,1); Utr3(1:nTrain-i,1)];
    U4_tr(:,i)=[zeros(i,1); Utr4(1:nTrain-i,1)];
    
    Y1_tr(:,i)=[zeros(i,1); Ytr1(1:nTrain-i,1)];
    Y2_tr(:,i)=[zeros(i,1); Ytr2(1:nTrain-i,1)];
    Y3_tr(:,i)=[zeros(i,1); Ytr3(1:nTrain-i,1)];
    Y4_tr(:,i)=[zeros(i,1); Ytr4(1:nTrain-i,1)];
    
    U1_ts(:,i)=[zeros(i,1); Uts1(1:nTest-i,1)];
    U2_ts(:,i)=[zeros(i,1); Uts2(1:nTest-i,1)];
    U3_ts(:,i)=[zeros(i,1); Uts3(1:nTest-i,1)];
    U4_ts(:,i)=[zeros(i,1); Uts4(1:nTest-i,1)];
    
    Y1_ts(:,i)=[zeros(i,1); Yts1(1:nTest-i,1)];
    Y2_ts(:,i)=[zeros(i,1); Yts2(1:nTest-i,1)];
    Y3_ts(:,i)=[zeros(i,1); Yts3(1:nTest-i,1)];
    Y4_ts(:,i)=[zeros(i,1); Yts4(1:nTest-i,1)];
    
    U1_val(:,i)=[zeros(i,1); Uval1(1:nVal-i,1)];
    U2_val(:,i)=[zeros(i,1); Uval2(1:nVal-i,1)];
    U3_val(:,i)=[zeros(i,1); Uval3(1:nVal-i,1)];
    U4_val(:,i)=[zeros(i,1); Uval4(1:nVal-i,1)];
    
    Y1_val(:,i)=[zeros(i,1); Yval1(1:nVal-i,1)];
    Y2_val(:,i)=[zeros(i,1); Yval2(1:nVal-i,1)];
    Y3_val(:,i)=[zeros(i,1); Yval3(1:nVal-i,1)];
    Y4_val(:,i)=[zeros(i,1); Yval4(1:nVal-i,1)];
end 

Dynamics=[41    41     2    41     1     1     1     1];

%Dynamics=[48    45    23    36    17     2     8     8];
%Dynamics=[18    18    73    21    12     2    10     5];  


P=[ U1_tr(:,Dynamics(1)) U2_tr(:,Dynamics(2))    U3_tr(:,Dynamics(3)) U4_tr(:,Dynamics(4))...
    Y1_tr(:,Dynamics(5))    Y2_tr(:,Dynamics(6))        Y3_tr(:,Dynamics(7)) Y4_tr(:,Dynamics(8))  ];

T=[Ytr1 Ytr2 Ytr3 Ytr4];

Ptest=[ U1_ts(:,Dynamics(1)) U2_ts(:,Dynamics(2))    U3_ts(:,Dynamics(3)) U4_ts(:,Dynamics(4))...
        Y1_ts(:,Dynamics(5))  Y2_ts(:,Dynamics(6))         Y3_ts(:,Dynamics(7)) Y4_ts(:,Dynamics(8)) ];
    
Ttest=[Yts1 Yts2 Yts3 Yts4];

rand('state',0);
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
data1=iddata(Ttest,Ptest,3);
data2=iddata(y_hat_test',Ptest,3);
compare(data1,data2)

figure(2)
e1=e(1,:);
crosscorr(e1,e1)
title( 'crosscorr(e1,e1)')
figure(3)
e2=e(2,:);
crosscorr(e2,e2)
title( 'crosscorr(e2,e2)')
figure(4)
e3=e(3,:);
crosscorr(e3,e3)
title( 'crosscorr(e3,e3)')
figure(5)
e4=e(4,:);
crosscorr(e4,e4)
title( 'crosscorr(e4,e4)')

