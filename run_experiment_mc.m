function run_experiment_mc(varargin)
% run_experiment (dataset_name, file_format, impl_lang):
%--------------------------------------------------------------------------
% This example demos how to run online learning experiments automatically. 
% Examples:
%   run_experiment_mc('glass','mat','m')
%   run_experiment_mc('vowel','mat','c')
%--------------------------------------------------------------------------
% @LIBOL 2012 Contact: chhoi@ntu.edu.sg
%--------------------------------------------------------------------------
task_type    = 'mc';
dataset_name = varargin{1};
file_format  = varargin{2};
impl_lang    = varargin{3};

% load the data from the given filename
[xt, y, n] = load_data(dataset_name, file_format, task_type);

% check argument
if arg_check(task_type, y) ~= 0
  disp(['Error: Dataset is not for "' task_type '" task.']);
  return;
end

%% run experiments:
%rand('seed',0);
if (impl_lang == 'm'),    % matlab implementation
    options_PEM      = init_options('M_PerceptronM',n,task_type);
    options_PEU      = init_options('M_PerceptronU',n,task_type);
    options_PES      = init_options('M_PerceptronS',n,task_type);
    options_MRO      = init_options('M_ROMMA',n,task_type);
    options_MAR      = init_options('M_aROMMA',n,task_type);
    options_MOG      = init_options('M_OGD',n,task_type);
    options_PAM      = init_options('M_PA',n,task_type);
    options_PAM1     = init_options('M_PA1',n,task_type);
    options_PAM2     = init_options('M_PA2',n,task_type);
    options_MCW      = init_options('M_CW',n,task_type);
    options_MAROW    = init_options('M_AROW',n,task_type);
    options_MSCW1    = init_options('M_SCW1',n,task_type);
    options_MSCW2    = init_options('M_SCW2',n,task_type);
else % c implementation
    options_PEM      = init_options('M_PerceptronM_c',n,task_type);
    options_PEU      = init_options('M_PerceptronU_c',n,task_type);
    options_PES      = init_options('M_PerceptronS_c',n,task_type);
    options_MRO      = init_options('M_ROMMA_c',n,task_type);
    options_MAR      = init_options('M_aROMMA_c',n,task_type);
    options_MOG      = init_options('M_OGD_c',n,task_type);
    options_PAM      = init_options('M_PA_c',n,task_type);
    options_PAM1     = init_options('M_PA1_c',n,task_type);
    options_PAM2     = init_options('M_PA2_c',n,task_type);
    options_MCW      = init_options('M_CW_c',n,task_type);
    options_MAROW    = init_options('M_AROW_c',n,task_type);
    options_MSCW1    = init_options('M_SCW1_c',n,task_type);
    options_MSCW2    = init_options('M_SCW2_c',n,task_type);
end
options_PAM1     = CV_algorithm(y, xt, options_PAM1);
options_PAM2     = CV_algorithm(y, xt, options_PAM2);
options_MCW      = CV_algorithm(y, xt, options_MCW);
options_MAROW    = CV_algorithm(y, xt, options_MAROW);
options_MSCW1    = CV_algorithm(y, xt, options_MSCW1);
options_MSCW2    = CV_algorithm(y, xt, options_MSCW2);

% START generating test ID sequence...
nb_runs = 20;
ID_list = zeros(nb_runs,n);    
for i=1:nb_runs,
    ID_list(i,:) = rand_c(1:n, i);
end
% END of generating test ID sequence

