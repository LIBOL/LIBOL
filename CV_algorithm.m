function [ options ] = CV_algorithm(Y,X,options)
%CV_algorithm: This aims to choose best paramters via validation automatically.
%--------------------------------------------------------------------------
% INPUT:
%        Y:    the label vector, e.g., Y(t) is the label of t-th instance;
%        X:    training data, e.g., X(t,:) denotes for t-th instance;
%  options:    a struct of predefined parameters
% OUTPUT:
%  options:    a struct of parameters with best validated values
%--------------------------------------------------------------------------
% @LIBOL 2012 Contact: chhoi@ntu.edu.sg
%--------------------------------------------------------------------------

switch upper(options.method),
    case {'PERCEPTRON','ROMMA','AROMMA','PERCEPTRON_C','PA','PA_C','ROMMA_C','AROMMA_C'}
        return;
    case {'PA1','PA2','NHERD','PA1_C','PA2_C','NHERD_C','WINNOW','OGD','OGD_C'}
        options = best_parameter_C(Y,X,options);
        return;
    case {'ALMA','ALMA_C'}
        options = best_parameter_C(Y,X,options);
        options = best_parameter_eta(Y,X,options); % i.e., alpha
        options = best_parameter_p(Y,X,options);   % i.e., p = [2,4,6,8,10]                
        return;
    case {'CW','CW_C'}
        options = best_parameter_eta(Y,X,options);
        return;
    case {'AROW','AROW_C'}
        options = best_parameter_C(Y,X,options);
        return;
    case {'SOP','SOP_C'}
        options.SOP_a = 1;
        return;
    case {'IELLIP','IELLIP_C'}
        options = best_parameter_b(Y,X,options);
        return;
    case {'SCW','SCW2','SCW_C','SCW2_C'}
        options = best_parameter_C(Y,X,options);
        options = best_parameter_eta(Y,X,options);
        return;
    case {'NAROW','NAROW_C'}
        options = best_parameter_C(Y,X,options);
        return;
    case {'M_ROMMA','M_AROMMA','M_ROMMA_C','M_AROMMA_C'}
        return;        
    case {'M_PERCEPTRONM','M_PERCEPTRONM_C','M_PERCEPTRONU','M_PERCEPTRONU_C','M_PERCEPTRONS','M_PERCEPTRONS_C'}
        return;
    case {'M_PA','M_PA_C','M_PA1','M_PA2','M_PA1_C','M_PA2_C','M_OGD','M_OGD_C'}
        options = best_parameter_C(Y,X,options);
        return;    
    case {'M_CW','M_CW_C'}
        options = best_parameter_eta(Y,X,options);
        return;   
    case {'M_SCW','M_SCW2','M_SCW_C','M_SCW2_C'}
        options = best_parameter_C(Y,X,options);
        options = best_parameter_eta(Y,X,options);
    case {'M_AROW','M_AROW_C'}
        options = best_parameter_C(Y,X,options);
        return;    
    case {'NEW_ALGORITHM','NEW_ALGORITHM_C'}
        % find the best paramters via validation below
        % options = best_paramter_....
        return;
    otherwise
        disp('Unknown method.');
end

function [options] = best_parameter_C(Y,X,options)
best_err_count  = size(X,1);
value_domain    = 2.^[-4:1:4];
for  i=1:length(value_domain),
    options.C       = value_domain(i);
    fprintf('CV: validating parameter C = %.4f\n',options.C);
    [model,result]  = ol_train(Y,X,options);
    if result.err_count <= best_err_count,
        best_err_count = result.err_count;
        best_value = value_domain(i);
    end
end
options.C = best_value;
fprintf('CV_result: The best value of parameter C = %.4f\n',options.C);

function [options] = best_parameter_eta(Y,X,options)
best_err_count  = size(X,1);
value_domain = [0.55:0.05:0.95];
for  i=1:length(value_domain),
    options.eta  = value_domain(i);
    fprintf('CV: validating parameter eta = %.4f\n',options.eta);
    [model,result]  = ol_train(Y,X,options);
    if result.err_count <= best_err_count,
        best_err_count = result.err_count;
        best_value = value_domain(i);
    end
end
options.eta = best_value;
fprintf('CV_result: The best value of parameter eta = %.4f\n',options.eta);

function [options] = best_parameter_b(Y,X,options)
best_err_count  = size(X,1);
value_domain = [0.1:0.1:0.9];
for  i=1:length(value_domain),
    options.b  = value_domain(i);
    fprintf('CV: validating parameter b = %.4f\n',options.b);
    [model,result]  = ol_train(Y,X,options);
    if result.err_count <= best_err_count,
        best_err_count = result.err_count;
        best_value = value_domain(i);
    end
end
options.b = best_value;
fprintf('CV_result: The best value of parameter b = %.4f\n',options.b);

function [options] = best_parameter_p(Y,X,options)
best_err_count  = size(X,1);
value_domain = [2:2:10];
for  i=1:length(value_domain),
    options.p  = value_domain(i);
    fprintf('CV: validating parameter p = %.4f\n',options.p);
    [model,result]  = ol_train(Y,X,options);
    if result.err_count <= best_err_count,
        best_err_count = result.err_count;
        best_value = value_domain(i);
    end
end
options.p = best_value;
fprintf('CV_result: The best value of parameter p = %d\n',options.p);
