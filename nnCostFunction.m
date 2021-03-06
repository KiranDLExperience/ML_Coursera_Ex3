function [J grad] = nnCostFunction(nn_params, ...
                                   input_layer_size, ...
                                   hidden_layer_size, ...
                                   num_labels, ...
                                   X, y, lambda)
%NNCOSTFUNCTION Implements the neural network cost function for a two layer
%neural network which performs classification
%   [J grad] = NNCOSTFUNCTON(nn_params, hidden_layer_size, num_labels, ...
%   X, y, lambda) computes the cost and gradient of the neural network. The
%   parameters for the neural network are "unrolled" into the vector
%   nn_params and need to be converted back into the weight matrices. 
% 
%   The returned parameter grad should be a "unrolled" vector of the
%   partial derivatives of the neural network.
%

% Reshape nn_params back into the parameters Theta1 and Theta2, the weight matrices
% for our 2 layer neural network
Theta1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));

Theta2 = reshape(nn_params((1 + (hidden_layer_size * (input_layer_size + 1))):end), ...
                 num_labels, (hidden_layer_size + 1));

% Setup some useful variables
m = size(X, 1);
         
% You need to return the following variables correctly 
J = 0;
Theta1_grad = zeros(size(Theta1));
Theta2_grad = zeros(size(Theta2));

% ====================== YOUR CODE HERE ======================
% Instructions: You should complete the code by working through the
%               following parts.
%
% Part 1: Feedforward the neural network and return the cost in the
%         variable J. After implementing Part 1, you can verify that your
%         cost function computation is correct by verifying the cost
%         computed in ex4.m
%
% Part 2: Implement the backpropagation algorithm to compute the gradients
%         Theta1_grad and Theta2_grad. You should return the partial derivatives of
%         the cost function with respect to Theta1 and Theta2 in Theta1_grad and
%         Theta2_grad, respectively. After implementing Part 2, you can check
%         that your implementation is correct by running checkNNGradients
%
%         Note: The vector y passed into the function is a vector of labels
%               containing values from 1..K. You need to map this vector into a 
%               binary vector of 1's and 0's to be used with the neural network
%               cost function.
%
%         Hint: We recommend implementing backpropagation using a for-loop
%               over the training examples if you are implementing it for the 
%               first time.
%
% Part 3: Implement regularization with the cost function and gradients.
%
%         Hint: You can implement this around the code for
%               backpropagation. That is, you can compute the gradients for
%               the regularization separately and then add them to Theta1_grad
%               and Theta2_grad from Part 2.
%


% Part 1
%Compute Cost
AddColumn = ones(size(X,1),1);
A1 = [AddColumn,X];

A2= sigmoid(A1*Theta1');

A2 = [AddColumn, A2];
A3= sigmoid(A2*Theta2');
%recode y as matrix
y_zeros = zeros(size(y,1),num_labels);
for p=1:size(y,1)
    index = y(p,1);
    y_zeros(p,index) = 1;
end
y = y_zeros;
cost = y.*log(A3) + ((1-y).*log(1-A3));

J = -1/m * sum(sum(cost));

J_Reg_Term = (lambda/(2*m))*(sum(sum(Theta1(:,(2:end)).^2)) + sum(sum(Theta2(:,(2:end)).^2)));
J = J + J_Reg_Term;
%...............................
%Part 2

for i=1:m %forward and backward propagation
    a1 = X(i,:)';   %one value row
    a1 = [1;a1];
    a2 = sigmoid(Theta1*a1);
    a2 = [1;a2];
    a3 = sigmoid(Theta2*a2);
    yi = y(i,:)';
    delta3 = a3-yi;
    delta2 = (delta3*Theta2).*sigmoidGradient(a2);
    delta2 = delta2(:,(2:end));
   
    Theta1_gd = (delta2*a1');
    Theta2_gd = (delta3*a2');

    Theta1_grad = Theta1_grad + Theta1_gd;
    Theta2_grad = Theta2_grad + Theta2_gd;
end

Theta1_grad = (1/m)*Theta1_grad ;
Theta2_grad = (1/m)*Theta2_grad ;
% Delta3 = a3 - y;
% gradientofSigmoid = sigmoidGradient(a2);
% Delta2 = (Theta2'*Delta3).*gradientofSigmoid;
% Delta2 = Delta2(:,(2:end));  %bias term removal
% 
% Theta1_grad = (1/m)*(Delta2'*a1);
% Theta2_grad = (1/m)*(Delta3'*a2);
% 
% 
% Part 3 - Regularization Term



Theta1_grad_Reg_Term = (lambda/m)*(Theta1(:,2:end));
Theta2_grad_Reg_Term = (lambda/m)*(Theta2(:,2:end));


Theta1_grad(:,2:end) = Theta1_grad(:,2:end) + Theta1_grad_Reg_Term;
Theta2_grad(:,2:end) = Theta2_grad(:,2:end)+ Theta2_grad_Reg_Term;

% -------------------------------------------------------------

% =========================================================================

% Unroll gradients
grad = [Theta1_grad(:) ; Theta2_grad(:)];


end
