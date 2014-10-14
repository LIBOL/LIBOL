function [model, hat_y_t, l_t] = M_PerceptronS(y_t, x_t, model)
% M_PerceptronS: Multi-class Perceptron Algorithms with similarity-score update.
%--------------------------------------------------------------------------
%Reference:
%Koby Crammer and Yoram Singer. Ultraconservative online algorithms for multiclass problems.
%Journal of Machine Learning Research, 3:951¨C991, 2003.
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
E = [];
for i = 1:length(F_t)
    if (F_t(i) > F_t(y_t)),
        E = [E,i];
    end
end
norm_E = length(E);
%--------------------------------------------------------------------------
% Making Update
%--------------------------------------------------------------------------
l_t = (hat_y_t ~= y_t); % 0 - correct prediction, 1 - incorrect
if (l_t > 0),
    model.W(y_t,:) = W(y_t,:) + x_t;
    if norm_E > 0
        denominator = sum(F_t(E)) - norm_E*F_t(y_t);
        for i = 1:norm_E
            s_t = E(i);
            numerator = F_t(s_t) - F_t(y_t);
            model.W(s_t,:) = W(s_t,:) - (numerator/denominator)*x_t;
        end
    end
end
% THE END




