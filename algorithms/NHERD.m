function [model, hat_y_t, l_t] = NHERD(y_t, x_t, model)
% NHERD: Normal Herd (NHERD) algorithm
%--------------------------------------------------------------------------
% Reference:
% Crammer, Koby and D. Lee, Daniel. Learning via gaussian herding. In NIPS,
% pp. 345?52, 2010. 
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
gamma = model.gamma;
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
v_t = x_t*Sigma*x_t';   % confidence
m_t = y_t*f_t;          % margin
l_t = 1 - m_t;          % loss
if l_t > 0,
    beta_t  = 1/(v_t + gamma); % gamma = 1/C
    alpha_t = max(0,1-m_t)*beta_t;
    S_x_t   = x_t*Sigma';
    w       = w + alpha_t*y_t*S_x_t;
    Sigma   = Sigma - beta_t^2*(v_t+2*gamma)*S_x_t'*S_x_t;   
%    w       = w + (alpha_t*y_t*Sigma*x_t')';
%    Sigma   = Sigma - beta_t^2*(v_t+2*gamma)*Sigma*x_t'*x_t*Sigma; %project
end
model.w     = w;
model.Sigma = Sigma;
%THE END