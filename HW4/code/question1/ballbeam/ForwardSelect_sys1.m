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

epoch=10;
rand('state',0)
neron = 4;
for h = 1:6
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
Dyna=1:1:6;
E_Total(1)=min(E1);
[a(1),b]=min(E1);
Reg(1)=Dyna(b);
Dyna(b)=[];
DynaFix=P(:,b);
P(:,b) = [];
DynaFix_test = Ptest(:,b)
Ptest(:,b) = [];
for i=1:5
   
rand('state',0)
for h = 1:6-i
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
