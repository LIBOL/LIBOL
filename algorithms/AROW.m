function [model, hat_y_t, l_t] = AROW(y_t, x_t, model)
% AROW: Adaptive Regularization Of Weight vectors
%--------------------------------------------------------------------------
% Reference:
% "Adaptive Regularization Of Weight Vectors", Koby Crammer, Alex Kulesza
% and Mark Dredze, NIPS, 2009.
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
r     = model.r;
%--------------------------------------------------------------------------
% Prediction
%--------------------------------------------------------------------------
f_t = w*x_t';
if (f_t>=0)
    hat_y_t = 1;
else
    hat_y_t = -1;
end
%--------------------------------------------------------------------------
% Making Update
%--------------------------------------------------------------------------
m_t = f_t;              % margin
v_t = x_t*Sigma*x_t';   % confidence
l_t = max(0,1-m_t*y_t); % hinge loss
if l_t > 0,
    beta_t  = 1/(v_t + r);
    alpha_t = l_t*beta_t;
    S_x_t   = x_t*Sigma';
    w       = w + alpha_t*y_t*S_x_t;
    Sigma   = Sigma - beta_t*S_x_t'*S_x_t;    
%    w       = w + (alpha_t*y_t*Sigma*x_t')';
%    Sigma   = Sigma - beta_t*Sigma*x_t'*x_t*Sigma;
end
model.w     = w;
model.Sigma = Sigma;
%THE END