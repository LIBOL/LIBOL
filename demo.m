function demo(varargin)
%DEMO: demo the usage of LIBOL
% demo(task_type, algorithm_name, dataset_name, file_format, impl_lang);
%--------------------------------------------------------------------------
% Examples:
%   demo
%   demo('bc')
%   demo('mc')
%   demo('bc','PA')
%   demo('bc','SCW','svmguide3')
%   demo('bc','PA','w1a','libsvm','c')
%   demo('bc','Perceptron','sonar','arff')   % need to install WEKA
%   demo('mc','M_PerceptronM')
%   demo('mc','M_PA','glass')
%   demo('mc','M_PA','glass','mat')
%   demo('mc','M_SCW1','glass','mat','c')
%--------------------------------------------------------------------------
% @ LIBOL 2012-2013 (V0.2.0)
% Contact: chhoi@ntu.edu.sg
%--------------------------------------------------------------------------

% parse the input arguments
[task_type, algorithm_name, dataset_name, file_format] = parse_arg(varargin{:});

% load the data from the given filename
[ xt, y, n] = load_data(dataset_name, file_format, task_type); 

% check argument
if arg_check(task_type, y) ~= 0
  disp(['Error: Dataset is not for "' task_type '" task.']);
  return;
end

% initializing paramters
options = init_options(algorithm_name, n, task_type); 

% START selecting paramters...
options = CV_algorithm(y, xt, options); % auto parameter selection
% END of paramter selection.

% START generating test ID sequence...
nb_runs = 20;
ID_list = zeros(nb_runs,n);
for i=1:nb_runs,
    ID_list(i,:) = rand_c(1:n, i);
end
% END of generating test ID sequence

for i=1:size(ID_list,1),
    fprintf(1,'running on the %d-th trial...\n',i);
    options.id_list = ID_list(i,:);
    [model, result] = ol_train(y, xt, options);
    res.err(i)      = result.err_count;
    res.nSV(i)      = length(model.SV);
    res.time(i)     = result.run_time;
    res.mistakes(i,:) = result.mistakes;
    res.nb_SV(i,:)  = result.nb_SV;
    res.ticks(i,:)  = result.ticks;
end
fprintf(1,'-------------------------------------------------------------------------------\n');
fprintf(1,'Dataset name: %s (n=%d,d=%d,m=%d)\t nb of runs (permutations): %d \n', dataset_name, n,size(xt,2),length(unique(y)),nb_runs);
fprintf(1,'-------------------------------------------------------------------------------\n');
fprintf(1,'Algorithm:  \t mistake rate \t\t  nb of updates\t\t cpu time (seconds)\n');
fprintf(1,'%-12s\t %.4f +/- %.4f\t  %.2f +/- %.2f \t %.4f +/- %.4f\n', options.method,mean(res.err)/n, std(res.err)/n, mean(res.nSV), std(res.nSV), mean(res.time), std(res.time));
fprintf(1,'-------------------------------------------------------------------------------\n');
%%
function [task_type, algorithm_name, dataset_name, file_format]=parse_arg(varargin)
%PARSE_ARG Parses the input arguments
%
switch nargin,
    case 0
        task_type       = 'bc';
        algorithm_name  = 'Perceptron';
        dataset_name    = 'svmguide3';
        file_format     = 'mat';
    case 1
        task_type       = varargin{1};
        if strcmp(varargin{1},'mc'),
            algorithm_name  = 'M_PerceptronM';
            dataset_name    = 'glass';           
        else % binary classification
            algorithm_name  = 'Perceptron';
            dataset_name    = 'svmguide3';            
        end
        file_format     = 'mat';
    case 2
        task_type       = varargin{1};
        algorithm_name  = varargin{2};        
        if strcmp(varargin{1},'mc'), 
            dataset_name    = 'glass';           
        else % binary classification
            dataset_name    = 'svmguide3';
        end
        file_format     = 'mat';
    case 3
        task_type       = varargin{1};
        algorithm_name  = varargin{2};        
        dataset_name    = varargin{3};
        file_format     = 'mat';
    case 4
        task_type       = varargin{1};
        algorithm_name  = varargin{2};
        dataset_name    = varargin{3};
        file_format     = varargin{4};
    case 5
        task_type       = varargin{1};
        algorithm_name  = varargin{2};
        dataset_name    = varargin{3};
        file_format     = varargin{4};        
        if strcmp(varargin{5},'c'),    % c implementation
            algorithm_name = sprintf('%s_c',varargin{2});
        end
    otherwise
        disp('wrong arugement.'); help demo;         
        return;
end
