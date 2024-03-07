clc
clear 
close all

%load('Dataset_Q4.mat')
%load('Dataset_Q4_Medium_noise.mat')
load('Dataset_Q4_High_noise.mat')
regressors1 = 3;
initial_neurons1 = 15;
lolimot_algrtm_struct1(regressors1, initial_neurons1);


opt_neurons1 = 15;
 [wi_trn, c_trn, width_trn,e_tst,u_trn,y_trn] = lolimot_algrtm1(regressors1, opt_neurons1);