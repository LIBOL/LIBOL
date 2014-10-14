function [model, hat_y_t, l_t] = SCW(y_t, x_t, model)
% SCW: Soft Confidence-Weighted Learning Algorithm
%--------------------------------------------------------------------------
% Reference:
% "Exact Soft Confidence-Weighted Learning", Jielei Wang, Peilin Zhao,
% Steven C.H. Hoi, ICML2012, 2012.
%--------------------------------------------------------------------------
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
C     = model.C;
phi   = model.phi;
psi   = 1+(phi^2)/2;
xi    = 1+phi^2;
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
v_t = x_t*Sigma*x_t';
m_t = y_t*f_t;
l_t = phi*sqrt(v_t)-m_t; 
if (l_t>0),
    alpha_t = max(0,(-m_t*psi+sqrt((m_t^2*phi^4)/4+v_t*phi^2*xi))/(v_t*xi));
    alpha_t = min(alpha_t, C);
    u_t     = 0.25*(-alpha_t*v_t*phi+sqrt(alpha_t^2*v_t^2*phi^2+4*v_t))^2;
    beta_t  = alpha_t*phi/(sqrt(u_t)+alpha_t*phi*v_t);
    S_x_t   = x_t*Sigma';
    w       = w + alpha_t*y_t*S_x_t;
    Sigma   = Sigma - beta_t*S_x_t'*S_x_t;
end
model.w     = w;
model.Sigma = Sigma;
%THE END