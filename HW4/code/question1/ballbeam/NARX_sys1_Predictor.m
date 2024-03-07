close all 
clear all 
clc


load ballbeam.dat
U = ballbeam(:,1);
Y = ballbeam(:,2);
% Normalizing Data 
U(:,1)=(U(:,1)-min(U(:,1)))/(max(U(:,1))-min(U(:,1))); 

Y(:,1)=(Y(:,1)-min(Y(:,1)))/(max(Y(:,1))-min(Y(:,1)));


P=U(1:650,:);
T=Y(1:650,:);
Ptest=U(651:end,:);
Ttest=Y(651:end,:);


z1=iddata(T,P,0.1);
z2=iddata(Ttest,Ptest,0.1);

na=3*ones(1,1);   %%ziad beshe=kami behtare
%nb=[1 2 1 1; 1 2 1 1; 1 2 1 1; 1 2 1 1];
nb=4*ones(1,1);  %%ziad beshe=kami behtare
nk=1*ones(1,1);    %%taghiresh kheili asari nadasht


Orders=[na , nb , nk];
%% % predictory Model
sys = idnlarx(Orders);
sys.Nonlinearity = 'wavenet';

m = nlarx(z1,sys);
yhat=predict(m,z2,1);  %%ofogh pishbini
figure(1)
z3=iddata(yhat.y,Ptest,0.1);
compare(z2,z3)
e=Ttest-yhat.y;
figure(2)
e1=e(:,1);
crosscorr(e1,e1,100)
title( 'crosscorr(e1,e1)')
