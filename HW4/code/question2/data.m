clc 
close all 
clear all 

savefile='data' 
load evaporator.dat

u1=evaporator(:,1);
u2=evaporator(:,2);
u3=evaporator(:,3);
y1=evaporator(:,4);
y2=evaporator(:,5);
y3=evaporator(:,6);


utr1=u1(1:4414);
utr2=u2(1:4414);
utr3=u3(1:4414);
ytr1=y1(1:4414);
ytr2=y2(1:4414);
ytr3=y3(1:4414);

uts1=u1(4415:end);
uts2=u2(4415:end);
uts3=u3(4415:end);
yts1=y1(4415:end);
yts2=y2(4415:end);
yts3=y3(4415:end);


Utr1 = (utr1-min(utr1))/(max(utr1)-min(utr1));
Utr2 = (utr2-min(utr2))/(max(utr2)-min(utr2));
Utr3 = (utr3-min(utr3))/(max(utr3)-min(utr3));
Ytr1 = (ytr1-min(ytr1))/(max(ytr1)-min(ytr1));
Ytr2 = (ytr2-min(ytr2))/(max(ytr2)-min(ytr2));
Ytr3 = (ytr3-min(ytr3))/(max(ytr3)-min(ytr3));

Uts1 = (uts1-min(utr1))/(max(utr1)-min(utr1));
Uts2 = (uts2-min(utr2))/(max(utr2)-min(utr2));
Uts3 = (uts3-min(utr3))/(max(utr3)-min(utr3));
Yts1 = (yts1-min(ytr1))/(max(ytr1)-min(ytr1));
Yts2 = (yts2-min(ytr2))/(max(ytr2)-min(ytr2));
Yts3 = (yts3-min(ytr3))/(max(ytr3)-min(ytr3));

nTest=1891;
nTrain=4414;

for i=1:21
    U1_tr(:,i)=[zeros(i,1); Utr1(1:nTrain-i,1)];
    U2_tr(:,i)=[zeros(i,1); Utr2(1:nTrain-i,1)];
    U3_tr(:,i)=[zeros(i,1); Utr3(1:nTrain-i,1)];
    Y1_tr(:,i)=[zeros(i,1); Ytr1(1:nTrain-i,1)];
    Y2_tr(:,i)=[zeros(i,1); Ytr2(1:nTrain-i,1)];
    Y3_tr(:,i)=[zeros(i,1); Ytr3(1:nTrain-i,1)];
    U1_tes(:,i)=[zeros(i,1); Uts1(1:nTest-i,1)];
    U2_tes(:,i)=[zeros(i,1); Uts2(1:nTest-i,1)];
    U3_tes(:,i)=[zeros(i,1); Uts3(1:nTest-i,1)];
    Y1_tes(:,i)=[zeros(i,1); Yts1(1:nTest-i,1)];
    Y2_tes(:,i)=[zeros(i,1); Yts2(1:nTest-i,1)];
    Y3_tes(:,i)=[zeros(i,1); Yts3(1:nTest-i,1)];
end

%  'U1_tr','U2_tr', 'U3_tr','Y1_tr', 'Y2_tr','Y3_tr','U1_tes','U2_tes', 'U3_tes','Y1_tes', 'Y2_tes','Y3_tes'

save('data','Utr1','Utr2','Utr3','Ytr1','Ytr2','Ytr3','Uts1','Uts2','Uts3','Yts1','Yts2','Yts3','u1','u2','u3','y1','y2','y3')