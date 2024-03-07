clc
clear
close all
load( 'Data' );
total_P=[GS PA WS];  
total_T=[TM];

%% Normalize input data

total_P(:,1)=(total_P(:,1)-min(total_P(:,1)))/(max(total_P(:,1))-min(total_P(:,1)));
total_P(:,2)=(total_P(:,2)-min(total_P(:,2)))/(max(total_P(:,2))-min(total_P(:,2)));
total_P(:,3)=(total_P(:,3)-min(total_P(:,3)))/(max(total_P(:,3))-min(total_P(:,3)));

total_T=(total_T-min(total_T))/(max(total_T)-min(total_T));

total_P=total_P';
total_T=total_T';

P=total_P(:,1:233);
T=total_T(:,1:233);

Ptest=total_P(:,234:367);
Ttest=total_T(:,234:367);

Pvalid=total_P(:,367:end);
Tvalid=total_T(:,367:end);

rand('state',0)
%%
in=3;
out=1;
neron = 5;
W1 = rand(neron,in);
B1 = rand(neron,1);
W2 = rand(out,neron);
B2 = rand(out,1);

%%


for epoch = 1:400

    net = newff(minmax(P) , [neron out], {'tansig' 'purelin'});
    net = init(net);
    net.iw{1,1} = W1;
    net.b{1} = B1;
    net.lw{2,1} = W2;
    net.b{2} = B2;
    net.trainFcn = 'trainlm';
    net.trainParam.epochs = epoch;
    net.dividefcn = '';
    net.trainParam.lr = 0.01;
    net = train(net , P , T);
    y_hat_train = sim(net , P);
    e1 = T - y_hat_train;
    E_train(epoch) = mse(e1);
    y_hat_test = sim(net,Ptest);
    e2 = -y_hat_test + Ttest;
    E_test(epoch) = mse(e2);
end

figure(1);
plot(E_train,'r');
hold on;
plot(E_test,'b');
legend('TrainData','TestData');
xlabel('Number of Epoch')
ylabel('MSE')
title( 'Find Optimal Epoch ')
set(findall(figure(1),'type','line'),'linewidth',1.5);
grid on;

variance_error = var(e2)
E_test(epoch) = mse(e2);


