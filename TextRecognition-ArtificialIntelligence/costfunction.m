function [J grad] = costfunction(nn_params,input_layer_size,hidden_layer1_size,hidden_layer2_size,hidden_layer3_size,num_labels, X, y, lambda)



Theta1 = reshape(nn_params(1:hidden_layer1_size * (input_layer_size + 1)),hidden_layer1_size, (input_layer_size + 1));

Theta2 = reshape(nn_params((1 + (hidden_layer1_size * (input_layer_size + 1))):((hidden_layer1_size * (input_layer_size + 1)))+hidden_layer2_size*(hidden_layer1_size + 1)), hidden_layer2_size, (hidden_layer1_size + 1));

Theta3 = reshape(nn_params(1+ hidden_layer1_size * (input_layer_size + 1) + hidden_layer2_size*(hidden_layer1_size + 1) :(hidden_layer1_size * (input_layer_size + 1) + hidden_layer2_size*(hidden_layer1_size + 1))+ hidden_layer3_size*(hidden_layer2_size+1)),hidden_layer3_size,(hidden_layer2_size+1));


Theta4 = reshape(nn_params(1+ hidden_layer1_size * (input_layer_size + 1) + hidden_layer2_size*(hidden_layer1_size + 1) + hidden_layer3_size*(hidden_layer2_size+1):end),num_labels,(hidden_layer3_size+1));

%%%%%%%%%%%%%%%%%%%%%%%%
m = size(X, 1); %size of training set

%%%%%%%%%%%%%%%%%%%parameters to compute
J = 0;
Theta1_grad = zeros(size(Theta1));
Theta2_grad = zeros(size(Theta2));
Theta3_grad = zeros(size(Theta3));
Theta4_grad = zeros(size(Theta4));
%%%%%%%%%%%
Y=zeros(m,num_labels);

for c=1:num_labels,
Y(:,c)=y==c;
end
 
 
%%%%%%%%%%%%%%%%%%%%%%%



X=[ones(m,1),X];
a2=sigmoid(X*Theta1');
a2=[ones(size(a2,1),1),a2];
a3=sigmoid(a2*Theta2');
a3=[ones(size(a3,1),1),a3];
a4=sigmoid(a3*Theta3');
a4=[ones(size(a4,1),1),a4];
h=sigmoid(a4*Theta4');
theta1_temp=Theta1;
theta1_temp(:,1)=0;
theta2_temp=Theta2;
theta2_temp(:,1)=0;
theta3_temp=Theta3;
theta3_temp(:,1)=0;
theta4_temp=Theta4;
theta4_temp(:,1)=0;

J= sum(diag(Y'*(log((1-h)./h)))' - sum(log(1-h)));
J=(J/m + (lambda/(2*m))*(sum(sum(theta1_temp.^2)) + sum(sum(theta2_temp.^2)) + sum(sum(theta3_temp.^2))  + sum(sum(theta4_temp.^2))  ));


delta5=h-Y;
delta4=(delta5*Theta4);
delta4=delta4(:,2:hidden_layer3_size + 1).*sigmoidGradient(a3*Theta3');
delta3=(delta4*Theta3);
delta3=delta3(:,2:hidden_layer2_size + 1).*sigmoidGradient(a2*Theta2');
delta2=(delta3*Theta2);
delta2=delta2(:,2:hidden_layer1_size + 1).*sigmoidGradient(X*Theta1');


Theta1_grad=(delta2'*X)/m +(lambda/m)*(theta1_temp);
Theta2_grad=(delta3'*a2)/m  + (lambda/m)*(theta2_temp);
Theta3_grad=(delta4'*a3)/m  + (lambda/m)*(theta3_temp);
Theta4_grad=(delta5'*a4)/m  + (lambda/m)*(theta4_temp);


grad = [Theta1_grad(:) ; Theta2_grad(:) ; Theta3_grad(:) ; Theta4_grad(:)];

