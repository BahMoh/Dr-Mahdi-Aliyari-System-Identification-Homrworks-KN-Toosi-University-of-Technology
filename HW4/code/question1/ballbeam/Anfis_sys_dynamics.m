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
U_tr = P;
U_te = Ptest;
Y_tr = T;
Y_te = Ttest;

U=[U_tr;U_te];
Y=[Y_tr;Y_te];

trnData1=[P T(:,1)];

testData=Ptest;
%% options
% opt = anfisOptions('InitialFIS',100,'EpochNumber',500);
% opt.DisplayErrorValues = 0;
% opt.DisplayStepSize = 0;
% opt2 = genfisOptions('SubtractiveClustering');
opt3 = genfisOptions('FCMClustering','NumClusters',2);
%opt4 = genfisOptions('GridPartition');
%opt4.InputMembershipFunctionType = ['trimf'];
%opt4.OutputMembershipFunctionType= ['linear'];
%fis=genfis([u_trn y_trn1],y_trn,opt4,'FISType','mamdani');
%%
rand('state',0)

in_fis1 = genfis(P,T(:,1),opt3,'FISType','mamdani');
%epoch_n = 20;
out_fis_tr1 = anfis(trnData1,in_fis1,200);

Y_hat1 = evalfis(testData,out_fis_tr1);



figure
z1=iddata(Ttest(:,1),Ptest,0.1)
z1_hat=iddata(Y_hat1,Ptest,0.1)
compare(z1,z1_hat)

figure
e1=Ttest(:,1)-Y_hat1;
crosscorr(e1,e1,100)
title( 'crosscorr(e,e)')


