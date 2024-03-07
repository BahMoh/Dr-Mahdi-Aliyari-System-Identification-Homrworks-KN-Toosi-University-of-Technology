function [u,d]=binrand(T,N,tmin,t0,dist)
if (strcmp(dist,'normal')==1)
    m=randn(1,N-1);
elseif strcmp(dist,'uniform')==1
    m=rand(1,N-1);
else
    disp('Bad Command')
end
m_normalized=(m-min(m))/(max(m)-min(m));
n=(((T(end)-t0+1)/(N-1))-tmin)*m_normalized+tmin;
d=round(n);
d=[d,T(end)-t0+1-sum(d)];
u=zeros(1,t0-1);
r=round(rand(1,1))+1;
for i=1:length(d)
    switch r
        case 1
            u=[u,ones(1,d(i))];
            r=round(rand(1,1))+2;
        case 2
            u=[u,-ones(1,d(i))];
            r=round(rand(1,1))+2;
            r=1;
        case 3
            u=[u,0*ones(1,d(i))];
            r=round(rand(1,1))+1;
        otherwise
    end
end
u=u';
end