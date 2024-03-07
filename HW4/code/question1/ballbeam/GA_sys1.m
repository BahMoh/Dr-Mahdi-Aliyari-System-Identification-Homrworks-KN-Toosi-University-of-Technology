clc
clear all
close all 
load ballbeam.dat

%%
% fitnessfcn = @(x) MSE_sys2(x); 
fitnessfcn = @(x) MSE_sys2(x);
ga_opts = gaoptimset('Generations',3,'display','iter');
[x_ga_opt, err_ga] = ga(fitnessfcn,2, [],[],[],[],zeros(1,2),5*ones(1,2),[],1:2,ga_opts);

Dynamics=x_ga_opt+1
