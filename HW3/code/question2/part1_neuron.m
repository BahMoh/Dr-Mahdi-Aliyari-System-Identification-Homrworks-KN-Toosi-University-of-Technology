clc
clear
close all
load( 'Data' ); 
 

total_P=[GS PA WS];
total_T=[TM];

%% Normalize input data

total_P(:,1)=(total_P(:,1)-min(total_P(:,1)))/(max(total_P(:,1))-min(total_P(:,1)));
total_P(:,2)=(total_P(:,2)-min(total_P(:,2)))/(max(total_P(:,2))-min(total_P(:,2)));
total_P(:,3)=(total_P(:,3)-min(total_P(:,3)))/(max(total_P(:,3))-min(total_P(:,3)));

total_T=(total_T-min(total_T))/(max(total_T)-min(total_T));

total_P=total_P';
total_T=total_T';
rand('state',0)

%% Structure identification of MLP
max_epochs = 1000;       % Maximum number of epochs
max_hidden = 30;        % Maximum number of hidden layer neurons
num_epochs = zeros(max_hidden,1);
trn_mse = zeros(max_hidden,1);
tst_mse = zeros(max_hidden,1);

for num_neuron = 1:max_hidden
    % Defining network
    net = newff(total_P,total_T,num_neuron,{'tansig','purelin'},'traingd','learngd','mse');
    net.trainParam.epochs = max_epochs;
    net.dividefcn = 'dividerand';
    net.divideParam.trainRatio = 0.4636;  net.divideParam.valRatio = 0.2682;  net.divideParam.testRatio = 0.2682;
    
    % Training network with fixed structure for 10 times
    for cnt = 1:10
        net = init(net);        % Initializing network
        [net,tr_record] = train(net,total_P,total_T);
        num_epochs(num_neuron) = num_epochs(num_neuron) + tr_record.best_epoch/10;
        trn_mse(num_neuron) = trn_mse(num_neuron) + tr_record.perf(tr_record.best_epoch+1)/10;
        tst_mse(num_neuron) = tst_mse(num_neuron) + tr_record.vperf(tr_record.best_epoch+1)/10;
    end
    num_epochs(num_neuron) = round(num_epochs(num_neuron));
end
figure     % Plot Performance Vs. Number of neurons in hidden layer
plot(1:max_hidden,trn_mse,'b',1:max_hidden,tst_mse,'r','LineWidth',1.5);
xlabel('Number of neurons in hidden layer');  ylabel('MSE');
legend('Training performance','Validation performance');  grid on
grid on

%%FINAL:5 NEURON
