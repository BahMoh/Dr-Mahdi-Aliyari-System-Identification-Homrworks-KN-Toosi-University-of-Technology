close all 
clear all 
clc

 
load steamgen.dat
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

P=U(1:6240,:);
T=Y(1:6240,:);
Ptest=U(6241:8160,:);
Ttest=Y(6241:8160,:);


z1=iddata(T,P,3);
z2=iddata(Ttest,Ptest,3);

na=3*ones(4,4);
nb=3*[1 2 1 1; 1 2 1 1; 1 2 1 1; 1 2 1 1];
nk=ones(4,4);


Orders=[na , nb , nk];
%% predictory Model
sys = idnlarx(Orders);
sys.Nonlinearity = 'wavenet';
m = nlarx(z1,sys);
yhat=sim(m,z2);
figure(1)
z3=iddata(yhat.y,Ptest,3);
compare(z2,z3)
e=Ttest-yhat.y;
figure(2)
e1=e(:,1);
crosscorr(e1,e1)
title( 'crosscorr(e1,e1)')
figure(3)
e2=e(:,2);
crosscorr(e2,e2)
title( 'crosscorr(e2,e2)')
figure(4)
e3=e(:,3);
crosscorr(e3,e3)
title( 'crosscorr(e3,e3)')

figure(5)
e4=e(:,4);
crosscorr(e4,e4)
title( 'crosscorr(e4,e4)')