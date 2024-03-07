%Generate Data
clear all
clc
no_datapoints = 2000;
u=normrnd(0.5,1,no_datapoints,1);
u=(u-min(u))/(max(u)-min(u));
figure
subplot(121)
normplot(u)
subplot(122)
hist(u)
u8=u.^8;
figure 
hist(u8)
noise1=normrnd(0,0.01,no_datapoints,1);
noise2=normrnd(0,0.08,no_datapoints,1);
noise3=normrnd(0,0.1,no_datapoints,1);
% [-1.5, -0.8, 0, 0.01, 0, -0.65, 2.25, 0, -1.7]
y_without_noise=-1.5 - 0.8*u + 0.01*u.^3 - 0.65*u.^5 + 2.25*u.^6 - 1.7*u.^8; 
y_Low=(y_without_noise+noise1);
y_Medium=(y_without_noise+noise2);
y_High=(y_without_noise+noise3);
data=[u y_without_noise y_Low y_Medium y_High];
% data=sortrows(data);
Num=randperm(1000);

% save data data Num
filename = "data.mat";
save(filename, "data");

