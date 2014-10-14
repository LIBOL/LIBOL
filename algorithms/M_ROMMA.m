function [model, hat_y_t, l_t] = M_ROMMA(y_t, x_t, model)
% M_ROMMA: Multi-class ROMMA algorithms.
%--------------------------------------------------------------------------
%Reference:
% Yi Li, Philip M. Long: The Relaxed Online Maximum Margin Algorithm. 
% Machine Learning 46(1-3): 361-387 (2002)
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
W     = model.W;
%--------------------------------------------------------------------------
% Prediction
%--------------------------------------------------------------------------
F_t = W*x_t';
[F_max,hat_y_t]=max(F_t);
%% compute the hingh loss and support vector
Fs=F_t;
Fs(y_t)=-inf;
[Fs_max, s_t]=max(Fs);
%--------------------------------------------------------------------------
% Making Update
%--------------------------------------------------------------------------
l_t = (hat_y_t ~= y_t); % 0 - correct prediction, 1 - incorrect
if (l_t > 0),
    norm_W = norm(W,'fro');
    if (norm_W == 0),
        model.W(y_t,:) = W(y_t,:) + x_t;
        model.W(s_t,:) = W(s_t,:) - x_t;
    else
        c_t = (2*norm(x_t)^2*norm_W^2 - (F_t(y_t) - F_t(s_t)))/(2*norm(x_t)^2*norm_W^2 - (F_t(y_t) - F_t(s_t))^2);
        d_t = (norm_W^2*(1 - (F_t(y_t) - F_t(s_t))))/(2*norm(x_t)^2*norm_W^2 - (F_t(y_t) - F_t(s_t))^2);
        W = W*c_t;
        model.W(y_t,:) = W(y_t,:) + d_t*x_t;
        model.W(s_t,:) = W(s_t,:) - d_t*x_t;
    end
end
% THE END

