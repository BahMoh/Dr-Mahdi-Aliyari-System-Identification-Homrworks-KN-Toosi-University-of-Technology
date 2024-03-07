clc
clear all
close all
%load( 'Data_1' );
load( 'Data_noise_M' );
%load( 'Data_noise_H' );

 
total_P=[trn_P tst_P vrf_P];
total_T=[trn_T tst_T vrf_T];

%% Normalize input data

total_P(1,:)=(total_P(1,:)-min(total_P(1,:)))/(max(total_P(1,:))-min(total_P(1,:)));
total_P(2,:)=(total_P(2,:)-min(total_P(2,:)))/(max(total_P(2,:))-min(total_P(2,:)));
total_P(3,:)=(total_P(3,:)-min(total_P(3,:)))/(max(total_P(3,:))-min(total_P(3,:)));

total_T=(total_T-min(total_T))/(max(total_T)-min(total_T));

total_P=total_P';
total_T=total_T';
rand('state',0)


u_trn=total_P(1:216,:); u_tst=total_P(217:341,:);
y_trn=total_T(1:216,:); y_tst=total_T(217:341,:);
y_eval=total_T(342:end,:); u_eval=total_P(342:end,:);
y_trn1=[zeros(1); y_trn(1:end-1)];
%%
opt = genfisOptions('SubtractiveClustering');
opt2 = genfisOptions('FCMClustering','NumClusters',14);

opt3 = genfisOptions('GridPartition');
%opt3.InputMembershipFunctionType = ['gaussmf'];
%opt3.OutputMembershipFunctionType= ['linear'];

% opt = anfisOptions('InitialFIS',5,'EpochNumber',5);
% opt.DisplayErrorValues = 0;
% opt.DisplayStepSize = 0

fis=genfis([u_trn y_trn1],y_trn,opt3,'FISType','mamdani');
%fis=genfis([u_trn y_trn1],y_trn);


% Train using anfis method 
% opt = anfisOptions('InitialFIS',5,'EpochNumber',5);
% opt.DisplayErrorValues = 0;
% opt.DisplayStepSize = 0;

fis=anfis([u_trn y_trn1  y_trn],fis,1);

%fuzzy(fis);
%result
yhat=evalfis([u_tst y_tst],fis);
yhateval=evalfis([u_eval y_eval],fis);

Error=y_tst-yhat;
Error2=y_eval-yhateval;

sse_valid=sse(Error2)

z2=iddata(y_tst,u_tst);
z3=iddata(yhat,u_tst);
z4=iddata(y_eval,u_eval);
z5=iddata(yhateval,u_eval);

figure
compare(z2,z3)
legend('Test Real Output','Test NN Output'); 

figure
compare(z4,z5)
legend('validation Real Output','validation NN Output'); 

figure
crosscorr(Error(),Error,100)
title( 'crosscorr(e,e) on test data')

figure
crosscorr(Error2(),Error2,100)
title( 'crosscorr(e,e) on Valid data')

mse(Error);
mse(Error2);
