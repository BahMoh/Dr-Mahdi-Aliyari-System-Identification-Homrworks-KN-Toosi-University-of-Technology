clc
clear
close all

load('Data_1.mat')

xyz_trn1 =[trn_P'  trn_T']
xyz_tst1 =[tst_P'  tst_T']
xyz_vrf1 =[vrf_P'  vrf_T'] 
save Dataset_Q4 xyz_trn1 xyz_tst1 xyz_vrf1


clc
clear
close all

load('Data_noise_L.mat')

xyz_trn1 =[trn_P'  trn_T']
xyz_tst1 =[tst_P'  tst_T']
xyz_vrf1 =[vrf_P'  vrf_T']

save Dataset_Q4_Low_noise xyz_trn1 xyz_tst1 xyz_vrf1

clc
clear
close all
load('Data_noise_M.mat')

xyz_trn1 =[trn_P'  trn_T']
xyz_tst1 =[tst_P'  tst_T']
xyz_vrf1 =[vrf_P'  vrf_T']

save Dataset_Q4_Medium_noise xyz_trn1 xyz_tst1 xyz_vrf1

clc
clear
close all
load('Data_noise_H.mat')

xyz_trn1 =[trn_P'  trn_T']
xyz_tst1 =[tst_P'  tst_T']
xyz_vrf1 =[vrf_P'  vrf_T']

save Dataset_Q4_High_noise xyz_trn1 xyz_tst1 xyz_vrf1