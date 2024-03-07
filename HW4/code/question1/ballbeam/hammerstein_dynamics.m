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
z1 = iddata (T,P,0.1);
z2 = iddata (Ttest,Ptest,0.1);
%%

Orders = [3*ones(1,6),0*ones(1,6),zeros(1,6)];  %iddata=..*4*11  %%ziad kardan na nb kharab mikone takhir zeros bashe behtare, mishe nb ham zeros gozasht va khata sefid tar mishe (shayad)

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

% InputNL=saturation([-1.5 1.5]) ;
% OutputNL=saturation([-1.5 1.5]) ;

% InputNL.NumberOfUnits = 5;
% OutputNL.NumberOfUnits =5;       %%malom nemikone kamo ziadesh
% m = nlhw(z1,Orders,InputNL,OutputNL,opt);

opt = nlhwOptions();
opt.SearchOption.MaxIter = 4;
m = nlhw(z1,Orders, saturation([-1.5 1.5]), saturation([-3 3]), opt)
%m = nlhw(z1,Orders, InputNL, OutputNL, opt)

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
