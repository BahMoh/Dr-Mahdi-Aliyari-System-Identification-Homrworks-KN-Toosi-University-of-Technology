function lolimot_algrtm_struct1(regrs, no_neurons)
clc


load('Dataset_Q4_High_noise.mat')
 

xyz_trn1 =xyz_trn1;
xyz_tst1 = xyz_tst1;
% ========================================================
% Initializing variables
% ========================================================
u_trn = xyz_trn1(:, 1:3);
u_tst = xyz_tst1(:, 1:3);

N_trn = size(u_trn, 1);
N_tst = size(u_tst, 1);
no_neurons = no_neurons-1;

y_trn = xyz_trn1(:, 4);
y_tst = xyz_tst1(:, 4);
regrs = size(u_trn, 2);

Xi_trn = [ones(N_trn, 1) u_trn];
Xi_tst = [ones(N_tst, 1) u_tst];

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

    for j = 1 : M
        Qi_tst(:, :, j) = gaussian_function(Xi_tst(:, [2:regrs+1]), c_trn(j, :), width_trn(j, :));
    end
    Qi_sum_tst = sum(Qi_tst, 3);

    for j = 1 : M
        Qi_norm_tst(:, :, j) = Qi_tst(:, :, j)./Qi_sum_tst;
        yi_hat_tst(:, j) = Xi_tst*wi_trn(:, j);
        y_hat_tst(:, j) = yi_hat_tst(:, j).*Qi_norm_tst(:, :, j);
    end
    y_hat_tot_tst = sum(y_hat_tst, 2);
    e_tst = y_tst - y_hat_tot_tst;
    for j = 1 : M
        Ii_tst(j) = sum(e_tst.^2.*Qi_norm_tst(:, :, j));
    end
    I_tot_tst(M) = sum(Ii_tst);
    
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

for j = 1 : M
    Qi_tst(:, :, j) = gaussian_function(Xi_tst(:, [2:regrs+1]), c_trn(j, :), width_trn(j, :));
end
Qi_sum_tst = sum(Qi_tst, 3);

for j = 1 : M
    Qi_norm_tst(:, :, j) = Qi_tst(:, :, j)./Qi_sum_tst;
    yi_hat_tst(:, j) = Xi_tst*wi_trn(:, j);
    y_hat_tst(:, j) = yi_hat_tst(:, j).*Qi_norm_tst(:, :, j);
end
y_hat_tot_tst = sum(y_hat_tst, 2);
e_tst = y_tst - y_hat_tot_tst;
for j = 1 : M
    Ii_tst(j) = sum(e_tst.^2.*Qi_norm_tst(:, :, j));
end
I_tot_tst(M) = sum(Ii_tst)/N_tst;

figure
plot([1:M], I_tot_trn,'k->',...
     'linewidth',2,...
     'markeredgecolor','r',...
     'markerfacecolor',[0 1 1],...
     'markersize',4);
 hold on;
 
plot([1:M], I_tot_tst,'d:c',...
     'linewidth',2,...
     'markeredgecolor','m',...
     'markerfacecolor',[1 0.3 1],...
     'markersize',4);
title('Train and Test error');
xlabel('Number of neurons');
ylabel('Mean Squared Error');
legend('Train', 'Test');

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