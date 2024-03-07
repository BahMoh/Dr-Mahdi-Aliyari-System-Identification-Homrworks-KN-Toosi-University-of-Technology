function [wi_trn, c_trn, width_trn,e_tst,u_trn,y_trn] = lolimot_algrtm1(regrs, no_neurons)
clc
 
load('Dataset_Q4_High_noise.mat')
 

xyz_trn1 =xyz_trn1;
xyz_tst1 = xyz_tst1;
xyz_vrf1 =xyz_vrf1

% ========================================================
% Initializing variables
% ========================================================
u_trn = xyz_trn1(:, 1:3);
u_test = xyz_tst1(:, 1:3);
u_valid=xyz_vrf1(:, 1:3);

N_trn = size(u_trn, 1);
no_neurons = no_neurons-1;

y_trn = xyz_trn1(:, 4);
regrs = size(u_trn, 2);

Xi_trn = [ones(size(u_trn, 1), 1) u_trn];

c_trn = mean(u_trn);
width_trn = [max(u_trn(:, 1))-min(u_trn(:, 1))];
for i = 2 : regrs
    width_trn = [width_trn max(u_trn(:, i))-min(u_trn(:, i))];
end

% =========================================================================
% LOLIMOT algorithm
% =========================================================================
for M = 1 : no_neurons

