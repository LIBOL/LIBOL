function [model, result] = ol_train(Y, X, options)
% ol_train: the main interface to call an online algorithm for training
%--------------------------------------------------------------------------
% INPUT:
%        Y:    the label vector, e.g., Y(t) is the label of t-th instance;
%        X:    training data matrix, e.g., X(t,:) denotes for t-th instance;
%  options:    a struct of predefined parameters and training settings;
% id_list -    a (rand) permutation of the input sequence index: 1,2,...,T;
%
% OUTPUT:
%       model: a struct of the weight vector (w) and the SV indexes
%      result: a struct of storing training results
%  err_count - total number of training errors
%   run_time - cumulative time cost consumed by the algorithm at a tick
%   mistakes - a vector recording the sequence of online mistake rates
%      nb_SV - a vector recording the sequence of the SV sizes
%      ticks - a vector recording the online sequence of time ticks
%--------------------------------------------------------------------------
% @LIBOL 2012 Contact: chhoi@ntu.edu.sg
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
% Initialize parameters
%--------------------------------------------------------------------------
ID       = options.id_list;
n        = length(ID); % sample size
d        = size(X,2);  % dimensionality
t_tick   = options.t_tick;
mistakes = [];
SV       = [];
nb_SV    = [];
ticks    = [];
err_count= 0;
if strcmp(options.task_type,'bc'),
    nb_class=2;
elseif strcmp(options.task_type, 'mc'),
    nb_class=max(Y);
end
model    = init_model(options, d, nb_class); % init model.w=(0,...,0);
%--------------------------------------------------------------------------
% BEGIN of the main algorithm
%--------------------------------------------------------------------------
tic
f_ol = options.method;    % get the name of OL function
for t = 1:length(ID),
    id  = ID(t);
    y_t = Y(id);
    x_t = X(id,:);
    % Making prediction & update
    if options.language == 1
        [model, hat_y_t, l_t] = feval(f_ol, y_t, x_t', model);
    else
        [model, hat_y_t, l_t] = feval(f_ol, y_t, x_t, model);
    end
    % Counting Error
    if (hat_y_t ~= y_t),
        err_count = err_count + 1; 
    end
    % Add new SV
    if (l_t > 0),
        SV = [SV id];
    end
    % Recording Status
    run_time = toc;
    if (mod(t,t_tick)==0)
        mistakes = [mistakes err_count/t];
        nb_SV    = [nb_SV length(SV)];
        ticks    = [ticks run_time];
    end
end
%--------------------------------------------------------------------------
% END OF the main algorithm and OUTPUT
%--------------------------------------------------------------------------
result.run_time = toc;
result.err_count = err_count;
result.mistakes = mistakes;
result.ticks = ticks;
result.nb_SV = nb_SV;
model.SV = SV;
fprintf(1,'%s: The cumulative mistake rate = %.3f%% (%d/%d), CPU time cost: %.3fs\n',options.method,100*err_count/n,err_count,n,result.run_time);
%THE END
