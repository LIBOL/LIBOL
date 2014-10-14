function run_experiment(varargin)
%RUN_EXPERIMENT  Run online learning expriments automatically
%RUN_EXPERIMENT(task_type, dataset_name, file_format, impl_lang):
%--------------------------------------------------------------------------
% 'task_type' - define the types of tasks, which include two options:
%            'bc' binary classification or 'mc' multiclass classification
% 'dataset_name' - define the input dataset name 
% 'file_format' - define the file format of dataset, 
%     which includes 3 options: 'mat' (default), 'libsvm', 'arff' (WEKA)
% 'impl_lang' - implementation type: 'm' (default matlab) or 'c'
%
% Examples:
%   run_experiment
%   run_experiment('bc')
%   run_experiment('mc')
%   run_experiment('bc','svmguide3')
%   run_experiment('bc','svmguide3','mat','m')
%   run_experiment('bc','svmguide3','mat','c')
%   run_experiment('bc','w1a','libsvm','c')
%   run_experiment('bc','sonar','arff','m')
%   run_experiment('mc','glass','mat','m')
%   run_experiment('mc','glass','mat','c')
%   run_experiment('mc','segment','mat','c')
%--------------------------------------------------------------------------
% @ LIBOL 2012-2013 
% Contact: chhoi@ntu.edu.sg
%--------------------------------------------------------------------------

% parse the input arguments
[task_type, dataset_name, file_format, impl_lang] = parse_arg(varargin{:});

switch task_type,
    case 'bc'
        run_experiment_bc(dataset_name, file_format, impl_lang);
    case 'mc'
        run_experiment_mc(dataset_name, file_format, impl_lang);
    otherwise
        disp('Unknown task.');   
end

%%
function [task_type, dataset_name, file_format,impl_lang] = parse_arg(varargin)
%PARSE_ARG Parses the input arguments
%
switch nargin,
    case 0
        task_type       = 'bc';
        dataset_name    = 'svmguide3';
        file_format     = 'mat';
        impl_lang       = 'm'; % matlab
    case 1
        task_type       = varargin{1};
        if strcmp(varargin{1},'mc'),
            dataset_name    = 'glass';           
        else % binary classification
            dataset_name    = 'svmguide3';            
        end
        file_format     = 'mat';
        impl_lang      = 'm'; % matlab
    case 2
        task_type       = varargin{1};
        dataset_name    = varargin{2};
        file_format     = 'mat';
        impl_lang       = 'm'; % matlab
    case 3
        task_type       = varargin{1};
        dataset_name    = varargin{2};
        file_format     = varargin{3};
        impl_lang       = 'm'; % matlab
    case 4
        task_type       = varargin{1};
        dataset_name    = varargin{2};
        file_format     = varargin{3};
        impl_lang       = varargin{4};
    otherwise
        disp('wrong argument.');
        return;
end