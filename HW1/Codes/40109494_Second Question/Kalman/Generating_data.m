%Generate Data
clear all
clc
u=normrnd(0.5,1,1000,1);
u=(u-min(u))/(max(u)-min(u));
figure
subplot(121)
normplot(u)
subplot(122)
hist(u)
u8=u.^8;
figure 
hist(u8)
noise1=normrnd(0,0.01,1000,1);
noise2=normrnd(0,0.08,1000,1);
noise3=normrnd(0,0.1,1000,1);

g = 1;
% g = 0.01;
theta3 = zeros(1000,1);
for t = 1:1000
    theta3(t,1) = 0.5 + tansig(g*(t-400));
end
y_without_noise = zeros(1000,1);
y_without_noise=-1.5 - 0.8*u + theta3.*u.^3 - 0.65*u.^5 + 2.25*u.^6 - 1.7*u.^8; 
y_Low=(y_without_noise+noise1);
y_Medium=(y_without_noise+noise2);
y_High=(y_without_noise+noise3);
data=[u y_without_noise y_Low y_Medium y_High];
% data=sortrows(data);
Num=randperm(1000);

% save data data Num
filename = "data.mat";
save(filename, "data");

