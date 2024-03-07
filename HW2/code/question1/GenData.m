function X = GenData(na,nb,nk,r,y)
Y=[];
R=[];
L= size(y,1);
for i=nb:-1:1
   M=[zeros(nb-i+1,1)
       -y(1:L-(nb-i+1),1)];
   Y=[Y M];
end
for i=na:-1:1
    N=[zeros(na-i+nk,1)
        r(1:L-(na-i+nk),1)];
    R=[R N];
end
X=[Y R];

