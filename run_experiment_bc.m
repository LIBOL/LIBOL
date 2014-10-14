function run_experiment_bc(varargin)
%RUN_EXPERIMENT_BC(dataset_name, file_format, impl_lang):
%--------------------------------------------------------------------------
%This example demos how to run online learning experiments automatically. 
%Examples:
%   run_experiment_bc('svmguide3','mat','m')
%   run_experiment_bc('w1a','libsvm','c')
%   run_experiment_bc('sonar','arff','m')
%--------------------------------------------------------------------------
% @LIBOL 2012 Contact: chhoi@ntu.edu.sg
%--------------------------------------------------------------------------
task_type    = 'bc';
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
    options_PE      = init_options('Perceptron',n,task_type);
    options_ROMMA   = init_options('ROMMA',n,task_type);
    options_aROMMA  = init_options('aROMMA',n,task_type);
    options_ALMA    = init_options('ALMA',n,task_type);
    options_OGD     = init_options('OGD',n,task_type);
    options_PA      = init_options('PA',n,task_type);
    options_PA1     = init_options('PA1',n,task_type);
    options_PA2     = init_options('PA2',n,task_type);
    options_SOP     = init_options('SOP',n,task_type);
    options_IELLIP  = init_options('IELLIP',n,task_type);
    options_CW      = init_options('CW',n,task_type);
    options_NHERD   = init_options('NHERD',n,task_type);
    options_AROW    = init_options('AROW',n,task_type);
    options_NAROW   = init_options('NAROW',n,task_type);
    options_SCW     = init_options('SCW',n,task_type);
    options_SCW2    = init_options('SCW2',n,task_type);
else                              % c implementation
    options_PE      = init_options('Perceptron_c',n,task_type);
    options_ROMMA   = init_options('ROMMA_c',n,task_type);
    options_aROMMA  = init_options('aROMMA_c',n,task_type);
    options_ALMA    = init_options('ALMA_c',n,task_type);
    options_OGD     = init_options('OGD_c',n,task_type);
    options_PA      = init_options('PA_c',n,task_type);
    options_PA1     = init_options('PA1_c',n,task_type);
    options_PA2     = init_options('PA2_c',n,task_type);
    options_SOP     = init_options('SOP_c',n,task_type);
    options_IELLIP  = init_options('IELLIP_c',n,task_type);
    options_CW      = init_options('CW_c',n,task_type);
    options_NHERD   = init_options('NHERD_c',n,task_type);
    options_AROW    = init_options('AROW_c',n,task_type);
    options_NAROW   = init_options('NAROW_c',n,task_type);
    options_SCW     = init_options('SCW_c',n,task_type);
    options_SCW2    = init_options('SCW2_c',n,task_type);
end    
options_PA1     = CV_algorithm(y, xt, options_PA1);
options_PA2     = CV_algorithm(y, xt, options_PA2);
options_ALMA    = CV_algorithm(y, xt, options_ALMA);
options_IELLIP  = CV_algorithm(y, xt, options_IELLIP);
options_CW      = CV_algorithm(y, xt, options_CW);
options_NHERD   = CV_algorithm(y, xt, options_NHERD);
options_AROW    = CV_algorithm(y, xt, options_AROW);
options_NAROW   = CV_algorithm(y, xt, options_NAROW);
options_SCW     = CV_algorithm(y, xt, options_SCW);
options_SCW2    = CV_algorithm(y, xt, options_SCW2);

% START generating test ID sequence...
nb_runs = 20;
ID_list = zeros(nb_runs,n);    
for i=1:nb_runs,
    ID_list(i,:) = rand_c(1:n, i);
end
% END of generating test ID sequence

