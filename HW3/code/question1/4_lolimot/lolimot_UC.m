clc
clear all
close all
  
load( 'Data_1' );
load( 'Data_noise_H' );
addpath('F:\dars\MSc\4021\Identification\HW3_MohamadAlikhani_40109494\New folder\code\question1\4_lolimot\LMNtool_Version_1.5.2')

%load( 'Data_noise_M' );
%load( 'Data_noise_H' );
total_P=[trn_P tst_P vrf_P];
total_T=[trn_T tst_T vrf_T];
%% Normalize input data

total_P(1,:)=(total_P(1,:)-min(total_P(1,:)))/(max(total_P(1,:))-min(total_P(1,:)));
total_P(2,:)=(total_P(2,:)-min(total_P(2,:)))/(max(total_P(2,:))-min(total_P(2,:)));
total_P(3,:)=(total_P(3,:)-min(total_P(3,:)))/(max(total_P(3,:))-min(total_P(3,:)));

total_T=(total_T-min(total_T))/(max(total_T)-min(total_T));

total_P=total_P';
total_T=total_T';
%% shuffle
x1=randperm(466);
total_P= total_P(x1,:);
total_T = total_T(x1,1);

%% folds test in 4th section
total_P1=total_P(1:348,:);
total_T1=total_T(1:348,:);
u_test1=total_P(349:464,:);
y_test1=total_T(349:464,:);
%% test in 1th section
total_P2=total_P(117:464,:);
total_T2=total_T(117:464,:);
u_test2=total_P(1:116,:);
y_test2=total_T(1:116,:);
%% test in 2th section
total_P3=[total_P(1:116,:);total_P(233:464,:)];
total_T3=[total_T(1:116,:);total_T(233:464,:)]
u_test3=total_P(117:232,:);
y_test3=total_T(117:232,:);
%%
%% test in 3th section
total_P4=[total_P(1:232,:);total_P(349:464,:)]
total_T4=[total_T(1:232,:);total_T(349:464,:)]
u_test4=total_P(233:348,:);
y_test4=total_T(233:348,:);
%% step1_1
rand('state',0)

x=3;
LMN = lolimot;
LMN.input = total_P1;
LMN.output = total_T1;

LMN.xRegressorDegree = 1;       % use 1st order polynoms for local models (default: 1)
LMN.maxNumberOfLM = x;         % Termination criterion for maximal number of LLMs
LMN.minError = 0.01;            % Termination criterion for minimal error
LMN.kStepPrediction = 0;        % Static model
LMN.smoothness = 1;             % Less overlap between the validity functions
LMN.history.displayMode = true; % display information

LMN = LMN.train;
y_aa = calculateModelOutput(LMN, total_P1, total_T1);

y_ba = calculateModelOutput(LMN, u_test1, y_test1);

%% step1_2
rand('state',0)

x=3;
LMN2 = lolimot;
LMN2.input = u_test1;
LMN2.output = y_test1;

LMN2.xRegressorDegree = 1;       % use 1st order polynoms for local models (default: 1)
LMN2.maxNumberOfLM = x;         % Termination criterion for maximal number of LLMs
LMN2.minError = 0.01;            % Termination criterion for minimal error
LMN2.kStepPrediction = 0;        % Static model
LMN2.smoothness = 1;             % Less overlap between the validity functions
LMN2.history.displayMode = true; % display information

LMN2 = LMN2.train;
y_ab = calculateModelOutput(LMN2, total_P1, total_T1);

y_bb = calculateModelOutput(LMN2, u_test1, y_test1);

uc1=sqrt(sum((y_ab-y_aa).^2)+sum((y_ba-y_bb).^2))
%% step 2_1
rand('state',0)

x=3;
LMN = lolimot;
LMN.input = total_P2;
LMN.output = total_T2;

LMN.xRegressorDegree = 1;       % use 1st order polynoms for local models (default: 1)
LMN.maxNumberOfLM = x;         % Termination criterion for maximal number of LLMs
LMN.minError = 0.01;            % Termination criterion for minimal error
LMN.kStepPrediction = 0;        % Static model
LMN.smoothness = 1;             % Less overlap between the validity functions
LMN.history.displayMode = true; % display information

