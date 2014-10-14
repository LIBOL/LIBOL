function [model, hat_y_t, l_t] = M_AROW(y_t, x_t, model)
% M_AROW: Multi-class Adaptive Regularization of Weights
%--------------------------------------------------------------------------
% Reference:
% - Adaptive Regularization of Weight Vectors 
%   Koby Crammer, Alex Kulesza, Mark Dredze.
%   Machine Learning, 2013 
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
W   = model.W;
Sigma = model.Sigma;
r     = model.r;
%--------------------------------------------------------------------------
% Prediction
%--------------------------------------------------------------------------
F_t = W*x_t';
[F_max,hat_y_t]=max(F_t);
%% compute the hingh loss and support vector
Fs=F_t;
Fs(y_t)=-inf;
[Fs_max, s_t]=max(Fs);
m_t = F_t(y_t) - F_t(s_t);
v_t=x_t*Sigma*x_t';
l_t = max(0,1-m_t); % hinge loss
%--------------------------------------------------------------------------
% Making Update
%--------------------------------------------------------------------------
if l_t > 0,
    beta_t  = 1/(v_t + r);
    alpha_t = l_t*beta_t;
    model.W(y_t,:)= W(y_t,:) + (alpha_t*Sigma*x_t')';
    model.W(s_t,:) = W(s_t,:) - (alpha_t*Sigma*x_t')';
    model.Sigma=Sigma- beta_t*Sigma*x_t'*x_t*Sigma;
end
% THE END