for i=1:size(ID_list,1),
    fprintf(1,'running on the %d-th trial...\n',i);
    %% PerceptronM
    options_PEM.id_list = ID_list(i,:);
    [model, result] = ol_train(y, xt, options_PEM);
    res_PEM.err(i)   = result.err_count;     res_PEM.nSV(i) = length(model.SV); res_PEM.time(i)= result.run_time;
    res_PEM.mistakes(i,:) = result.mistakes; res_PEM.nb_SV(i,:) = result.nb_SV; res_PEM.ticks(i,:) = result.ticks;
    %% PerceptronU
    options_PEU.id_list = ID_list(i,:);
    [model, result] = ol_train(y, xt, options_PEU);
    res_PEU.err(i)   = result.err_count;     res_PEU.nSV(i) = length(model.SV); res_PEU.time(i)= result.run_time;
    res_PEU.mistakes(i,:) = result.mistakes; res_PEU.nb_SV(i,:) = result.nb_SV; res_PEU.ticks(i,:) = result.ticks;
    %% PerceptronS
    options_PES.id_list = ID_list(i,:);
    [model, result] = ol_train(y, xt, options_PES);
    res_PES.err(i)   = result.err_count;     res_PES.nSV(i) = length(model.SV); res_PES.time(i)= result.run_time;
    res_PES.mistakes(i,:) = result.mistakes; res_PES.nb_SV(i,:) = result.nb_SV; res_PES.ticks(i,:) = result.ticks;
    %% MROMMA
    options_MRO.id_list = ID_list(i,:);
    [model, result] = ol_train(y, xt, options_MRO);
    res_MRO.err(i)   = result.err_count;     res_MRO.nSV(i) = length(model.SV); res_MRO.time(i)= result.run_time;
    res_MRO.mistakes(i,:) = result.mistakes; res_MRO.nb_SV(i,:) = result.nb_SV; res_MRO.ticks(i,:) = result.ticks;
    %% MaROMMA
    options_MAR.id_list = ID_list(i,:);
    [model, result] = ol_train(y, xt, options_MAR);
    res_MAR.err(i)   = result.err_count;     res_MAR.nSV(i) = length(model.SV); res_MAR.time(i)= result.run_time;
    res_MAR.mistakes(i,:) = result.mistakes; res_MAR.nb_SV(i,:) = result.nb_SV; res_MAR.ticks(i,:) = result.ticks;
    %% MOGD
    options_MOG.id_list = ID_list(i,:);
    [model, result] = ol_train(y, xt, options_MOG);
    res_MOG.err(i)   = result.err_count;     res_MOG.nSV(i) = length(model.SV); res_MOG.time(i)= result.run_time;
    res_MOG.mistakes(i,:) = result.mistakes; res_MOG.nb_SV(i,:) = result.nb_SV; res_MOG.ticks(i,:) = result.ticks;
    %% PAM
    options_PAM.id_list = ID_list(i,:);
    [model, result] = ol_train(y, xt, options_PAM);
    res_PAM.err(i)   = result.err_count;     res_PAM.nSV(i) = length(model.SV); res_PAM.time(i)= result.run_time;
    res_PAM.mistakes(i,:) = result.mistakes; res_PAM.nb_SV(i,:) = result.nb_SV; res_PAM.ticks(i,:) = result.ticks;
    %% PAM1
    options_PAM1.id_list = ID_list(i,:);
    [model, result] = ol_train(y, xt, options_PAM1);
    res_PAM1.err(i)   = result.err_count;     res_PAM1.nSV(i) = length(model.SV); res_PAM1.time(i)= result.run_time;
    res_PAM1.mistakes(i,:) = result.mistakes; res_PAM1.nb_SV(i,:) = result.nb_SV; res_PAM1.ticks(i,:) = result.ticks;
    %% PAM2
    options_PAM2.id_list = ID_list(i,:);
    [model, result] = ol_train(y, xt, options_PAM2);
    res_PAM2.err(i)   = result.err_count;     res_PAM2.nSV(i) = length(model.SV); res_PAM2.time(i)= result.run_time;
    res_PAM2.mistakes(i,:) = result.mistakes; res_PAM2.nb_SV(i,:) = result.nb_SV; res_PAM2.ticks(i,:) = result.ticks;
    %% MCW
    options_MCW.id_list = ID_list(i,:);
    [model, result] = ol_train(y, xt, options_MCW);
    res_MCW.err(i)   = result.err_count;     res_MCW.nSV(i) = length(model.SV); res_MCW.time(i)= result.run_time;
    res_MCW.mistakes(i,:) = result.mistakes; res_MCW.nb_SV(i,:) = result.nb_SV; res_MCW.ticks(i,:) = result.ticks;
    %% MAROW
    options_MAROW.id_list = ID_list(i,:);
    [model, result] = ol_train(y, xt, options_MAROW);
    res_MAROW.err(i)   = result.err_count;     res_MAROW.nSV(i) = length(model.SV); res_MAROW.time(i)= result.run_time;
    res_MAROW.mistakes(i,:) = result.mistakes; res_MAROW.nb_SV(i,:) = result.nb_SV; res_MAROW.ticks(i,:) = result.ticks;
    %% MSCW1
    options_MSCW1.id_list = ID_list(i,:);
    [model, result] = ol_train(y, xt, options_MSCW1);
    res_MSCW1.err(i)   = result.err_count;     res_MSCW1.nSV(i) = length(model.SV); res_MSCW1.time(i)= result.run_time;
    res_MSCW1.mistakes(i,:) = result.mistakes; res_MSCW1.nb_SV(i,:) = result.nb_SV; res_MSCW1.ticks(i,:) = result.ticks;
    %% MSCW2
    options_MSCW2.id_list = ID_list(i,:);
    [model, result] = ol_train(y, xt, options_MSCW2);
    res_MSCW2.err(i)   = result.err_count;     res_MSCW2.nSV(i) = length(model.SV); res_MSCW2.time(i)= result.run_time;
    res_MSCW2.mistakes(i,:) = result.mistakes; res_MSCW2.nb_SV(i,:) = result.nb_SV; res_MSCW2.ticks(i,:) = result.ticks;
