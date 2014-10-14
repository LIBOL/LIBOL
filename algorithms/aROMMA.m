function [model, hat_y_t, l_t] = aROMMA(y_t, x_t, model)
% aROMMA: Relaxed Online Maximum Margin Algorithm (aggressive variant)
%--------------------------------------------------------------------------
% Reference:
% Yi Li and Philip M. Long. The relaxed online maxiumu margin algorithm. In
% NIPS, pages 498-504, 1999.
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
l_t = 1 - y_t*f_t; % hinge loss
if (l_t > 0),
    if (norm(w)==0)
        model.w = w + y_t*x_t;
    else
        deno=(norm(x_t)*norm(w))^2-f_t^2;
        if (deno ~= 0)
            coe_1 = ((norm(x_t)*norm(w))^2-y_t*f_t)/deno;
            coe_2 = (norm(w)^2*(y_t-f_t))/deno;
            model.w = coe_1*w + coe_2*x_t;
        end
    end
end
%THE END