LMN = LMN.train;
y_aa = calculateModelOutput(LMN, total_P2, total_T2);

y_ba = calculateModelOutput(LMN, u_test2, y_test2);

%% step2_2
rand('state',0)

x=3;
LMN2 = lolimot;
LMN2.input = u_test2;
LMN2.output = y_test2;

LMN2.xRegressorDegree = 1;       % use 1st order polynoms for local models (default: 1)
LMN2.maxNumberOfLM = x;         % Termination criterion for maximal number of LLMs
LMN2.minError = 0.01;            % Termination criterion for minimal error
LMN2.kStepPrediction = 0;        % Static model
LMN2.smoothness = 1;             % Less overlap between the validity functions
LMN2.history.displayMode = true; % display information

LMN2 = LMN2.train;
y_ab = calculateModelOutput(LMN2, total_P2, total_T2);

y_bb = calculateModelOutput(LMN2, u_test2, y_test2);

uc2=sqrt(sum((y_ab-y_aa).^2)+sum((y_ba-y_bb).^2))

%%
%% step 3_1
rand('state',0)

x=3;
LMN = lolimot;
LMN.input = total_P3;
LMN.output = total_T3;

LMN.xRegressorDegree = 1;       % use 1st order polynoms for local models (default: 1)
LMN.maxNumberOfLM = x;         % Termination criterion for maximal number of LLMs
LMN.minError = 0.01;            % Termination criterion for minimal error
LMN.kStepPrediction = 0;        % Static model
LMN.smoothness = 1;             % Less overlap between the validity functions
LMN.history.displayMode = true; % display information

LMN = LMN.train;
y_aa = calculateModelOutput(LMN, total_P3, total_T3);

y_ba = calculateModelOutput(LMN, u_test3, y_test3);

%% step3_2
rand('state',0)

x=3;
LMN2 = lolimot;
LMN2.input = u_test3;
LMN2.output = y_test3;

LMN2.xRegressorDegree = 1;       % use 1st order polynoms for local models (default: 1)
LMN2.maxNumberOfLM = x;         % Termination criterion for maximal number of LLMs
LMN2.minError = 0.01;            % Termination criterion for minimal error
LMN2.kStepPrediction = 0;        % Static model
LMN2.smoothness = 1;             % Less overlap between the validity functions
LMN2.history.displayMode = true; % display information

LMN2 = LMN2.train;
y_ab = calculateModelOutput(LMN2, total_P3, total_T3);

y_bb = calculateModelOutput(LMN2, u_test3, y_test3);
uc3=sqrt(sum((y_ab-y_aa).^2)+sum((y_ba-y_bb).^2))

%%

%% step 4_1
rand('state',0)

x=3;
LMN = lolimot;
LMN.input = total_P4;
LMN.output = total_T4;

LMN.xRegressorDegree = 1;       % use 1st order polynoms for local models (default: 1)
LMN.maxNumberOfLM = x;         % Termination criterion for maximal number of LLMs
LMN.minError = 0.01;            % Termination criterion for minimal error
LMN.kStepPrediction = 0;        % Static model
LMN.smoothness = 1;             % Less overlap between the validity functions
LMN.history.displayMode = true; % display information

LMN = LMN.train;
y_aa = calculateModelOutput(LMN, total_P4, total_T4);

y_ba = calculateModelOutput(LMN, u_test4, y_test4);

%% step4_2
rand('state',0)

x=3;
LMN2 = lolimot;
LMN2.input = u_test4;
LMN2.output = y_test4;

LMN2.xRegressorDegree = 1;       % use 1st order polynoms for local models (default: 1)
LMN2.maxNumberOfLM = x;         % Termination criterion for maximal number of LLMs
LMN2.minError = 0.01;            % Termination criterion for minimal error
LMN2.kStepPrediction = 0;        % Static model
LMN2.smoothness = 1;             % Less overlap between the validity functions
LMN2.history.displayMode = true; % display information

LMN2 = LMN2.train;
y_ab = calculateModelOutput(LMN2, total_P4, total_T4);

y_bb = calculateModelOutput(LMN2, u_test4, y_test4);
uc4=sqrt(sum((y_ab-y_aa).^2)+sum((y_ba-y_bb).^2))

%% uc
uc=(uc1+uc2+uc3+uc4)/4