for i=1:size(ID_list,1),
    fprintf(1,'running on the %d-th trial...\n',i);
    %% Perceptron
    options_PE.id_list = ID_list(i,:);
    [model, result] = ol_train(y, xt, options_PE);
    res_PE.err(i)   = result.err_count;     res_PE.nSV(i) = length(model.SV); res_PE.time(i)= result.run_time;
    res_PE.mistakes(i,:) = result.mistakes; res_PE.nb_SV(i,:) = result.nb_SV; res_PE.ticks(i,:) = result.ticks;
    %% ROMMA
    options_ROMMA.id_list = ID_list(i,:);
    [model, result] = ol_train(y, xt, options_ROMMA);    
    res_ROMMA.err(i) = result.err_count;  res_ROMMA.nSV(i) = length(model.SV); res_ROMMA.time(i)= result.run_time; 
    res_ROMMA.mistakes(i,:) = result.mistakes; res_ROMMA.nb_SV(i,:) = result.nb_SV; res_ROMMA.ticks(i,:) = result.ticks;
    %% aROMMA
    options_aROMMA.id_list = ID_list(i,:);
    [model, result] = ol_train(y, xt, options_aROMMA);
    res_aROMMA.err(i) = result.err_count;       res_aROMMA.nSV(i) = length(model.SV); res_aROMMA.time(i)= result.run_time; 
    res_aROMMA.mistakes(i,:) = result.mistakes; res_aROMMA.nb_SV(i,:) = result.nb_SV; res_aROMMA.ticks(i,:) = result.ticks;
    %% ALMA
    options_ALMA.id_list = ID_list(i,:);
    [model, result] = ol_train(y, xt, options_ALMA);
    res_ALMA.err(i) = result.err_count;  res_ALMA.nSV(i) = length(model.SV); res_ALMA.time(i)= result.run_time; 
    res_ALMA.mistakes(i,:) = result.mistakes; res_ALMA.nb_SV(i,:) = result.nb_SV; res_ALMA.ticks(i,:) = result.ticks;
    %% OGD
    options_OGD.id_list = ID_list(i,:);
    [model, result] = ol_train(y, xt, options_OGD);
    res_OGD.err(i) = result.err_count;  res_OGD.nSV(i) = length(model.SV); res_OGD.time(i)= result.run_time; 
    res_OGD.mistakes(i,:) = result.mistakes; res_OGD.nb_SV(i,:) = result.nb_SV; res_OGD.ticks(i,:) = result.ticks;
    %% PA
    options_PA.id_list = ID_list(i,:);
    [model, result] = ol_train(y, xt, options_PA);
    res_PA.err(i) = result.err_count;  res_PA.nSV(i) = length(model.SV); res_PA.time(i)= result.run_time; 
    res_PA.mistakes(i,:) = result.mistakes; res_PA.nb_SV(i,:) = result.nb_SV; res_PA.ticks(i,:) = result.ticks;
    %% PA1
    options_PA1.id_list = ID_list(i,:);
    [model, result] = ol_train(y, xt, options_PA1);
    res_PA1.err(i) = result.err_count;  res_PA1.nSV(i) = length(model.SV); res_PA1.time(i)= result.run_time; 
    res_PA1.mistakes(i,:) = result.mistakes; res_PA1.nb_SV(i,:) = result.nb_SV; res_PA1.ticks(i,:) = result.ticks;
    %% PA2
    options_PA2.id_list = ID_list(i,:);
    [model, result] = ol_train(y, xt, options_PA2);
    res_PA2.err(i) = result.err_count;  res_PA2.nSV(i) = length(model.SV); res_PA2.time(i)= result.run_time; 
    res_PA2.mistakes(i,:) = result.mistakes; res_PA2.nb_SV(i,:) = result.nb_SV; res_PA2.ticks(i,:) = result.ticks;
    %% SOP
    options_SOP.id_list = ID_list(i,:);
    [model, result] = ol_train(y, xt, options_SOP);
    res_SOP.err(i) = result.err_count;  res_SOP.nSV(i) = length(model.SV); res_SOP.time(i)= result.run_time; 
    res_SOP.mistakes(i,:) = result.mistakes; res_SOP.nb_SV(i,:) = result.nb_SV; res_SOP.ticks(i,:) = result.ticks;
    %% IELLIP
    options_IELLIP.id_list = ID_list(i,:);
    [model, result] = ol_train(y, xt, options_IELLIP);
    res_IELLIP.err(i) = result.err_count;  res_IELLIP.nSV(i) = length(model.SV); res_IELLIP.time(i)= result.run_time; 
    res_IELLIP.mistakes(i,:) = result.mistakes; res_IELLIP.nb_SV(i,:) = result.nb_SV; res_IELLIP.ticks(i,:) = result.ticks;
    %% CW
    options_CW.id_list = ID_list(i,:);
    [model, result] = ol_train(y, xt, options_CW);
    res_CW.err(i) = result.err_count;  res_CW.nSV(i) = length(model.SV); res_CW.time(i)= result.run_time; 
    res_CW.mistakes(i,:) = result.mistakes; res_CW.nb_SV(i,:) = result.nb_SV; res_CW.ticks(i,:) = result.ticks;
    %% NHERD
    options_NHERD.id_list = ID_list(i,:);
    [model, result] = ol_train(y, xt, options_NHERD);
    res_NHERD.err(i) = result.err_count;  res_NHERD.nSV(i) = length(model.SV); res_NHERD.time(i)= result.run_time;  
    res_NHERD.mistakes(i,:) = result.mistakes; res_NHERD.nb_SV(i,:) = result.nb_SV; res_NHERD.ticks(i,:) = result.ticks;
    %% AROW
    options_AROW.id_list = ID_list(i,:);
    [model, result] = ol_train(y, xt, options_AROW);
    res_AROW.err(i) = result.err_count;  res_AROW.nSV(i) = length(model.SV); res_AROW.time(i)= result.run_time; 
    res_AROW.mistakes(i,:) = result.mistakes; res_AROW.nb_SV(i,:) = result.nb_SV; res_AROW.ticks(i,:) = result.ticks;
    %% NAROW
    options_NAROW.id_list = ID_list(i,:);
    [model, result] = ol_train(y, xt, options_NAROW);
    res_NAROW.err(i) = result.err_count;  res_NAROW.nSV(i) = length(model.SV); res_NAROW.time(i)= result.run_time; 
    res_NAROW.mistakes(i,:) = result.mistakes; res_NAROW.nb_SV(i,:) = result.nb_SV; res_NAROW.ticks(i,:) = result.ticks;
    %% SCW
    options_SCW.id_list = ID_list(i,:);
    [model, result] = ol_train(y, xt, options_SCW);
    res_SCW.err(i) = result.err_count;  res_SCW.nSV(i) = length(model.SV); res_SCW.time(i)= result.run_time; 
    res_SCW.mistakes(i,:) = result.mistakes; res_SCW.nb_SV(i,:) = result.nb_SV; res_SCW.ticks(i,:) = result.ticks;
    %% SCW-II
    options_SCW2.id_list = ID_list(i,:);
    [model, result] = ol_train(y, xt, options_SCW2);
    res_SCW2.err(i) = result.err_count;  res_SCW2.nSV(i) = length(model.SV); res_SCW2.time(i)= result.run_time;  
    res_SCW2.mistakes(i,:) = result.mistakes; res_SCW2.nb_SV(i,:) = result.nb_SV; res_SCW2.ticks(i,:) = result.ticks;
