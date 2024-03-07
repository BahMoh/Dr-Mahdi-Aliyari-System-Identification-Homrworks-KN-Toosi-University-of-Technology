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
%%
Orders = [3*ones(1,1),4*ones(1,6),ones(1,6)];   %%iddata=6240*4*11
sys = idnlarx(Orders);
sys.Nonlinearity = 'wavenet';
NARX_model_p = nlarx([T,P],sys);

Data_tr = iddata (T,P);
Y_hat1 = predict(NARX_model_p,Data_tr);
Er_tr = T - Y_hat1.y;

Data_te = iddata (Ttest,Ptest);
Y_hat_te = predict(NARX_model_p,Data_te,5);  %% afzayesh ofogh pishbini=badtar
%Y_hat_te2 = sim(NARX_model_p,Data_te);
Er_te = Ttest - Y_hat_te.y;

z1 = iddata(Ttest,Ptest);

figure
compare(z1,Y_hat_te)
title('predict')
% figure
% compare(z1,Y_hat_te2)
% title('sim')

figure
autocorr(Er_te(:,1),100)
title( 'crosscorr(e1,e1)')
