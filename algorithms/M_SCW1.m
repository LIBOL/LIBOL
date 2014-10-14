function [model, hat_y_t, l_t] = M_SCW1(y_t, x_t, model)
% M_SCW1: Multiclass Soft Confidence Weight Learning algorithm (M-SCW-I)
%--------------------------------------------------------------------------
% Reference:
% - Soft Confidence-Weighted Learning
%   Jialei Wang, Peilin Zhao, Steven C.H. Hoi
%   Nanyang Technological University, Technical Report, 2013
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
C   = model.C;
Sigma = model.Sigma;
phi   = model.phi;
psi   = 1+(phi^2)/2;
xi    = 1+phi^2;
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
l_t = phi*sqrt(v_t) - m_t;
%--------------------------------------------------------------------------
% Making Update
%--------------------------------------------------------------------------
if m_t < phi*sqrt(v_t)
    alpha_t=max(0, (-m_t*psi+sqrt(m_t^2*psi^2-m_t^2*psi+2*v_t*phi^2*psi))/(2*v_t*psi));
    alpha_t = min(alpha_t, C);
    u_t=(1/8)*(-alpha_t*v_t*phi+sqrt(alpha_t^2*v_t^2*phi^2+8*v_t))^2;
    beta_t=alpha_t*phi/(sqrt(2*u_t)+alpha_t*phi*v_t);
    model.W(y_t,:)= W(y_t,:) + (alpha_t*Sigma*x_t')';
    model.W(s_t,:) = W(s_t,:) - (alpha_t*Sigma*x_t')';
    model.Sigma=Sigma- beta_t*Sigma*x_t'*x_t*Sigma;
end
% THE END
