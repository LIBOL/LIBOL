function [ options ] = init_options(method,n,task_type)
% init_options: initialize the options for each method
%--------------------------------------------------------------------------
% INPUT:
%       method:     method name
%       n:          number of training instances in the database
%       task_type:  type of task (bc or mc)
% OUTPUT:
%       options:    the generated options
%
%--------------------------------------------------------------------------
% @LIBOL 2012 Contact: chhoi@ntu.edu.sg
%--------------------------------------------------------------------------
if nargin <1,
    method = 'Perceptron';
end
options.method = method;
options.t_tick = round(n/15); %10;
options.task_type = task_type;
rand('seed',0);
options.id_list= randperm(n);
 
UPmethod = upper(method);
if (length(UPmethod) > 2) && strcmp(UPmethod(end-1:end), '_C')
    options.language = 1;  % C 
else
    options.language = 0;  % Matlab
end

if strcmp(task_type, 'bc'),
    switch upper(method)
        case {'PERCEPTRON','ROMMA','AROMMA','PERCEPTRON_C','PA','PA_C','ROMMA_C','AROMMA_C'}
            return;
        case {'WINNOW'}
            options.C = 1;
            return;
        case {'PA1','PA2','PA1_C','PA2_C'}
            options.C = 1;
            return;
        case {'ALMA','ALMA_C'}
            options.eta = 0.9;  % alpha(eta) \in (0,1]
            options.p   = 2;
            options.C   = sqrt(2);
            return;
        case {'OGD','OGD_C'}
            options.t = 1;      % iteration no, learning rate eta_t = 1/sqrt(t)
            options.loss_type = 1; % type of loss (0, 0-1 loss, 1 - hinge, 2-log, 3-square )
            options.C = 1;
            return;
        case {'CW','CW_C'}
            options.eta = 0.7;  % in \eta in [0.5,1]
            options.a   = 1;
            return;
        case {'AROW','AROW_C'}
            options.C = 1;      % i.e., parameter r
            options.a = 1;      % default
            return;
        case {'SOP','SOP_C'}
            options.a = 1;
            return;
        case {'IELLIP','IELLIP_C'}
            options.b = 0.3;
            options.IELLIP_c = 0.1; % c=0.5
            options.a = 1;
            return;
        case {'SCW','SCW_C'}
            options.eta = 0.75;
            options.C   = 1;
            options.a   = 1;
            return;
        case {'SCW2','SCW2_C'}
            options.eta = 0.90;
            options.C   = 1;
            options.a   = 1;
            return;
        case {'NAROW','NAROW_C'}
            options.C = 1; %i.e., parameter r
            options.NAROW_b = 1;
            options.a = 1;
            return;
        case {'NHERD','NHERD_C'}
            options.C = 1; % NHERD_C = C
            options.a = 1;
            return;
        case {'NEW_ALGORITHM','NEW_ALGORITHM_C'}
            % initialie your parameters here...
            return;            
        otherwise
            disp('Unknown method.');
    end
elseif strcmp(task_type, 'mc')
    switch upper(method)
        case {'M_PERCEPTRONM','M_PERCEPTRONM_C','MROMMA','MAROMMA','MROMMA_C','MAROMMA_C'}
            return;
        case {'M_PERCEPTRONU','M_PERCEPTRONU_C'}
            return;
        case {'M_PERCEPTRONS','M_PERCEPTRONS_C'}
            return;  
        case {'M_OGD','M_OGD_C'}
            options.t = 1;      % iteration no, learning rate eta_t = 1/sqrt(t)
            options.C = 1;
            return;
        case {'M_PA','M_PA_C','M_PA1','M_PA2','M_PA1_C','M_PA2_C'}
            options.C = 1;
            return;
        case {'M_CW','M_CW_C'}
            options.eta = 0.75;
            options.a   = 1;
            return;  
        case {'M_SCW1','M_SCW2','M_SCW1_C','M_SCW2_C'}
            options.eta = 0.75;
            options.a   = 1;
            options.C   = 1;
        case {'M_AROW','M_AROW_C'}
            options.C = 1;      % i.e., parameter r
            options.a = 1;      % default
            return;             
        case {'NEW_ALGORITHM','NEW_ALGORITHM_C'}
            % initialie your parameters here...
            return;            
        otherwise
            disp('Unknown method.');
    end
end
