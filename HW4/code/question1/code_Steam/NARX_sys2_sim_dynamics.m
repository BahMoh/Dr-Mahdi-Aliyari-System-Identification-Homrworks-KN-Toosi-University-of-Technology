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

for i=1:89
    U1_tr(:,i)=[zeros(i,1); Utr(1:nTrain-i,1)];
    U2_tr(:,i)=[zeros(i,1); Utr(1:nTrain-i,2)];
    U3_tr(:,i)=[zeros(i,1); Utr(1:nTrain-i,3)];
    U4_tr(:,i)=[zeros(i,1); Utr(1:nTrain-i,4)];
    Y1_tr(:,i)=[zeros(i,1); Ytr(1:nTrain-i,1)];
    Y2_tr(:,i)=[zeros(i,1); Ytr(1:nTrain-i,2)];
    Y3_tr(:,i)=[zeros(i,1); Ytr(1:nTrain-i,3)];
    Y4_tr(:,i)=[zeros(i,1); Ytr(1:nTrain-i,4)];
    U1_ts(:,i)=[zeros(i,1); Uts(1:nTest-i,1)];
    U2_ts(:,i)=[zeros(i,1); Uts(1:nTest-i,2)];
    U3_ts(:,i)=[zeros(i,1); Uts(1:nTest-i,3)];
    U4_ts(:,i)=[zeros(i,1); Uts(1:nTest-i,4)];
    Y1_ts(:,i)=[zeros(i,1); Yts(1:nTest-i,1)];
    Y2_ts(:,i)=[zeros(i,1); Yts(1:nTest-i,2)];
    Y3_ts(:,i)=[zeros(i,1); Yts(1:nTest-i,3)];
    Y4_ts(:,i)=[zeros(i,1); Yts(1:nTest-i,4)];
end

P=[ U1_tr(:,3) U1_tr(:,4)...
    U2_tr(:,3)...
    U3_tr(:,14)...
    U4_tr(:,4) U4_tr(:,87)...
    Y1_tr(:,1)...
    Y2_tr(:,1) Y2_tr(:,7)...
    Y3_tr(:,1)...
    Y4_tr(:,1)];
T=Ytr;
Ptest=[ U1_ts(:,3) U1_ts(:,4)...
    U2_ts(:,3)...
    U3_ts(:,14)...
    U4_ts(:,4) U4_ts(:,87)...
    Y1_ts(:,1)...
    Y2_ts(:,1) Y2_ts(:,7)...
    Y3_ts(:,1)...
    Y4_ts(:,1)];
Ttest=Yts;
%%
Orders = [3*ones(4,4),3*ones(4,11),zeros(4,11)];
sys = idnlarx(Orders);
sys.Nonlinearity = 'wavenet';
NARX_model_p = nlarx([T,P],sys);

Data_tr = iddata (T,P,3);
Y_hat1 = sim(NARX_model_p,Data_tr);
Er_tr = T - Y_hat1.y;

Data_te = iddata (Ttest,Ptest,3);
Y_hat_te = sim(NARX_model_p,Data_te);
%Y_hat_te2 = sim(NARX_model_p,Data_te);
Er_te = Ttest - Y_hat_te.y;

z1 = iddata(Ttest,Ptest,3);

figure
compare(z1,Y_hat_te)
title('simulator')
% figure
% compare(z1,Y_hat_te2)
% title('sim')

figure
autocorr(Er_te(:,1),100)
title( 'crosscorr(e1,e1)')

figure
autocorr(Er_te(:,2),100)
title( 'crosscorr(e2,e2)')

figure
autocorr(Er_te(:,3),100)
title( 'crosscorr(e3,e3)')

figure
autocorr(Er_te(:,4),100)
title( 'crosscorr(e4,e4)')