% ========================================================
% Find worst LLM
% ========================================================
    for j = 1 : M
        Qi_trn(:, :, j) = gaussian_function(Xi_trn(:, [2:regrs+1]), c_trn(j, :), width_trn(j, :));
    end
    Qi_sum_trn = sum(Qi_trn, 3);

    for j = 1 : M
        Qi_norm_trn(:, :, j) = Qi_trn(:, :, j)./Qi_sum_trn;
        wi_trn(:, j) = inv(Xi_trn'*diag(Qi_norm_trn(:, :, j))*Xi_trn)*Xi_trn'*diag(Qi_norm_trn(:, :, j))*y_trn;
        yi_hat_trn(:, j) = Xi_trn*wi_trn(:, j);
        y_hat_trn(:, j) = yi_hat_trn(:, j).*Qi_norm_trn(:, :, j);
    end
    y_hat_tot_trn = sum(y_hat_trn, 2);
    e_trn = y_trn - y_hat_tot_trn;
    for j = 1 : M
        Ii_trn(j) = sum(e_trn.^2.*Qi_norm_trn(:, :, j));
    end
    I_tot_trn(M) = sum(Ii_trn);
    
    
    [maximum indexmax] = max(Ii_trn);

% ========================================================
% Check all divisions
% ========================================================
    c_temp  = [c_trn; c_trn(indexmax, :); c_trn(indexmax, :)];
    width_temp = [width_trn; width_trn(indexmax, :); width_trn(indexmax, :)];

    c_temp = c_temp([1:indexmax-1, indexmax+1:size(c_temp, 1)], :);
    width_temp = width_temp([1:indexmax-1, indexmax+1:size(width_temp, 1)], :);

    c_temp2 = c_temp;
    width_temp2 = width_temp;
    for j = 1 : regrs        
        c_temp(size(c_temp, 1)-1, j) = c_temp(size(c_temp, 1)-1, j) - 0.25*width_temp(size(width_temp, 1)-1, j);
        c_temp(size(c_temp, 1), j) = c_temp(size(c_temp, 1), j) + 0.25*width_temp(size(width_temp, 1), j);
        width_temp([size(width_temp, 1)-1:size(width_temp, 1)], j) = 0.5*width_temp([size(width_temp, 1)-1:end], j);

        for k = 1 : M+1
            Qi_temp(:, :, k) = gaussian_function(Xi_trn(:, [2:regrs+1]), c_temp(k, :), width_temp(k, :));
        end
        Qi_sum_temp = sum(Qi_temp, 3);

        for k = 1 : M+1
            Qi_norm_temp(:, :, k) = Qi_temp(:, :, k)./Qi_sum_temp;
            wi_temp(:, k) = inv(Xi_trn'*diag(Qi_norm_temp(:, :, k))*Xi_trn)*Xi_trn'*diag(Qi_norm_temp(:, :, k))*y_trn;
            yi_hat_temp(:, k) = Xi_trn*wi_temp(:, k);
            y_hat_temp(:, k) = yi_hat_temp(:, k).*Qi_norm_temp(:, :, k);
        end
        y_hat_tot_temp = sum(y_hat_temp, 2);
        e_temp = y_trn - y_hat_tot_temp;
        for k = 1 : M+1
            Ii_temp(k) = sum(e_temp.^2.*Qi_norm_temp(:, :, k));
        end
        I_tot_temp(j) = sum(Ii_temp);
        c_temp = c_temp2;
        width_temp = width_temp2;
    end

% ========================================================
% Find best division and update LLMs numbers to M+1
% ========================================================    
    [minimum indexmin] = min(I_tot_temp);

    c_temp(size(c_temp, 1)-1, indexmin) = c_temp(size(c_temp, 1)-1, indexmin) - 0.25*width_temp(size(width_temp, 1)-1, indexmin);
    c_temp(size(c_temp, 1), indexmin) = c_temp(size(c_temp, 1), indexmin) + 0.25*width_temp(size(width_temp, 1), indexmin);
    width_temp([size(width_temp, 1)-1:size(width_temp, 1)], indexmin) = 0.5*width_temp([size(width_temp, 1)-1:size(width_temp, 1)], indexmin);

    c_trn = c_temp
    width_trn = width_temp
end

M = M+1;
for j = 1 : M
    Qi_trn(:, :, j) = gaussian_function(Xi_trn(:, [2:regrs+1]), c_trn(j, :), width_trn(j, :));
end
Qi_sum_trn = sum(Qi_trn, 3);

for j = 1 : M
    Qi_norm_trn(:, :, j) = Qi_trn(:, :, j)./Qi_sum_trn;
    wi_trn(:, j) = inv(Xi_trn'*diag(Qi_norm_trn(:, :, j))*Xi_trn)*Xi_trn'*diag(Qi_norm_trn(:, :, j))*y_trn;
    yi_hat_trn(:, j) = Xi_trn*wi_trn(:, j);
    y_hat_trn(:, j) = yi_hat_trn(:, j).*Qi_norm_trn(:, :, j);
end
y_hat_tot_trn = sum(y_hat_trn, 2);
e_trn = y_trn - y_hat_tot_trn;
for j = 1 : M
    Ii_trn(j) = sum(e_trn.^2.*Qi_norm_trn(:, :, j));
end
I_tot_trn(M) = sum(Ii_trn)/N_trn;
I_tot = I_tot_trn(end);
MSE_train=I_tot
[y_hat_tot_test, y_test,y_vrf,y_hat_tot_vrf] = test_algorithm1(regrs, no_neurons, wi_trn, c_trn, width_trn);
N_tst = length(y_test);

e_tst = y_test - y_hat_tot_test;
e_vrf=y_vrf - y_hat_tot_vrf ;

subplot(2, 1, 1);
plot(1:N_trn, y_trn, 'k', 1:N_trn, y_hat_tot_trn, '-r');
legend('Train','Train Network');
xlabel('samples');
ylabel('output');
subplot(2, 1, 2);
plot(1:N_tst, y_test, 'k', 1:N_tst, y_hat_tot_test, '-r');
legend('Test','Test Network');
xlabel('samples');
ylabel('output');



id1=iddata(y_trn,u_trn)
id2=iddata(y_hat_tot_trn,u_trn)

figure
compare(id1,id2)
title('Train')

id3=iddata(y_test,u_test)
id4=iddata(y_hat_tot_test,u_test)

figure
compare(id3,id4)
title('Test')

id5=iddata(y_vrf,u_valid)
id6=iddata(y_hat_tot_vrf,u_valid)
figure
compare(id5,id6)
title('validation')

figure
crosscorr(e_vrf,e_vrf,100)
title('correlation of error')

figure
theta = 0:pi/180:2*pi;
x = sin(theta);
y = cos(theta);
for i = 1:M
    plot(width_trn(i, 1)*x/2+c_trn(i, 1), width_trn(i, 2)*y/2+c_trn(i, 2), 'm', 'LineWidth',1);
    hold on
    plot(c_trn(i, 1),c_trn(i, 2), '*r')
    hold on
end
xlabel('X input');
ylabel('Y input');