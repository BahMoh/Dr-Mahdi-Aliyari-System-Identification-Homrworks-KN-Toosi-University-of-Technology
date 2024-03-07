%% Lipschitz system1
clc; clear all;close all;
load steamgen.dat
U=steamgen(:,2:5);
Y=steamgen(:,6:9);
% figure
% subplot(221),plot(U(:,1)),title('Input Fuel')
% subplot(222),plot(U(:,2)),title('Input Air')
% subplot(223),plot(U(:,3)),title('Input Level Ref')
% subplot(224),plot(U(:,4)),title('Input Disturbance') 
% 
% figure
% subplot(221),plot(Y(:,1)),title('Output Drum Pressure ')
% subplot(222),plot(U(:,2)),title('Output Excess Oxygen')
% subplot(223),plot(U(:,3)),title('Output Water Level')
% subplot(224),plot(U(:,4)),title('Output Steam Flow')

% Normalizing Data
U(:,1)=(U(:,1)-min(U(:,1)))/(max(U(:,1))-min(U(:,1)));
U(:,2)=(U(:,2)-min(U(:,2)))/(max(U(:,2))-min(U(:,2)));
U(:,3)=(U(:,3)-min(U(:,3)))/(max(U(:,3))-min(U(:,3)));
U(:,4)=(U(:,4)-min(U(:,4)))/(max(U(:,4))-min(U(:,4)));

Y(:,1)=(Y(:,1)-min(Y(:,1)))/(max(Y(:,1))-min(Y(:,1)));
Y(:,2)=(Y(:,2)-min(Y(:,2)))/(max(Y(:,2))-min(Y(:,2)));
Y(:,3)=(Y(:,3)-min(Y(:,3)))/(max(Y(:,3))-min(Y(:,3)));
Y(:,4)=(Y(:,4)-min(Y(:,4)))/(max(Y(:,4))-min(Y(:,4)));
%%
steamgen = resample(steamgen,1,7);
u1=steamgen(:,5)';
y=steamgen(:,9)';
N_tr=960;
%N_tr=1372;
n=60;  %%number of dymanics
d=n-1;
for main=1:n
    for i=(n+1):N_tr
        for j=(i+1):N_tr
            a=abs(y(1,i)-y(1,j));
            sum=0;
            for k=1:main
                sum=sum+(u1(1,i-k)-u1(1,j-k))^2;
            end
            L(i,j,main)=a/sqrt(sum);
        end
    end
end
for i=1:n
    for j=1:3
    max_L(i,:)=max(L(:,:,i));
    max_L_T(i,:)=max(L(:,:,i)');
    max_L(i,:)=sort(max_L(i,:));
    max_L_T(i,:)=sort(max_L_T(i,:));
    end
end
for i=1:n
    total(i,:)=[max_L(i,:) max_L_T(i,:)];
    total(i,:)=sort(total(i,:),'descend');
end


p=1;
for i=1:n
    mult=1;
    for k=1:p
       mult=mult*sqrt(i)*total(i,k+1);
    end
    L_n(i)=mult^(1/p);
end
semilogy(L_n,'b.','MarkerSize',20)
xlabel('Lag')
ylabel('Lipschitz Number')
%%
clear all
load steamgen.dat
steamgen = resample(steamgen,1,7);
u1=steamgen(:,5)';
y=steamgen(:,9)';
N_tr=960;
%N_tr=1372;
n=60;
d=12;  %%start from flatten

for main=d:-1:1
    for i=(n+1):N_tr
        for j=(i+1):N_tr
            a=abs(y(1,i)-y(1,j));
            sum=0;
            for k=main:d
                sum=sum+(u1(1,i-k)-u1(1,j-k))^2;
            end
            L(i,j,main)=a/sqrt(sum);
        end
    end
end
for i=1:d
    for j=1:3
    max_L(i,:)=max(L(:,:,i));
    max_L_T(i,:)=max(L(:,:,i)');
    max_L(i,:)=sort(max_L(i,:));
    max_L_T(i,:)=sort(max_L_T(i,:));
    end
end
for i=1:d
    total(i,:)=[max_L(i,:) max_L_T(i,:)];
    total(i,:)=sort(total(i,:),'descend');
end

p=1;
for i=1:d
    mult=1;
    for k=1:p
       mult=mult*sqrt(d-i+1)*total(i,k+1);
    end
    L_n_d(i)=mult^(1/p);
end
figure
semilogy((L_n_d),'r.','MarkerSize',20)

xlabel('Lag')
ylabel('Lipschitz Number')
