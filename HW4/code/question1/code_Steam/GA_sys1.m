clc
clear all
close all 
load data_steamgen


%%
% fitnessfcn = @(x) MSE_sys2(x); 
fitnessfcn = @(x) MSE_sys1(x);
ga_opts = gaoptimset('Generations',4,'display','iter');
[x_ga_opt, err_ga] = ga(fitnessfcn, 8, [],[],[],[],zeros(1,8),88*ones(1,8),[],1:8,ga_opts);

Dynamics=x_ga_opt+1

