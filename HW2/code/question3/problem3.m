clc
clear all
close all
% A=importdata('heating_system.dat')
data = load("data_Q3.mat")
train_data = data.z_tr;
input_data_train = train_data.InputData;
output_data_train = train_data.OutputData;

test_data = data.z_ts;
input_data_test = test_data.InputData;
output_data_test = test_data.OutputData;

%% normalize
% utrain=(utrain - min(utrain)) / ( max(utrain) - min(utrain) );
% output_data_train=(output_data_train - min(output_data_train)) / ( max(output_data_train) - min(output_data_train) );

% utest=(utest - min(utest)) / ( max(utest) - min(utest) );
% output_data_test=(output_data_test - min(output_data_test)) / ( max(output_data_test) - min(output_data_test) );

%% parameter
Ts=0.1;
data1=iddata(output_data_train,input_data_train,Ts);
data2=iddata(output_data_test,input_data_test,Ts);

u(1:300) = input_data_train;
u(301:400) = input_data_test;

na=3;
nb=3;
nk=1;
nf=1;
nc=1;
% na=3;nb=2;nk=1;nf=3;nc=2;
%% ARMAX
y_armax=armax(data1,[na nb nc nk]);
%y_armax=pem(data1,[6 1 0 1 0 1]);
[est_num_1,est_den_1]=tfdata(y_armax,'v');
est_sys_1=tf(est_num_1,est_den_1,Ts);
est_y_1=lsim(est_sys_1,output_data_train);
%% ARX
na=1;nb=1;nk=1;
estimated_y_1=arx(data1,[na nb nk]);
[est_num_1,est_den_1]=tfdata(estimated_y_1,'v');
est_sys_1=tf(est_num_1,est_den_1,Ts);
est_y_2=lsim(est_sys_1,output_data_train);
%% OE
estimated_y_2=oe(data1,[nb nf nk]);
sys_oe=filt(estimated_y_2.b,estimated_y_2.f,Ts);
[est_num_2,est_den_2]=tfdata(estimated_y_2,'v');
est_sys_2=tf(est_num_2,est_den_2,Ts);
est_y_3=lsim(est_sys_2,u);
%% PLOTS
% figure
% plot(output_data_train)
% title("y train")
% 
% figure
% plot(input_data_train)
% title("u train")
% 
% figure
% plot(input_data_test)
% title("u test")
% 
% figure
% plot(output_data_test)
% title("y test")

figure
compare(data2,y_armax,'*r')
title('real output and estimate output (ARMAX)')
legend('real','estimate')

figure
resid(data2,y_armax)
title('resid (ARMAX)')

figure
compare(data2,estimated_y_1,'*r')
title('real output and estimate output (ARX)')
legend('real','estimate')

figure
resid(data2,estimated_y_1)
title('resid (ARX)')

figure
compare(data2,estimated_y_2,'*r')
title('real output and estimate output (OE)')
legend('real','estimate')

figure
resid(data2,estimated_y_2)
title('resid (OE)')



% % Compute auto-correlation of the output data
% auto_corr_output = autocorr(output_data_train);
% 
% % Compute cross-correlation between input and output data
% cross_corr = xcorr(input_data_train, output_data_train);
% 
% % Time vector for the cross-correlation plot
% time_vector_corr = -length(input_data_train)+1:length(input_data_train)-1;
% 
% % Plot auto-correlation
% figure;
% subplot(2, 1, 1);
% stem(auto_corr_output);
% title('Auto-correlation of Output Data');
% 
% % Plot cross-correlation
% subplot(2, 1, 2);
% stem(time_vector_corr, cross_corr);
% title('Cross-correlation between Input and Output Data');
% xlabel('Lag');


%%
% figure
% autocorr(abs(est_y_1-ytrain),479)
% title('Autocorr for error ')

% figure
% compare(data2,estimated_y_2,'*r')
%resid(data2,estimated_y_2)

% figure
% crosscorr(utrain,ytrain)
% figure
% autocorr(ytrain)