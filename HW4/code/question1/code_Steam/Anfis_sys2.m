% Data Generating for system 2
clear; clc; close all;

load steamgen.dat
data=steamgen;
  
for i=2:9 
    data(:,i)=(data(:,i)-min(data(:,i)))/(max(data(:,i))-min(data(:,i)));
end

%% miso
u_trn=data(1:6240,2:5); u_tst=data(6241:8160,2:5);
y_trn=data(1:6240,9); y_tst=data(6241:8160,9);
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
%opt3 = genfisOptions('FCMClustering','NumClusters',10);
opt4 = genfisOptions('GridPartition');
% opt4.InputMembershipFunctionType = ['trimf'];
% opt4.OutputMembershipFunctionType= ['linear'];
fis=genfis([u_trn y_trn1],y_trn,opt4,'FISType','mamdani');
%%
fis=anfis([u_trn y_trn1  y_trn],fis);

%fuzzy(fis);
%result
yhat=evalfis([u_tst y_tst],fis);

Error=y_tst-yhat;

testdata=iddata(y_tst,u_tst,3);
testdata_hat=iddata(yhat,u_tst,3);
figure(1)
compare(testdata,testdata_hat)

figure(2)
crosscorr(Error(),Error,100)
title( 'crosscorr(e,e)')

