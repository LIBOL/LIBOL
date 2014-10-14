function [model, hat_y_t, l_t] = SOP(y_t, x_t, model)
% SOP: Second Order Perceptron algorithm
%--------------------------------------------------------------------------
% Reference:
% N. Cesa-Bianchi, A. Conconi, and C. Gentile, A second-order Perceptron
% algorithm, SIAM Journal on Computing, 34(3):640-668. SIAM, 2005.
%--------------------------------------------------------------------------
% INPUT:
%      y_t:     class label of t-th instance;
%      x_t:     t-th training data instance, e.g., X(t,:);
%    model:     classifier
%
% OUTPUT:
%    model:     a struct of the weight vector (w) and the SV indexes
%  hat_y_t:     predicted class label
%      l_t:     suffered loss
%--------------------------------------------------------------------------
% @LIBOL 2012 Contact: chhoi@ntu.edu.sg
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
% Initialization
%--------------------------------------------------------------------------
w     = model.w;
Sigma = model.Sigma;
%--------------------------------------------------------------------------
% Prediction
%--------------------------------------------------------------------------
S_x_t   = x_t*Sigma';
v_t     = x_t*S_x_t';
%v_t     = x_t*Sigma*x_t';
beta_t  = 1/(v_t+1);
Sigma_t = Sigma - beta_t*S_x_t'*S_x_t;
%Sigma_t = Sigma - beta_t*Sigma*x_t'*x_t*Sigma; 
f_t     = w*Sigma_t*x_t';
if (f_t>=0)
    hat_y_t = 1;
else
    hat_y_t = -1;
end
%--------------------------------------------------------------------------
% Making Update
%--------------------------------------------------------------------------
l_t = (hat_y_t ~= y_t); % 0 - correct prediction, 1 - incorrect    
if (l_t > 0),    
    w     = w + y_t*x_t;    
end
model.w = w;
model.Sigma = Sigma_t;
% THE END