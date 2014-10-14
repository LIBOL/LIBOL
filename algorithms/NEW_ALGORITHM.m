function [model, hat_y_t, l_t] = New_Algorithm(y_t, x_t, model)
% This tempalte shows how to create your own new algorithm...
%--------------------------------------------------------------------------
% Reference:
% - Here you can cite the related publication of your new algorithm... 
% -
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
% you may want to init parameters of your algorithm if any here...

%--------------------------------------------------------------------------
% Prediction: make prediction for your online learning task
%--------------------------------------------------------------------------
% example: for binary classification
f_t = w*x_t';
if (f_t>=0)
    hat_y_t = 1;
else
    hat_y_t = -1;
end
% example: for multi-class classification 
%   F_t = W*x_t';
%   [F_max,hat_y_t]=max(F_t);
%--------------------------------------------------------------------------
% Making Update
%--------------------------------------------------------------------------
% *** DEFINE your LOSS function ***
% e.g.  l_t = (hat_y_t ~= y_t);  % for Percetron
%       l_t = max(0,1-y_t*f_t);  % for PA (hinge loss)
l_t = (hat_y_t ~= y_t);
if (l_t > 0),
    % *** DEFINE your UPDATE function ***
    % e.g.:  model.w = w + y_t*x_t; for Perceptron 
    model.w = w + y_t*x_t;
end
%THE END