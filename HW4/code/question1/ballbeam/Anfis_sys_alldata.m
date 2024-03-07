% Data Generating for system 2
clear; clc; close all; 

load ballbeam.dat
data=ballbeam;

for i=1:2
    data(:,i)=(data(:,i)-min(data(:,i)))/(max(data(:,i))-min(data(:,i)));
end

%% miso
u_trn=data(1:650,1); u_tst=data(651:end,1);
y_trn=data(1:650,2); y_tst=data(651:end,2);
y_trn1=[zeros(1); y_trn(1:end-1)];

%%

%fis=genfis3([u_trn y_trn1],y_trn);

% Train using anfis method 
%% options
rand('state',0)

% opt = anfisOptions('InitialFIS',100,'EpochNumber',10);
% opt.DisplayErrorValues = 0;
% opt.DisplayStepSize = 0;
%opt2 = genfisOptions('SubtractiveClustering');
opt3 = genfisOptions('FCMClustering','NumClusters',4);
opt4 = genfisOptions('GridPartition');
% opt4.InputMembershipFunctionType = ['gbellmf'];
% opt4.OutputMembershipFunctionType= ['linear'];
fis=genfis([u_trn y_trn1],y_trn,opt3,'FISType','mamdani');
%%
fis=anfis([u_trn y_trn1  y_trn],fis,10);

%fuzzy(fis);
%result
yhat=evalfis([u_tst y_tst],fis);

Error=y_tst-yhat;

testdata=iddata(y_tst,u_tst,0.1);
testdata_hat=iddata(yhat,u_tst,0.1);
figure(1)
compare(testdata,testdata_hat)

figure(2)
crosscorr(Error(),Error,100)
title( 'crosscorr(e,e)')

