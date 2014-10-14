function [model, hat_y_t, l_t] = M_OGD(y_t, x_t, model)
% M_OGD: Multiclass Online Gradient Descent algorithms (M-OGD)
%--------------------------------------------------------------------------
% Reference:
% - M. Zinkevich. Online convex programming and generalized infinitesimal 
%   gradient ascent. In ICML 2003.
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
eta = model.C;         % learning rate
%--------------------------------------------------------------------------
% Prediction
%--------------------------------------------------------------------------
F_t = W*x_t';
[F_max,hat_y_t]=max(F_t);
%% compute the hingh loss and support vector
Fs = F_t;
Fs(y_t) = -inf;
[Fs_max, s_t] = max(Fs);
l_t = max(0, 1 - (F_t(y_t) - F_t(s_t))); 
%--------------------------------------------------------------------------
% Making Update
%--------------------------------------------------------------------------
if (l_t > 0),
    eta_t   = eta/sqrt(model.t);
    model.W(y_t,:) = W(y_t,:) + eta_t*x_t;
    model.W(s_t,:) = W(s_t,:) - eta_t*x_t;
end
model.t = model.t + 1; % iteration no
% THE END
