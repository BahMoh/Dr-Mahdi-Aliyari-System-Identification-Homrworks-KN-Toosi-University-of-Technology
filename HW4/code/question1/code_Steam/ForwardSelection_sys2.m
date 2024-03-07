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
epoch=10;
rand('state',0)
neron = 6;
out=4;
for h = 1:34
%     W1 = rand(neron,1);
%     B1 = rand(neron,1);
%     W2 = rand(out,neron);
%     B2 = rand(out,1);
%     net = newff(minmax(P(:,h)') , [neron out], {'tansig' 'purelin'});
%     net = init(net);
%     net.iw{1,1} = W1;
%     net.b{1} = B1;
%     net.lw{2,1} = W2;
%     net.b{2} = B2;
net = newff(minmax(P(:,h)'),T',[neron],{'tansig','purelin'},'trainlm','learngd','mse');
    net.dividefcn = '';
    net.trainFcn = 'trainlm';
    net.trainParam.epochs = 30;
    net.trainParam.lr = 0.01;
    y_hat_train = sim(net , P(:,h)');
    y_hat_test = sim(net,Ptest(:,h)');
    e2 = -y_hat_test + Ttest';
    E1(h) = mse(e2);
end
Dyna=1:1:34;
E_Total(1)=min(E1);
[a(1),b]=min(E1);
Reg(1)=Dyna(b);
Dyna(b)=[];
DynaFix=P(:,b);
P(:,b) = [];
DynaFix_test = Ptest(:,b)
Ptest(:,b) = [];
for i=1:33
   
rand('state',0)
for h = 1:34-i
%     W1 = rand(neron,i+1);
%     B1 = rand(neron,1);
%     W2 = rand(out,neron);
%     B2 = rand(out,1);
%     net = newff(minmax([DynaFix';P(:,h)']) , [neron 4], {'tansig' 'purelin'});
%     net = init(net);
%     net.iw{1,1} = W1;
%     net.b{1} = B1;
%     net.lw{2,1} = W2;
%     net.b{2} = B2;
net = newff(minmax([DynaFix';P(:,h)']),T',[neron],{'tansig','purelin'},'trainlm','learngd','mse');
    net.dividefcn = '';
    net.trainFcn = 'trainlm';
    net.trainParam.epochs = 30;
    net.trainParam.lr = 0.01;
    %net = train(net , [DynaFix';P(:,h)'] , T');
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
plot(E_Total,'-.r')
xlabel('shomare marhale')
ylabel('minimum khata')

figure(2)
plot(Reg,'-r')
xlabel('shomare marhale')
ylabel('regresore entekhab Shode')
