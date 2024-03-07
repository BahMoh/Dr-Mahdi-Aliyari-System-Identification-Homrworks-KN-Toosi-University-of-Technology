clc 
close all 
clear all
%%
load steamgen.dat

nTest=1920;
nTrain=6240; 
U = steamgen(:,2:5);
Y = steamgen(:,6:9);
% Normalizing Data
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

P=Utr;
T=Ytr;
Ptest=Uts;
Ttest=Yts;
%%
z1 = iddata (T,P,3);
z2 = iddata (Ttest,Ptest,3);
%z1=detrend(z1);
%z2=detrend(z2);

%%
Orders = [ones(4,4),ones(4,4),zeros(4,4)];

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

opt.SearchOption.MaxIter = 20;  %%bayad ziad she fekr konm
m = nlhw(z1,Orders, saturation([-1.5 1.5]), saturation([-3 3]), opt)
% m = nlhw(z1,Orders, InputNL, OutputNL, opt)
yhat=predict(m,z2,1);
figure(1)
z3=iddata(yhat.y,Ptest,3);
%z3=detrend(z3);
compare(z2,z3);
e=Ttest-yhat.y;
figure(2)
e1=e(:,1);
crosscorr(e1,e1,100)
title( 'crosscorr(e1,e1)')
figure(3)
e2=e(:,2);
crosscorr(e2,e2,100)
title( 'crosscorr(e2,e2)')
figure(4)
e3=e(:,3);
crosscorr(e3,e3,100)
title( 'crosscorr(e3,e3)')

figure(5)
e4=e(:,4);
crosscorr(e4,e4,100)
title( 'crosscorr(e4,e4)')