end
fprintf(1,'-------------------------------------------------------------------------------\n');
fprintf(1,'Dataset name: %s (n=%d,d=%d,m=%d) \t  nb of runs (permutations): %d \n', dataset_name, n,size(xt,2),length(unique(y)),nb_runs);
fprintf(1,'-------------------------------------------------------------------------------\n');
fprintf(1,'Algorithm: (mistake rate (m+/-std), size of SVs (m+/-std), cpu time (m+/-std))\n');
print_exp_result(options_PEM,res_PEM,n);
print_exp_result(options_PEU,res_PEU,n);
print_exp_result(options_PES,res_PES,n);
print_exp_result(options_MRO,res_MRO,n);
print_exp_result(options_MAR,res_MAR,n);
print_exp_result(options_MOG,res_MOG,n);
print_exp_result(options_PAM,res_PAM,n);
print_exp_result(options_PAM1,res_PAM1,n);
print_exp_result(options_PAM2,res_PAM2,n);
print_exp_result(options_MCW,res_MCW,n);
print_exp_result(options_MAROW,res_MAROW,n);
print_exp_result(options_MSCW1,res_MSCW1,n);
print_exp_result(options_MSCW2,res_MSCW2,n);
fprintf(1,'-------------------------------------------------------------------------------\n');
plot_exp_result(options_PEM,res_PEM,res_PEU,res_PES,res_MRO,res_MAR,res_MOG,res_PAM,res_PAM1,res_PAM2,res_MCW,res_MAROW,res_MSCW1,res_MSCW2);

function print_exp_result(options,res,n)
fprintf(1,'%-10s\t& %.3f $\\pm$ %.3f\t & %.1f $\\pm$ %.1f\t&%.3f $\\pm$ %.3f\\\\\n', options.method,mean(res.err)/n, std(res.err)/n, mean(res.nSV), std(res.nSV), mean(res.time), std(res.time));

