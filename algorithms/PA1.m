function [model, hat_y_t, l_t] = PA1(y_t, x_t, model)
% PA1: Passive-Aggressive (PA) learning algorithms (PA-I variant)
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
w     = model.w;
C     = model.C;
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
l_t = max(0,1-y_t*f_t);
if (l_t > 0)
    s_t     = norm(x_t)^2;
    gamma_t = min(C,l_t/s_t); % PA-I
    w       = w + gamma_t*y_t*x_t;
end
model.w = w;
%THE END