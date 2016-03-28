%% Initialization
clear ; close all; clc

%% Setup the parameters 
input_layer_size  = 400;  
hidden_layer1_size = 62;
hidden_layer2_size = 62;
hidden_layer3_size = 62;   
num_labels = 62;

fprintf('Loading and Visualizing Data ...\n')

load('20-20data.mat');
m = size(X, 1);

% Randomly select 100 data points to display
sel = randperm(size(X, 1));
sel = sel(1:200);

displayData(X(sel, :));
%%
fprintf('\nInitializing Neural Network Parameters ...\n')

%initial_Theta1 = randInitializeWeights(input_layer_size, hidden_layer1_size);
%initial_Theta2 = randInitializeWeights(hidden_layer1_size,hidden_layer2_size);
%initial_Theta3 = randInitializeWeights(hidden_layer2_size,hidden_layer3_size);
%initial_Theta4 = randInitializeWeights(hidden_layer3_size,num_labels);
% Unroll parameters

load('theta.mat');
initial_Theta1=Theta1;
initial_Theta2=Theta2;
initial_Theta3=Theta3;
initial_Theta4=Theta4;

initial_nn_params = [initial_Theta1(:) ; initial_Theta2(:);initial_Theta3(:);initial_Theta4(:)];


fprintf('\nTraining Neural Network... \n')

options = optimset('GradObj', 'on','MaxIter', 5000);
lambda = 2;
cost_function = @(p) costfunction(p,input_layer_size,hidden_layer1_size,hidden_layer2_size,hidden_layer3_size,num_labels, X, y, lambda);

% Now, costFunction is a function that takes in only one argument (the
% neural network parameters)
[nn_params, cost] = fmincg(cost_function, initial_nn_params, options);

% Obtain Theta1 and Theta2 back from nn_params
Theta1 = reshape(nn_params(1:hidden_layer1_size * (input_layer_size + 1)),hidden_layer1_size, (input_layer_size + 1));

Theta2 = reshape(nn_params((1 + (hidden_layer1_size * (input_layer_size + 1))):((hidden_layer1_size * (input_layer_size + 1)))+hidden_layer2_size*(hidden_layer1_size + 1)), hidden_layer2_size, (hidden_layer1_size + 1));

Theta3 = reshape(nn_params(1+ hidden_layer1_size * (input_layer_size + 1) + hidden_layer2_size*(hidden_layer1_size + 1) :(hidden_layer1_size * (input_layer_size + 1) + hidden_layer2_size*(hidden_layer1_size + 1))+ hidden_layer3_size*(hidden_layer2_size+1)),hidden_layer3_size,(hidden_layer2_size+1));


Theta4 = reshape(nn_params(1+ hidden_layer1_size * (input_layer_size + 1) + hidden_layer2_size*(hidden_layer1_size + 1) + hidden_layer3_size*(hidden_layer2_size+1):end),num_labels,(hidden_layer3_size+1));

fprintf('\nVisualizing Neural Network... \n')
%%
%load('theta20-20.mat');
%load('round3_data.mat');
%X=im2double(X);
displayData(Theta1(:,2:end));
save('theta.mat','Theta1','Theta2','Theta3','Theta4');
pred = predict(Theta1, Theta2,Theta3,Theta4, X);

fprintf('\nTraining Set Accuracy: %f\n', mean(double(pred == y)) * 100);