function plot_exp_result(options,res_PEM,res_PEU,res_PES,res_MRO,res_MAR,res_MOG,res_PAM,res_PAM1,res_PAM2,res_MCW,res_MAROW,res_MSCW1,res_MSCW2)
mistakes_idx = [];
for t = 1:length(options.id_list),
    if (mod(t,options.t_tick)==0)
        mistakes_idx = [mistakes_idx t];
    end
end
%% print and plot results
scrsz = get(0,'ScreenSize');
%figure('Position',[1 scrsz(4)/2 scrsz(3)/2 scrsz(4)/2])
figure('Position',[50 -500+scrsz(4)/1.5 scrsz(3)/1.5 scrsz(4)/1.5])
%figure
figure_FontSize=12;
subplot(1,3,1);
subplot('Position',[0.07 0.1 0.25 0.8]);
mean_mistakes_PEM = mean(res_PEM.mistakes);
plot(mistakes_idx, mean_mistakes_PEM,'k.-');
hold on
mean_mistakes_PEU = mean(res_PEU.mistakes);
plot(mistakes_idx, mean_mistakes_PEU,'k-d');
mean_mistakes_PES = mean(res_PES.mistakes);
plot(mistakes_idx, mean_mistakes_PES,'k-o');
mean_mistakes_MRO = mean(res_MRO.mistakes);
plot(mistakes_idx, mean_mistakes_MRO,'b-+');
mean_mistakes_MAR = mean(res_MAR.mistakes);
plot(mistakes_idx, mean_mistakes_MAR,'b-s');
mean_mistakes_MOG = mean(res_MOG.mistakes);
plot(mistakes_idx, mean_mistakes_MOG,'c-o');
mean_mistakes_PAM = mean(res_PAM.mistakes);
plot(mistakes_idx, mean_mistakes_PAM,'g-o');
mean_mistakes_PAM1 = mean(res_PAM1.mistakes);
plot(mistakes_idx, mean_mistakes_PAM1,'g-*');
mean_mistakes_PAM2 = mean(res_PAM2.mistakes);
plot(mistakes_idx, mean_mistakes_PAM2,'g-v');
mean_mistakes_MCW = mean(res_MCW.mistakes);
plot(mistakes_idx, mean_mistakes_MCW,'r-v');
mean_mistakes_MAROW = mean(res_MAROW.mistakes);
plot(mistakes_idx, mean_mistakes_MAROW,'r-*');
mean_mistakes_MSCW1 = mean(res_MSCW1.mistakes);
plot(mistakes_idx, mean_mistakes_MSCW1,'m-*');
mean_mistakes_MSCW2 = mean(res_MSCW2.mistakes);
plot(mistakes_idx, mean_mistakes_MSCW2,'m-+');
xlabel('Number of samples');
ylabel('Online Cumulative Mistake Rate')
set(get(gca,'XLabel'),'FontSize',figure_FontSize,'verticalalignment','top');
set(get(gca,'YLabel'),'FontSize',figure_FontSize,'verticalalignment','middle');
set(findobj(get(gca,'Children'),'LineWidth',0.5),'LineWidth',2);
grid

