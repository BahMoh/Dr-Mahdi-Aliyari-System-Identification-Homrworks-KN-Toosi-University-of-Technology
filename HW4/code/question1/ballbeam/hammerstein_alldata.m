clc 
close all 
clear all
%%
load ballbeam.dat

U = ballbeam(:,1);
Y = ballbeam(:,2);
% Normalizing Data 
U(:,1)=(U(:,1)-min(U(:,1)))/(max(U(:,1))-min(U(:,1)));

Y(:,1)=(Y(:,1)-min(Y(:,1)))/(max(Y(:,1))-min(Y(:,1)));


Utr=U(1:650,:);
Ytr=Y(1:650,:);
Uts=U(651:end,:);
Yts=Y(651:end,:);

P=Utr;
T=Ytr;
Ptest=Uts;
Ttest=Yts;
%%
z1 = iddata (T,P,0.1);
z2 = iddata (Ttest,Ptest,0.1);
z1=detrend(z1);
z2=detrend(z2);

%%
Orders = [ones(1,1),ones(1,1),ones(1,1)];

% InputNL=unitgain;
% OutputNL=unitgain;

% InputNL=sigmoidnet;
% OutputNL=sigmoidnet;

% InputNL=pwlinear;
% OutputNL=pwlinear;

% InputNL=wavenet ;
% OutputNL=wavenet ;

% InputNL=deadzone ;
% OutputNL=deadzone ;

% InputNL.NumberOfUnits = 20;
% OutputNL.NumberOfUnits = 20;
% m = nlhw(z1,Orders,InputNL,OutputNL,opt);
opt = nlhwOptions();
opt.Display = 'on';

opt.SearchOption.MaxIter = 4;  %%bayad ziad she fekr konm
m = nlhw(z1,Orders, saturation([-1.5 1.5]), saturation([-3 3]), opt)
% m = nlhw(z1,Orders, InputNL, OutputNL, opt)
yhat=predict(m,z2,1);
figure(1)
z3=iddata(yhat.y,Ptest,0.1);
%z3=detrend(z3);
compare(z2,z3);
e=Ttest-yhat.y;
figure(2)
e1=e(:,1);
crosscorr(e1,e1,100)
title( 'crosscorr(e1,e1)')
