function [model, hat_y_t, l_t] = NAROW(y_t, x_t, model)
% NAROW: New Adaptive Regularization Of Weights (AROW) algorithm
%--------------------------------------------------------------------------
% Reference:
% Orabona, Francesco and Crammer, Koby. "New adaptive algorithms for online
% classification." In NIPS, pp. 1840?848, 2010
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
b     = model.b;
%--------------------------------------------------------------------------
% Prediction
%--------------------------------------------------------------------------
f_t     = w*x_t';
if (f_t>=0)
    hat_y_t = 1;
else
    hat_y_t = -1;
end
%--------------------------------------------------------------------------
% Making Update
%--------------------------------------------------------------------------
v_t = x_t*Sigma*x_t'; % confidence
m_t = y_t*f_t;        % margin 
l_t = 1 - m_t;        % hinge loss
if l_t > 0,
    chi_t = x_t*Sigma*x_t'; % inv(A_{t-1}^{-1})?
    if chi_t > 1/b,
        r_t = chi_t/(b*chi_t-1);
    else
        r_t = inf;
    end
    beta_t  = 1/(v_t + r_t);
    alpha_t = max(0, 1-m_t)*beta_t;
    S_x_t   = x_t*Sigma';
    w       = w + alpha_t*y_t*S_x_t;
    Sigma   = Sigma - beta_t*S_x_t'*S_x_t;
%    w       = w + (alpha_t*y_t*Sigma*x_t')';
%    Sigma   = Sigma - beta_t*Sigma*x_t'*x_t*Sigma;
end
model.w     = w;
model.Sigma = Sigma;
%THE END