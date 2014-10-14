function [model, hat_y_t, l_t] = IELLIP(y_t, x_t, model)
% IELLIP: Improved Ellipsoid method
%--------------------------------------------------------------------------
% Reference:
% Liu Yang, Rong Jin, Jieping Ye: Online learning by ellipsoid method. 
% ICML 2009: 145.
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
c_t   = model.c_t;
b     = model.b;
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
l_t = (hat_y_t ~= y_t); % 0 - correct prediction, 1 - incorrect
v_t = x_t*Sigma*x_t';   % confidence
m_t = y_t*f_t;          % margin
if (l_t > 0),
    if v_t ~= 0,
        alpha_t = (1-m_t)/sqrt(v_t);
        g_t     = y_t*x_t/sqrt(v_t);
        S_x_t   = g_t*Sigma';
        w       = w + alpha_t*S_x_t;
        Sigma   = (Sigma - c_t*S_x_t'*S_x_t)/(1-c_t);
%        w       = w + (alpha_t*Sigma*g_t')';
%        Sigma=(Sigma-c_t*Sigma*g_t'*g_t*Sigma)/(1-c_t);
    end
end
model.c_t   = c_t*b;
model.w     = w;
model.Sigma = Sigma;
% THE END