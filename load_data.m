function [ xt, y, n] = load_data(varargin)
% load_data: load a dataset
%--------------------------------------------------------------------------
%  nargin - number of arguments
%  varargin - set of input arguments
%
% Examples:
%  [ xt, y, n] = load_data(dataset_name, file_format, task_type);
%--------------------------------------------------------------------------
% @LIBOL 2012 Contact: chhoi@ntu.edu.sg
%--------------------------------------------------------------------------
file_format = varargin{2};
task_type   = varargin{3};
switch file_format
    case 'mat' % matlab format
            dataset_name    = varargin{1};
            load(sprintf('data/%s.mat',dataset_name));
            [n,d]   = size(data);
            xt      = data(:,2:d); y = data(:,1);        
    case 'libsvm'
        dataset_name = varargin{1};
        [y,xt]  = libsvmread(sprintf('data/%s',dataset_name));
        xt      = full(xt);
        y       = full(y);
        n       = length(y);
    case 'arff'
        dataset_name = varargin{1};
        data    = arff2matlab(sprintf('data/%s.arff',dataset_name));
        [n,d]   = size(data);
        xt      = data(:,1:d-1); y = data(:,d);
    otherwise
        disp('The file format is not supported.'); return; 
end
% for binary-class data set in binary-class settings
if ((length(unique(y))==2) && strcmp(task_type,'bc')),
    y = y - min(y); % convert to [0, max-min]
    y = y/max(y);   % convert to [0, 1]
    y = 2*y - 1;    % convert to [-1 1]
end
% for binary-class data set in multi-class setting
if ((length(unique(y))==2) && strcmp(task_type,'mc') && (min(y)<=0)),
    y = y - min(y) + 1; % shift from -1,0,1,2... to 1,2,3,4,...
end
% for multi-class data set
if ((length(unique(y))>2) && (min(y)<=0)),
    y = y - min(y) + 1; % shift from -1,0,1,2... to 1,2,3,4,...
end