end
fprintf(1,'-------------------------------------------------------------------------------\n');
fprintf(1,'Dataset name: %s (n=%d,d=%d,m=%d) \t  nb of runs (permutations): %d \n', dataset_name, n,size(xt,2),length(unique(y)),nb_runs);
fprintf(1,'-------------------------------------------------------------------------------\n');
fprintf(1,'Algorithm: (mistake rate (m+/-std), size of SVs (m+/-std), cpu time (m+/-std))\n');
print_exp_result(options_PE,res_PE,n);
print_exp_result(options_ROMMA,res_ROMMA,n);
print_exp_result(options_aROMMA,res_aROMMA,n);
print_exp_result(options_ALMA,res_ALMA,n);
print_exp_result(options_OGD,res_OGD,n);
print_exp_result(options_PA,res_PA,n);
print_exp_result(options_PA1,res_PA1,n);
print_exp_result(options_PA2,res_PA2,n);
print_exp_result(options_SOP,res_SOP,n);
print_exp_result(options_IELLIP,res_IELLIP,n);
print_exp_result(options_CW,res_CW,n);
print_exp_result(options_NHERD,res_NHERD,n);
print_exp_result(options_AROW,res_AROW,n);
print_exp_result(options_NAROW,res_NAROW,n);
print_exp_result(options_SCW,res_SCW,n);
print_exp_result(options_SCW2,res_SCW2,n);
fprintf(1,'-------------------------------------------------------------------------------\n');
plot_exp_result(options_PE,res_PE,res_ROMMA,res_aROMMA,res_ALMA,res_OGD,res_PA,res_PA1,res_PA2,res_SOP,res_IELLIP,res_CW,res_NHERD,res_AROW,res_NAROW,res_SCW,res_SCW2);

function print_exp_result(options,res,n)
fprintf(1,'%-10s\t& %.3f $\\pm$ %.3f\t & %.1f $\\pm$ %.1f\t&%.3f $\\pm$ %.3f\\\\\n', options.method,mean(res.err)/n, std(res.err)/n, mean(res.nSV), std(res.nSV), mean(res.time), std(res.time));

