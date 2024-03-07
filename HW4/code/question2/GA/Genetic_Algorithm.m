close all 
clear all
clc 

 
fitnessfcn = @(x) MSE_GA(x);
ga_opts = gaoptimset('Generations',3,'display','iter');
[x_ga_opt, err_ga] = ga(fitnessfcn, 6, [],[],[],[],zeros(1,6),40*ones(1,6),[],1:6,ga_opts);

Dynamics=x_ga_opt+1