function [model, hat_y_t, l_t] = OGD(y_t, x_t, model)
% OGD: Online Gradient Descent (OGD) algorithms
%--------------------------------------------------------------------------
% Reference:
% - Martin Zinkevich. Online convex programming and generalized infinitesimal 
% gradient ascent. In ICML, pages 928?36, 2003.
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
w         = model.w;
loss_type = model.loss_type; % type of loss
eta       = model.C;         % learning rate
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
eta_t   = eta/sqrt(model.t); % learning rate = eta*(1/sqrt(t));
switch loss_type
    case 0 % 0-1 loss
        l_t = (hat_y_t ~= y_t); % 0 - correct prediction, 1 - incorrect        
        if (l_t > 0)
            model.w = w + eta_t*y_t*x_t;
        end        
    case 1 % hinge loss
        l_t = max(0,1-y_t*f_t);
        if (l_t > 0)            
            model.w = w + eta_t*y_t*x_t;
        end        
    case 2 % logistic loss
        l_t = log(1+exp(-y_t*f_t));
        if (l_t > 0)
            model.w = w + eta_t*y_t*x_t*(1/(1+exp(y_t*f_t)));
        end        
    case 3 % square loss 
        l_t = 0.5*(y_t - f_t)^2;
        if (l_t > 0)
            model.w = w - eta_t*(f_t-y_t)*x_t;
        end
    otherwise
        disp('Invalid loss type.');
        return;
end
%if (l_t > 0)
%    eta_t   = 1/sqrt(model.t); %gamma_t = min(C,l_t/s_t);(PA-I)    
%    model.w = w + eta_t*y_t*x_t;
%end
model.t = model.t + 1; % iteration no
%THE END