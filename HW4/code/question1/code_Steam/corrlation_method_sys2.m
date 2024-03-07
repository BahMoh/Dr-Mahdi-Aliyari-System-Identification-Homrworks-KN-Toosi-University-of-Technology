clc
clear all
close all

load data_steamgen

%% output1
i=1;
figure(i)
i=i+1;
crosscorr(u1,y1) 
title('Corrolation(u1,y1)')
figure(i)
i=i+1;
crosscorr(u2,y1)
title('Corrolation(u2,y1)')
figure(i)
i=i+1;
crosscorr(u3,y1)
title('Corrolation(u3,y1)')
figure(i)
i=i+1;
crosscorr(u4,y1)
title('Corrolation(u4,y1)')
figure(i)
i=i+1;
crosscorr(y2,y1)
title('Corrolation(y2,y1)')
figure(i)
i=i+1;
crosscorr(y3,y1)
title('Corrolation(y3,y1)')
figure(i)
i=i+1;
crosscorr(y4,y1)
title('Corrolation(y4,y1)')
figure(i)
i=i+1;
crosscorr(y1,y1)
title('Corrolation(y1,y1)')


%% output2

figure(i)
i=i+1;
crosscorr(u1,y2)
title('Corrolation(u1,y2)')
figure(i)
i=i+1;
crosscorr(u2,y2)
title('Corrolation(u2,y2)')
figure(i)
i=i+1;
crosscorr(u3,y2)
title('Corrolation(u3,y2)')
figure(i)
i=i+1;
crosscorr(u4,y2)
title('Corrolation(u4,y2)')
figure(i)
i=i+1;
crosscorr(y1,y2)
title('Corrolation(y1,y2)')
figure(i)
i=i+1;
crosscorr(y3,y2)
title('Corrolation(y3,y2)')
figure(i)
i=i+1;
crosscorr(y4,y2)
title('Corrolation(y4,y2)')
figure(i)
i=i+1;
crosscorr(y2,y2)
title('Corrolation(y2,y2)')

%% output3

figure(i)
i=i+1;
crosscorr(u1,y3)
title('Corrolation(u1,y3)')
figure(i)
i=i+1;
crosscorr(u2,y3)
title('Corrolation(u2,y3)')
figure(i)
i=i+1;
crosscorr(u3,y3)
title('Corrolation(u3,y3)')
figure(i)
i=i+1;
crosscorr(u4,y3)
title('Corrolation(u4,y3)')
figure(i)
i=i+1;
crosscorr(y1,y3)
title('Corrolation(y1,y3)')
figure(i)
i=i+1;
crosscorr(y2,y3)
title('Corrolation(y2,y3)')
figure(i)
i=i+1;
crosscorr(y4,y3)
title('Corrolation(y4,y3)')
figure(i)
i=i+1;
crosscorr(y3,y3)
title('Corrolation(y3,y3)')
%% output4
figure(i)
i=i+1;
crosscorr(u1,y4)
title('Corrolation(u1,y4)')
figure(i)
i=i+1;
crosscorr(u2,y4)
title('Corrolation(u2,y4)')
figure(i)
i=i+1;
crosscorr(u3,y4)
title('Corrolation(u3,y4)')
figure(i)
i=i+1;
crosscorr(u4,y4)
title('Corrolation(u4,y4)')
figure(i)
i=i+1;
crosscorr(y1,y4)
title('Corrolation(y1,y4)')
figure(i)
i=i+1;
crosscorr(y2,y4)
title('Corrolation(y2,y4)')

figure(i)
i=i+1;
crosscorr(y3,y4)
title('Corrolation(y3,y4)')

figure(i)
i=i+1;
crosscorr(y4,y4)
title('Corrolation(y4,y4)')

