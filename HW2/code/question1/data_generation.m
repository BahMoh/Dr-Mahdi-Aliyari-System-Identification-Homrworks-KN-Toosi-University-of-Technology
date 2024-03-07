clc
clear
close all

u_1=binrand(1:800,10,40,1,'normal');
u_2=binrand(1:800,30,10,1,'normal');
u_3=normrnd(0,1,800,1);
u_4=unifrnd(-1,1,800,1);

u = [u_1, u_2, u_3, u_4];

filename_data = "data.mat";
save(filename_data, 'u_1', 'u_2', 'u_3', 'u_4');

sigma1 = 0.01;     %minor noise
sigma2 = 0.0700;     %average noise
sigma3 = 0.12;     %major noise

v = random('norm',0,0.12,length(u),1);
v_1 = random('norm',0,sigma1,length(u_1),1);
v_2 = random('norm',0,sigma2,length(u_1),1);
v_3 = random('norm',0,sigma3,length(u_1),1);

save("v_1.mat", 'v_1');
save("v_2.mat", 'v_2');
save("v_3.mat", 'v_3');


