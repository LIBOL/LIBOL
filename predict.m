function [pred_Y, acc_result] = predict(Y,X,model)
% predict(Y,X,model): make prediction based on the input model
%--------------------------------------------------------------------------
% predict: making batch prediction using any model trained
%--------------------------------------------------------------------------
% @LIBOL 2012 Contact: chhoi@ntu.edu.sg
%--------------------------------------------------------------------------
if nargin<3,
    disp('Insufficient arguments.'); return;
end
%% Prediction
if strcmp(model.task_type,'bc'),
    n = length(Y);
    pred_Y  = sign(model.w*X');
    correct = sum(pred_Y == Y');
    acc_result = correct/n;
    fprintf('Prediction Accuracy = %.3f%% (%d/%d)\n',100*acc_result,correct,n);
elseif strcmp(model.task_type,'mc'),
    n = length(Y);
    [pred_value, pred_Y] = max(model.W*X');
    correct = sum(pred_Y == Y');
    acc_result = correct/n;
    fprintf('Prediction Accuracy = %.3f%% (%d/%d)\n',100*acc_result,correct,n);
end

