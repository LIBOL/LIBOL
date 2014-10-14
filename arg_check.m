function  ret = arg_check(task_type, y)
% arg_check: check arguments
%--------------------------------------------------------------------------
% INPUT:
%  task_type: 
%          y: the label vector, e.g., Y(t) is the label of t-th instance;
%
% OUTPUT:
%          0: argument check passed
%          1: argument check failed
%--------------------------------------------------------------------------
% @LIBOL 2012 Contact: chhoi@ntu.edu.sg
%--------------------------------------------------------------------------

  clsnum = length(unique(y));
  if ((strcmp(task_type, 'bc') && clsnum == 2) || ...
      (strcmp(task_type, 'mc') && clsnum >  2))
    ret = 0;
  else
    ret = 1;
  end

end
