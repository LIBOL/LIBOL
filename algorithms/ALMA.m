function [model, hat_y_t, l_t] = ALMA(y_t, x_t, model)
% ALMA: Approximate Large Margin algorithm
%--------------------------------------------------------------------------
%Reference:
% Claudio Gentile. A new approximate maximal margin classification
% algorithm. JMLR, 2:213?42, 2001.
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
alpha = model.alpha; % parameter of ALAM (i.e., alpha = eta)         
k_AL  = model.k_AL;  % parameter of ALAM
p     = model.p;     % parameter of ALAM   
C     = model.C;  
B     = 1/alpha;     
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
gamma_k = B*sqrt(p-1)/sqrt(k_AL);
l_t     = (1-alpha)*gamma_k - y_t*f_t;
if (l_t > 0),
    eta_k   = C/(sqrt(p-1)*sqrt(k_AL));
    w       = w + eta_k*y_t*x_t;
    norm_w  = norm(w);
    w       = w/(max(1,norm_w));
    k_AL    = k_AL + 1;
end
model.w     = w;
model.k_AL  = k_AL;
%THE END