function plot_exp_result(options,res_PE,res_ROMMA,res_aROMMA,res_ALMA,res_OGD,res_PA,res_PA1,res_PA2,res_SOP,res_IELLIP,res_CW,res_NHERD,res_AROW,res_NAROW,res_SCW,res_SCW2)
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
mean_mistakes_PE = mean(res_PE.mistakes);
plot(mistakes_idx, mean_mistakes_PE,'k.-');
hold on
mean_mistakes_ROMMA = mean(res_ROMMA.mistakes);
plot(mistakes_idx, mean_mistakes_ROMMA,'b-+');
mean_mistakes_aROMMA = mean(res_aROMMA.mistakes);
plot(mistakes_idx, mean_mistakes_aROMMA,'b-s');
mean_mistakes_ALMA = mean(res_ALMA.mistakes);
plot(mistakes_idx, mean_mistakes_ALMA,'b-o');
mean_mistakes_OGD = mean(res_OGD.mistakes);
plot(mistakes_idx, mean_mistakes_OGD,'c-o');
mean_mistakes_PA = mean(res_PA.mistakes);
plot(mistakes_idx, mean_mistakes_PA,'g-o');
mean_mistakes_PA1 = mean(res_PA1.mistakes);
plot(mistakes_idx, mean_mistakes_PA1,'g-*');
mean_mistakes_PA2 = mean(res_PA2.mistakes);
plot(mistakes_idx, mean_mistakes_PA2,'g-v');
mean_mistakes_SOP = mean(res_SOP.mistakes);
plot(mistakes_idx, mean_mistakes_SOP,'r-d');
mean_mistakes_CW = mean(res_CW.mistakes);
plot(mistakes_idx, mean_mistakes_CW,'r-v');
mean_mistakes_IELLIP = mean(res_IELLIP.mistakes);
plot(mistakes_idx, mean_mistakes_IELLIP,'r-o');
mean_mistakes_NHERD = mean(res_NHERD.mistakes);
plot(mistakes_idx, mean_mistakes_NHERD,'r-s');
mean_mistakes_AROW = mean(res_AROW.mistakes);
plot(mistakes_idx, mean_mistakes_AROW,'r-*');
mean_mistakes_NAROW = mean(res_NAROW.mistakes);
plot(mistakes_idx, mean_mistakes_NAROW,'r-+');
% mean_mistakes_AROWd = mean(mistakes_list_AROWd);
% plot(mistakes_idx, mean_mistakes_AROWd,'r-s');
mean_mistakes_SCW = mean(res_SCW.mistakes);
plot(mistakes_idx, mean_mistakes_SCW,'m-*');
mean_mistakes_SCW2 = mean(res_SCW2.mistakes);
plot(mistakes_idx, mean_mistakes_SCW2,'m-+');
% mean_mistakes_SCWd = mean(mistakes_list_SCWd);
% plot(mistakes_idx, mean_mistakes_SCWd,'y-s');
% legend('Perceptron','ROMMA','agg-ROMMA','PA-I','PA-II','SOP','CW','AROW','SCW-I','SCW-II');
xlabel('Number of samples');
ylabel('Online Cumulative Mistake Rate')
set(get(gca,'XLabel'),'FontSize',figure_FontSize,'verticalalignment','top');
set(get(gca,'YLabel'),'FontSize',figure_FontSize,'verticalalignment','middle');
set(findobj(get(gca,'Children'),'LineWidth',0.5),'LineWidth',2);
grid

% figure
subplot(1,3,2);
subplot('Position',[0.37 0.1 0.25 0.8]);
mean_SV_PE = mean(res_PE.nb_SV);
plot(mistakes_idx, mean_SV_PE,'k.-');
hold on
mean_SV_ROMMA = mean(res_ROMMA.nb_SV);
plot(mistakes_idx, mean_SV_ROMMA,'b-+');
mean_SV_aROMMA = mean(res_aROMMA.nb_SV);
plot(mistakes_idx, mean_SV_aROMMA,'b-s');
mean_SV_ALMA = mean(res_ALMA.nb_SV);
plot(mistakes_idx, mean_SV_ALMA,'b-o');
mean_SV_OGD = mean(res_OGD.nb_SV);
plot(mistakes_idx, mean_SV_OGD,'c-o');
mean_SV_PA = mean(res_PA.nb_SV);
plot(mistakes_idx, mean_SV_PA,'g-o');
mean_SV_PA1 = mean(res_PA1.nb_SV);
plot(mistakes_idx, mean_SV_PA1,'g-*');
mean_SV_PA2 = mean(res_PA2.nb_SV);
plot(mistakes_idx, mean_SV_PA2,'g-v');
mean_SV_SOP = mean(res_SOP.nb_SV);
plot(mistakes_idx, mean_SV_SOP,'r-d');
mean_SV_CW = mean(res_CW.nb_SV);
plot(mistakes_idx, mean_SV_CW,'r-v');
mean_SV_IELLIP = mean(res_IELLIP.nb_SV);
plot(mistakes_idx, mean_SV_IELLIP,'r-o');
mean_SV_NHERD = mean(res_NHERD.nb_SV);
plot(mistakes_idx, mean_SV_NHERD,'r-s');
mean_SV_AROW = mean(res_AROW.nb_SV);
plot(mistakes_idx, mean_SV_AROW,'r-*');
mean_SV_NAROW = mean(res_NAROW.nb_SV);
plot(mistakes_idx, mean_SV_NAROW,'r-+');
% mean_SV_AROWd = mean(SVs_AROWd);
% plot(mistakes_idx, mean_SV_AROWd,'r-s');
mean_SV_SCW = mean(res_SCW.nb_SV);
plot(mistakes_idx, mean_SV_SCW,'m-*');
mean_SV_SCW2 = mean(res_SCW2.nb_SV);
plot(mistakes_idx, mean_SV_SCW2,'m-+');
% mean_SV_SCWd = mean(SVs_SCWd);
% plot(mistakes_idx, mean_SV_SCWd,'y-s');
% legend('Perceptron','ROMMA','ALMA_{2}(0.9)','PA-I','PA-II','SOP','CW','AROW','SCW-I','SCW-II');
xlabel('Number of samples');
ylabel('Online Cumulative Number of Updates')
set(get(gca,'XLabel'),'FontSize',figure_FontSize,'verticalalignment','top');
set(get(gca,'YLabel'),'FontSize',figure_FontSize,'verticalalignment','middle');
set(findobj(get(gca,'Children'),'LineWidth',0.5),'LineWidth',2);
grid

