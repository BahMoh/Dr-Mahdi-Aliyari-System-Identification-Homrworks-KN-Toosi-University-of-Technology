%% Wind Turbin INPUT & OUTPUT
close all;clc;clear all;
sim('Model.slx')
figure(1) 
subplot(4,1,1)
plot(GS,'r')
ylabel('IN1')
xlim([0 500])
subplot(4,1,2)
plot(PA,'b')
ylabel('IN2')
xlim([0 500])
subplot(4,1,3)
plot(WS,'y')
ylabel('IN3')
xlim([0 500])
subplot(4,1,4)
plot(TM,'g')
ylabel('OUT')
xlim([0 500])
figure(2)
crosscorr(WS,TM)
title('Cross Correlation WS and TM')
figure(3)
crosscorr(GS,TM)
title('Cross Correlation GS and TM')
figure(4)
crosscorr(PA,TM)
title('Cross Correlation PA and TM')
%% Using Ident Tool
sim('Model.slx')
% ident('Ident_Static_Analysis.sid')
% FFN5 = feedforwardnet(5,'trainlm');
% FFN10 = feedforwardnet(10,'trainlm');
save ('Data.mat' ,'WS', 'GS', 'PA', 'TM')