function [model] = init_model(options,d,nb_class)
% init_model: initialize a classification model
%--------------------------------------------------------------------------
% INPUT:
%  options:     method name and setting
%        d:     data dimensionality
% nb_class:     number of class labels
% OUTPUT:
%    model:     a struct of the weight vector (w) and the SV indexes
%--------------------------------------------------------------------------
% @LIBOL 2012 Contact: chhoi@ntu.edu.sg
%--------------------------------------------------------------------------
if strcmp(options.task_type, 'bc'),
    model.task_type = 'bc';
    model.w = zeros(1,d); % weight vector of classifier
    switch upper(options.method)
        case {'PERCEPTRON','ROMMA','AROMMA','PERCEPTRON_C','ROMMA_C','AROMMA_C'}
            return; 
        case {'PA','PA_C'}
            return;
        case {'PA1','PA2','PA1_C','PA2_C'}
            model.C     = options.C;
            return;
        case {'ALMA','ALMA_C'}
            model.alpha = options.eta;
            model.p     = options.p;            
            model.C     = options.C;
            model.k_AL  = 1;    
            return;
        case {'OGD','OGD_C'}
            model.t         = options.t;        % iteration number
            model.loss_type = options.loss_type;% loss type
            model.C         = options.C;
            return;
        case {'CW','CW_C'}
            model.Sigma = options.a*eye(d);
            model.eta   = options.eta;
            model.phi   = norminv(options.eta,0,1);% should use the inverse of normal function
            return;
        case {'AROW','AROW_C'}
            model.r     = options.C;        % parameter of AROW
            model.Sigma = options.a*eye(d); % parameter of AROW
            return;
        case {'SOP','SOP_C'}
            model.Sigma = options.a*eye(d); % parameter of SOP
            return;
        case {'IELLIP','IELLIP_C'}
            model.b     = options.b;
            model.c_t   = options.IELLIP_c;
            model.Sigma = options.a*eye(d);
            return;
        case {'SCW','SCW2','SCW_C','SCW2_C'}
            model.Sigma = options.a*eye(d);
            model.C     = options.C;
            %model.eta   = options.eta;
            model.phi   = norminv(options.eta,0,1);% should use the inverse of normal function
            return;
        case {'NAROW','NAROW_C'}
            model.b     = options.C;        % parameter of NAROW
            model.Sigma = options.a*eye(d); % parameter of NAROW
            return;
        case {'NHERD','NHERD_C'}
            model.gamma       = 1/options.C;
            model.Sigma = options.a*eye(d); % parameter of NAROW
            return;
        case {'NEW_ALGORITHM','NEW_ALGORITHM_C'}
            % initialize the parameters of your algorithm...
            return;
        otherwise
            disp('Unknown method.');
    end
elseif strcmp(options.task_type, 'mc'),
    model.task_type = 'mc';
    model.W = zeros(nb_class,d);
    model.nb_class = nb_class;
    switch upper(options.method)
        case {'M_PERCEPTRONM','M_PERCEPTRONM_C','M_ROMMA','M_AROMMA','M_ROMMA_C','M_AROMMA_C'}
            return;
        case {'M_PERCEPTRONU','M_PERCEPTRONU_C'}
            return;
        case {'M_PERCEPTRONS','M_PERCEPTRONS_C'}
            return;
        case {'M_PA','M_PA_C','M_PA1','M_PA2','M_PA1_C','M_PA2_C'}
            model.C     = options.C;            
            return; 
        case {'M_OGD','M_OGD_C'}
            model.C   = options.C;          % learning rate parameter
            model.t   = options.t;          % iteration number
            return;
        case {'M_CW','M_CW_C'}
            model.Sigma = options.a*eye(d);
            model.eta   = options.eta;
            model.phi   = norminv(options.eta,0,1);% should use the inverse of normal function
            return;
        case {'M_SCW1','M_SCW2','M_SCW1_C','M_SCW2_C'}
            model.Sigma = options.a*eye(d);
            %model.eta   = options.eta;
            model.phi   = norminv(options.eta,0,1);% should use the inverse of normal function
            model.C     = options.C;
            return;
        case {'M_AROW','M_AROW_C'}
            model.Sigma = options.a*eye(d);
            model.r     = options.C;        % parameter of MAROW
            model.Sigma = options.a*eye(d); % parameter of MAROW          
            return;            
        case {'NEW_ALGORITHM','NEW_ALGORITHM_C'}
            % initialize the parameters of your algorithm...
            return;            
        otherwise
            disp('Unknown method.');
    end
end