% figure
subplot(1,3,3);
subplot('Position',[0.67 0.10 0.25 0.8]);
mean_TM_PE = mean(res_PE.ticks);
plot(mistakes_idx, mean_TM_PE,'k.-');
hold on
mean_TM_ROMMA = mean(res_ROMMA.ticks);
plot(mistakes_idx, mean_TM_ROMMA,'b-+');
mean_TM_aROMMA = mean(res_aROMMA.ticks);
plot(mistakes_idx, mean_TM_aROMMA,'b-s');
mean_TM_ALMA = mean(res_ALMA.ticks);
plot(mistakes_idx, mean_TM_ALMA,'b-o');
mean_TM_OGD = mean(res_OGD.ticks);
plot(mistakes_idx, mean_TM_OGD,'c-o');
mean_TM_PA = mean(res_PA.ticks);
plot(mistakes_idx, mean_TM_PA,'g-o');
mean_TM_PA1 = mean(res_PA1.ticks);
plot(mistakes_idx, mean_TM_PA1,'g-*');
mean_TM_PA2 = mean(res_PA2.ticks);
plot(mistakes_idx, mean_TM_PA2,'g-v');
mean_TM_SOP = mean(res_SOP.ticks);
plot(mistakes_idx, mean_TM_SOP,'r-d');
mean_TM_CW = mean(res_CW.ticks);
plot(mistakes_idx, mean_TM_CW,'r-v');
mean_TM_IELLIP = mean(res_IELLIP.ticks);
plot(mistakes_idx, mean_TM_IELLIP,'r-o');
mean_TM_NHERD = mean(res_NHERD.ticks);
plot(mistakes_idx, mean_TM_NHERD,'r-s');
mean_TM_AROW = mean(res_AROW.ticks);
plot(mistakes_idx, mean_TM_AROW,'r-*');
mean_TM_NAROW = mean(res_NAROW.ticks);
plot(mistakes_idx, mean_TM_NAROW,'r-+');
% mean_TM_AROWd = log(mean(TMs_AROWd))/log(10);
% plot(mistakes_idx, mean_TM_AROWd,'r-s');
mean_TM_SCW = mean(res_SCW.ticks);
plot(mistakes_idx, mean_TM_SCW,'m-*');
mean_TM_SCW2 = mean(res_SCW2.ticks);
plot(mistakes_idx, mean_TM_SCW2,'m-+');
% mean_TM_SCWd = log(mean(TMs_SCWd))/log(10);
% plot(mistakes_idx, mean_TM_SCWd,'y-s');
legend('Perceptron','ROMMA','agg-ROMMA','ALMA','OGD','PA','PA-I','PA-II','SOP','CW','IELLIP','NHERD','AROW','NAROW','SCW-I','SCW-II','Location','NorthWest');
xlabel('Number of samples');
ylabel('Online Cumulative Time Cost (s)')
set(get(gca,'XLabel'),'FontSize',figure_FontSize,'verticalalignment','top');
set(get(gca,'YLabel'),'FontSize',figure_FontSize,'verticalalignment','middle');
set(findobj('FontSize',10),'FontSize',figure_FontSize);
set(findobj(get(gca,'Children'),'LineWidth',0.5),'LineWidth',2);
grid
