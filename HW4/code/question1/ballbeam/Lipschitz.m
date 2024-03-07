%% Lipschitz system1
clc; clear all;close all;
load ballbeam.dat
ballbeam = resample(ballbeam,1,1);
u1=ballbeam(:,1)';
y=ballbeam(:,2)';
N_tr=650;
n=60;
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
%%%
clc; clear all;close all;
load ballbeam.dat
ballbeam = resample(ballbeam,1,1);
u1=ballbeam(:,1)';
y=ballbeam(:,2)';
N_tr=650;
n=60;
d=28;

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


