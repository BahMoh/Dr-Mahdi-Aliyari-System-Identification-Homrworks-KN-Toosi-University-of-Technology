function [y_hat_tot_test, y_test,y_vrf,y_hat_tot_vrf] = test_algorithm1(regrs, no_neurons, wi, c, width)

load('Dataset_Q4_High_noise.mat')


xyz_trn1 =xyz_trn1;
xyz_tst1 = xyz_tst1;
xyz_vrf1=xyz_vrf1; 
% ========================================================
% Initializing variables
% ========================================================

u_tst = xyz_tst1(:, 1:3);
u_vrf = xyz_vrf1(:, 1:3);

N_tst = size(u_tst, 1);
no_neurons = no_neurons-1;

y_test = xyz_tst1(:, 4);
y_vrf=  xyz_vrf1(:, 4);
regrs = size(u_tst, 2);

regrs1 = regrs;
regrs = size(u_tst, 2);

Xi_test = [ones(size(u_tst, 1), 1) u_tst];

for j = 1 : no_neurons
    Qi_test(:, :, j) = gaussian_function(Xi_test(:, [2:regrs+1]), c(j, :), width(j, :));
end
Qi_sum_test = sum(Qi_test, 3);

for j = 1 : no_neurons
    Qi_norm_test(:, :, j) = Qi_test(:, :, j)./Qi_sum_test;
    yi_hat_test(:, j) = Xi_test*wi(:, j);
    y_hat_test(:, j) = yi_hat_test(:, j).*Qi_norm_test(:, :, j);
end
y_hat_tot_test = sum(y_hat_test, 2);

e_test = y_test - y_hat_tot_test;
for j = 1 : no_neurons
    Ii_test(j) = sum(e_test.^2.*Qi_norm_test(:, :, j));
end
I_tot_test = sum(Ii_test)/N_tst;
MSE_test=I_tot_test


%%
regrs1 = regrs;
regrs = size(u_vrf, 2);

Xi_vrf = [ones(size(u_vrf, 1), 1) u_vrf];

for j = 1 : no_neurons
    Qi_vrf(:, :, j) = gaussian_function(Xi_vrf(:, [2:regrs+1]), c(j, :), width(j, :));
end
Qi_sum_vrf = sum(Qi_vrf, 3);

for j = 1 : no_neurons
    Qi_norm_vrf(:, :, j) = Qi_vrf(:, :, j)./Qi_sum_vrf;
    yi_hat_vrf(:, j) = Xi_vrf*wi(:, j);
    y_hat_vrf(:, j) = yi_hat_vrf(:, j).*Qi_norm_vrf(:, :, j);
end
y_hat_tot_vrf = sum(y_hat_vrf, 2);

e_vrf = y_test - y_hat_tot_vrf;