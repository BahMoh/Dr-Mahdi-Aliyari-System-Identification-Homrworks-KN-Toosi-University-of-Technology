clc
clear all
close all

x=unifrnd(1,6,[216+125+125 1]);
y=unifrnd(1,6,[216+125+125 1]);
u=unifrnd(1,6,[216+125+125 1]);
% ss
Z = 1+(x.^(0.5))+(y.^(-1))+(u.^(-1.5))

figure
plot(Z)
title('with out noise')
% save('Data','x','y','Z')


input = [x y u]';
output = Z';


trn_P = input(:,1:216);    % training
trn_T = output(:,1:216);   % training

tst_P = input(:,217:217+125-1);     %  test
tst_T = output(:,217:217+125-1);   % test

vrf_P = input(:,217+125:end);     %  validation
vrf_T = output(:,217+125:end);   %  validation

save ('Data_1.mat' ,'trn_P' ,'trn_T' ,'tst_P', 'tst_T' ,'vrf_P' ,'vrf_T')


figure;
normplot(Z);
figure;
histogram(u.^(-1.5));

%% Noise

% Low Gaussian variance: 
noise_var = 0.005;
load Data_1.mat

trn_T = normrnd(0,noise_var,size(trn_T))+trn_T;     
tst_T = normrnd(0,noise_var,size(tst_T)) + tst_T;     
vrf_T = normrnd(0,noise_var,size(vrf_T)) + vrf_T;     
figure
plot([trn_T tst_T vrf_T])
title('low noise')
save Data_noise_L trn_P trn_T tst_P tst_T vrf_P vrf_T
clear all
%%
% Medium Gaussian variance: 
noise_var = 0.05;
load Data_1.mat

trn_T = normrnd(0,noise_var,size(trn_T))+trn_T;     
tst_T = normrnd(0,noise_var,size(tst_T)) + tst_T;     
vrf_T = normrnd(0,noise_var,size(vrf_T)) + vrf_T;     
figure
plot([trn_T tst_T vrf_T])
title('medium noise')

save Data_noise_M trn_P trn_T tst_P tst_T vrf_P vrf_T
clear all

%%
% High Gaussian variance: 
noise_var = 0.3;
load Data_1.mat
trn_T = normrnd(0,noise_var,size(trn_T))+trn_T;     
tst_T = normrnd(0,noise_var,size(tst_T)) + tst_T;     
vrf_T = normrnd(0,noise_var,size(vrf_T)) + vrf_T;       
figure
plot([trn_T tst_T vrf_T])
title('High noise')

save Data_noise_H trn_P trn_T tst_P tst_T vrf_P vrf_T

clear all
%%



