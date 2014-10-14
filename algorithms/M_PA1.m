function [model, hat_y_t, l_t] = M_PA1(y_t, x_t, model)
% M_PA1: Multiclass Passive-Aggressive (M-PA-I) learning algorithms
%--------------------------------------------------------------------------
% Reference:
% - Koby Crammer, Ofer Dekel, Joseph Keshet, Shai Shalev-Shwartz, and Yoram
% Singer. Online passive-aggressive algorithms. JMLR, 7:551?85, 2006.
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
C     = model.C;
%--------------------------------------------------------------------------
% Prediction
%--------------------------------------------------------------------------
F_t = W*x_t';
[F_max,hat_y_t]=max(F_t);
%% compute the hingh loss and support vector
Fs=F_t;
Fs(y_t)=-inf;
[Fs_max, s_t]=max(Fs);
l_t = max(0, 1 - (F_t(y_t) - F_t(s_t))); 
%--------------------------------------------------------------------------
% Making Update
%--------------------------------------------------------------------------
if (l_t > 0),
    eta_t = min(C, l_t/(2*norm(x_t)^2));
    model.W(y_t,:) = W(y_t,:) + eta_t*x_t;
    model.W(s_t,:) = W(s_t,:) - eta_t*x_t;
end
% THE END