% figure
subplot(1,3,2);
subplot('Position',[0.37 0.1 0.25 0.8]);
mean_SV_PEM = mean(res_PEM.nb_SV);
plot(mistakes_idx, mean_SV_PEM,'k.-');
hold on
mean_SV_PEU = mean(res_PEU.nb_SV);
plot(mistakes_idx, mean_SV_PEU,'k-d');
mean_SV_PES = mean(res_PES.nb_SV);
plot(mistakes_idx, mean_SV_PES,'k-o');
mean_SV_MRO = mean(res_MRO.nb_SV);
plot(mistakes_idx, mean_SV_MRO,'b-+');
mean_SV_MAR = mean(res_MAR.nb_SV);
plot(mistakes_idx, mean_SV_MAR,'b-s');
mean_SV_MOG = mean(res_MOG.nb_SV);
plot(mistakes_idx, mean_SV_MOG,'c-o');
mean_SV_PAM = mean(res_PAM.nb_SV);
plot(mistakes_idx, mean_SV_PAM,'g-o');
mean_SV_PAM1 = mean(res_PAM1.nb_SV);
plot(mistakes_idx, mean_SV_PAM1,'g-*');
mean_SV_PAM2 = mean(res_PAM2.nb_SV);
plot(mistakes_idx, mean_SV_PAM2,'g-v');
mean_SV_MCW = mean(res_MCW.nb_SV);
plot(mistakes_idx, mean_SV_MCW,'r-v');
mean_SV_MAROW = mean(res_MAROW.nb_SV);
plot(mistakes_idx, mean_SV_MAROW,'r-*');
mean_SV_MSCW1 = mean(res_MSCW1.nb_SV);
plot(mistakes_idx, mean_SV_MSCW1,'m-*');
mean_SV_MSCW2 = mean(res_MSCW2.nb_SV);
plot(mistakes_idx, mean_SV_MSCW2,'m-+');
xlabel('Number of samples');
ylabel('Online Cumulative Number of Updates')
set(get(gca,'XLabel'),'FontSize',figure_FontSize,'verticalalignment','top');
set(get(gca,'YLabel'),'FontSize',figure_FontSize,'verticalalignment','middle');
set(findobj(get(gca,'Children'),'LineWidth',0.5),'LineWidth',2);
grid

% figure
subplot(1,3,3);
subplot('Position',[0.67 0.10 0.25 0.8]);
mean_TM_PEM = mean(res_PEM.ticks);
plot(mistakes_idx, mean_TM_PEM,'k.-');
hold on
mean_TM_PEU = mean(res_PEU.ticks);
plot(mistakes_idx, mean_TM_PEU,'k-d');
mean_TM_PES = mean(res_PES.ticks);
plot(mistakes_idx, mean_TM_PES,'k-o');
mean_TM_MRO = mean(res_MRO.ticks);
plot(mistakes_idx, mean_TM_MRO,'b-+');
mean_TM_MAR = mean(res_MAR.ticks);
plot(mistakes_idx, mean_TM_MAR,'b-s');
mean_TM_MOG = mean(res_MOG.ticks);
plot(mistakes_idx, mean_TM_MOG,'c-o');
mean_TM_PAM = mean(res_PAM.ticks);
plot(mistakes_idx, mean_TM_PAM,'g-o');
mean_TM_PAM1 = mean(res_PAM1.ticks);
plot(mistakes_idx, mean_TM_PAM1,'g-*');
mean_TM_PAM2 = mean(res_PAM2.ticks);
plot(mistakes_idx, mean_TM_PAM2,'g-v');
mean_TM_MCW = mean(res_MCW.ticks);
plot(mistakes_idx, mean_TM_MCW,'r-v');
mean_TM_MAROW = mean(res_MAROW.ticks);
plot(mistakes_idx, mean_TM_MAROW,'r-*');
mean_TM_MSCW1 = mean(res_MSCW1.ticks);
plot(mistakes_idx, mean_TM_MSCW1,'m-*');
mean_TM_MSCW2 = mean(res_MSCW2.ticks);
plot(mistakes_idx, mean_TM_MSCW2,'m-+');
legend('M\_PerceptronM','M\_PerceptronU','M\_PerceptronS','M\_ROMMA','M\_aROMMA','M\_OGD','M\_PA','M\_PA1','M\_PA2','M\_CW','M\_AROW','M\_SCW1','M\_SCW2','Location','NorthWest');
xlabel('Number of samples');
ylabel('Online Cumulative Time Cost (s)')
set(get(gca,'XLabel'),'FontSize',figure_FontSize,'verticalalignment','top');
set(get(gca,'YLabel'),'FontSize',figure_FontSize,'verticalalignment','middle');
set(findobj('FontSize',10),'FontSize',figure_FontSize);
set(findobj(get(gca,'Children'),'LineWidth',0.5),'LineWidth',2);
grid
