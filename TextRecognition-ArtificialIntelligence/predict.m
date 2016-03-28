function p = predict(Theta1, Theta2,Theta3,Theta4, X)
%PREDICT Predict the label of an input given a trained neural network
%   p = PREDICT(Theta1, Theta2, X) outputs the predicted label of X given the
%   trained weights of a neural network (Theta1, Theta2)

% Useful values
m = size(X, 1);
num_labels = size(Theta4, 1);

% You need to return the following variables correctly 
p = zeros(size(X, 1), 1);

%h1 = sigmoid([ones(m, 1) X] * Theta1');
%h2 = sigmoid([ones(m, 1) h1] * Theta2');






X=[ones(m,1),X];
a2=sigmoid(X*Theta1');
a2=[ones(size(a2,1),1),a2];
a3=sigmoid(a2*Theta2');
a3=[ones(size(a3,1),1),a3];
a4=sigmoid(a3*Theta3');
a4=[ones(size(a4,1),1),a4];
h=sigmoid(a4*Theta4');
[dummy, p] = max(h, [], 2);


%if p==10
%p(i)=0;

% =========================================================================
end
