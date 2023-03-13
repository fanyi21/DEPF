function runBioFOA(algorithm_name,cluster_K, res)
    disp("==========run Ensemble Pruning.==================")
    % add file path
    addpath(genpath("./function"));
    data_path = pwd();

    data_path = erase(data_path,"BiobjectiveFruitFlyOptimizationAlgorithm");
    addpath(genpath(strcat(data_path,"OutputData/9_latent_data")));

    output_data = strcat(data_path,"OutputData/");
    addpath(genpath(output_data));

    % population number
    Pop = 9;
    % max iteration
    MaxFEs = 20;
    % objective function number
    obj_num = 2;
    % sample number
    sample_number = 1000;

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
        end

        switch algorithm_name
            case "spectral"
                disp("=============  load spectral ensemble   =================")
                outputfile = strcat(output_data, "/spectral_cluster_K_", num2str(cluster_K), ".csv");
            case "Louvain"
                disp("=============  load Louvain ensemble   =================")
                outputfile = strcat(output_data, "/Louvain_resolution_", num2str(res), ".csv");
            case "Leiden"
                disp("=============  load Leiden ensemble   =================")
                outputfile = strcat(output_data, "/Leiden_resolution_", num2str(res), ".csv");
            otherwise
                error("== algorithm must be spectral or Louvain or Leiden! == ");
        end


        basic_clustering_sum = readmatrix(outputfile);

        cell_number = size(basic_clustering_sum,1);

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  sample  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % unique obbservations
        basic_clustering_char = cell(cell_number,1);
        parfor ii = 1 : cell_number
            basic_clustering_char(ii,1) = {sprintf('%d#',basic_clustering_sum(ii,:))};
        end
        % unique index
        [~, indUnique] = unique(basic_clustering_char);
        indUnique = sort(indUnique)';
        % match unique obbservations index
        indAll = cell(length(indUnique),1);
        iii = 0;
        for ii = indUnique
            iii = iii + 1;
            indAll(iii,1) = {find(strcmp(basic_clustering_char(ii,1), basic_clustering_char) == 1)};
        end
        % find out the obbservations of unique label vector
        if length(indUnique) < sample_number
            idx = datasample(indUnique,1000-length(indUnique));
            basic_clustering_unique = [basic_clustering_sum(indUnique, :);
                basic_clustering_sum(idx, :)];
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            ture_data = latent_data;
            label_axis = ones(cell_number, Pop);
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        else
            basic_clustering_unique = basic_clustering_sum(indUnique, :);
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % sample data
            ture_data = {};
            parfor ii = 1:size(latent_data,2)
                ture_data(ii) = {latent_data{ii}(indUnique, :)};
            end
            label_axis = ones(length(indUnique), Pop);
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        end
        %%%%%%%%%%%%%%%%%% SI multi-objective function %%%%%%%%%%%%%%%%%%%%%%%%%
        % select plus / minus
        SI_flag = zeros(1,size(select_data, 2));
        % modified sample label
        label_ensemble = ones(cell_number, Pop);
        if length(indUnique) < sample_number
            parfor Z = 1:size(select_data, 2)
                Z_data = cell2mat(latent_data(Z));
                [SI_flag(1,Z),~, label_ensemble(:,Z)] = ...
                    select_SI_flag_2(1, Z_data,name_data,Z, ...
                    basic_clustering_unique,cluster_K, indUnique, indAll);
                label_axis(:,Z) = label_ensemble(:,Z);
            end
        else
            parfor Z = 1:size(select_data, 2)
                Z_data = cell2mat(latent_data(Z));
                [SI_flag(1,Z),label_axis(:,Z), label_ensemble(:,Z)] = ...
                    select_SI_flag_2(1, Z_data,name_data,Z, ...
                    basic_clustering_unique,cluster_K, indUnique, indAll);
            end
        end
        if isempty(find(SI_flag == -1, 1))
            pm = 1;
        else
            pm = -1;
        end
        multiobj_fitness = ones(Pop, obj_num);
        parfor Z = 1:size(select_data, 2)
            Z_data = cell2mat(ture_data(Z));
            multiobj_fitness(Z,:) = ...
                initial_fitness_2(Z_data, label_axis(:,Z), pm);
        end
        %%%%%%%%%%%%%%   FOA optimal base cluster number %%%%%%%%%%%%%%%%%%%%%%%
        % initial population
        FEs = 1;
        Dim = size(basic_clustering_unique,2);
        obb_label = zeros(length(indUnique),1);
        X = zeros(Pop, Dim);
        Y = zeros(Pop, Dim);
        D = zeros(Pop, Dim);
        S = zeros(Pop, Dim);
        X_axis = ones(Pop, Dim);
        Y_axis = ones(Pop, Dim);
        while FEs < MaxFEs
            W = exp(((FEs-1)/MaxFEs)*log(13));
            for Pop_i = 1:Pop
                for Dim_j = 1:Dim
                    X(Pop_i, Dim_j) = X_axis(Pop_i, Dim_j) + W * rands(1,1);
                    Y(Pop_i, Dim_j) = Y_axis(Pop_i, Dim_j) + W * rands(1,1);
                    D(Pop_i, Dim_j) = (X(Pop_i, Dim_j)^2 + Y(Pop_i, Dim_j)^2)^0.5;
                    S(Pop_i, Dim_j) = (D(Pop_i, Dim_j) + eps)^(-1);
                end
                S(Pop_i, :) = S(Pop_i, :) > 0.5;
                Index_S = find(S(Pop_i, :) == 1);
                if length(Index_S) > 1
                    [consensus_result] = ECI_CA(basic_clustering_unique(:, Index_S), 0.2, length(Index_S));
                    off_label = runLWEA(consensus_result, cluster_K);
                else
                    if length(Index_S) == 1
                        off_label = basic_clustering_unique(:, Index_S);
                    else
                        Index_S = randi([1,Dim], 1, 1);
                        off_label = basic_clustering_unique(:, Index_S);
                    end
                end
                for ii = 1 : length(indUnique)
                    obb_label(cell2mat(indAll(ii,1)),1) = off_label(ii);
                end
                if length(indUnique) < sample_number
                    % fitness function
                    off_fitness = fit_obj(cell2mat(ture_data(ceil(Pop_i))), obb_label, pm);
                else
                    off_fitness = fit_obj(cell2mat(ture_data(ceil(Pop_i))), off_label, pm);
                end
                if off_fitness(1) < multiobj_fitness(Pop_i,1) && off_fitness(2) < multiobj_fitness(Pop_i,2)
                    X_axis(Pop_i,:) = X(Pop_i,:);
                    Y_axis(Pop_i,:) = Y(Pop_i,:);
                    multiobj_fitness(Pop_i,:) = off_fitness;
                    label_ensemble(:,Pop_i) = obb_label;
                end
            end
            % exchange information
            axis_X = X_axis;
            axis_Y = Y_axis;
            X_axis(1,:) = axis_X(end,:);            Y_axis(1,:) = axis_Y(end,:);
            X_axis(2:end,:) = axis_X(1:(end-1),:);  Y_axis(2:end,:) = axis_Y(1:(end-1),:);
            FEs = FEs + 1;
        end

        %---------------------------   NMI ARI  ---------------------------------%
        for rrr=1:Pop
            ZNMI(rrr,1) = round(Cal_NMI(label_ensemble(:,rrr), true_label),2);
            ZARI(rrr,1) = round(rand_index(label_ensemble(:,rrr), true_label, 'adjusted'),2);
        end
        disp("=========  NMI  ==========")
        [valuee, Indd] = max(ZNMI);
        disp(valuee);
        disp("=========  ARI  ==========")
        disp(max(ZARI));

        outputfile = strcat(output_data, "/final_clusteing.csv");
        writematrix(label_ensemble(:,Indd), outputfile);

    end
end