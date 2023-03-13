function runSpectral(cluster_K, ensemble_num)
disp("==========run spectral clustering.==================")
disp(ensemble_num)
% ensemble number
%T = 10;

% add file path
addpath(genpath("./function"));
data_path = pwd();

data_path = erase(data_path,"BiobjectiveFruitFlyOptimizationAlgorithm");
addpath(genpath(strcat(data_path,"OutputData/9_latent_data")));

output_data = strcat(data_path,"OutputData/");
addpath(genpath(output_data));


% obtian the .mat data name
path = strcat(data_path,"OutputData/9_latent_data");
file_name = dir(fullfile(path));
File = file_name(3:end);
flag = true;
for data_j = 1:length(File)
    file_mat =  dir(fullfile(path, File(data_j).name, '*.mat'));
    if (flag == true)
        file_mat_summary = cell(length(file_mat), length(File));
        flag = false;
    end
    for data_i = 1:length(file_mat)
        file_mat_summary(data_i, data_j) = {file_mat(data_i).name};
    end
end

clearvars file_name flag file_mat data_i data_j;
% select data
select_data = file_mat_summary;
clearvars file_mat_summary；

for data_i = 1:size(select_data,1)
    latent_data = {};
    cell_number={};
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  data name  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    name_data = regexprep(cell2mat(erase(select_data(data_i, 1), ...
        ["-",".mat"])), '\d*', '');
    disp(name_data);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   test   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % ture label
    original_data = load(cell2mat(fullfile(path,File(1).name,'/', ...
        cellstr(select_data(data_i, 1)))));
    true_label = original_data.original_label;
    % data true K
    cluster_K = length(unique(true_label));
    clearvars original_data;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  load data  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    parfor data_j = 1:size(select_data, 2)
        original_data = load(cell2mat(fullfile(path,File(data_j).name,'/', ...
            cellstr(select_data(data_i, data_j)))));
        % latent data
        latent_data(data_j) = {original_data.lantent_data};
        cell_number(data_j) = {size(original_data.lantent_data,1)};
    end
    cell_number = cell2mat(cell_number);
    basic_clustering_sum = zeros(cell_number(1), size(select_data, 2)*ensemble_num);
    for data_j = 1:size(select_data, 2)
        data_j
        basic_clustering_part = zeros(cell_number(1), ensemble_num);
        %%%%%%%%%%%%%%%%%%%  Label = USPEC(fea, k);  %%%%%%%%%%%%%%%%%%%%%%%
        parfor t = 1:ensemble_num
            basic_clustering_part(:,t) = USPEC(cell2mat(latent_data(data_j)), cluster_K);
        end
        basic_clustering_sum(:, (1+(data_j-1)*ensemble_num):data_j*ensemble_num) = basic_clustering_part;
    end
    outputfile = strcat(output_data, "/spectral_cluster_K_", num2str(cluster_K), ".csv");
    writematrix(basic_clustering_sum, outputfile);
end
end