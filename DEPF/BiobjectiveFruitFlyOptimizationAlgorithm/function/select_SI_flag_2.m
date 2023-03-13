function [SI_flag, LWEA_label, label] = select_SI_flag_2(fold_i,group_data,name_data,Z, ...
                                        base_cluster,ture_label_K, indUnique, indAll)
    label = zeros(size(group_data,1),1);
    % consensus cluster
    [consensus_result] = ECI_CA(base_cluster, 0.2, size(base_cluster,2));
    LWEA_label = runLWEA(consensus_result, ture_label_K);

    % asign label to all observation
    for ii = 1 : length(indUnique)
        label(cell2mat(indAll(ii,1)),1) = LWEA_label(ii);
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  SI  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if ture_label_K < 7
            SI = -inf;
    else
        if  size(group_data,1) < 1000
            SI = -0.2;
        else
            SI = -0.6;
        end
    end
    [SI_value,h] = silhouette(group_data,label);
%     mkdir("./SI_figure/", name_data);
%     SI_fig = strcat("./SI_figure/",name_data,"/",num2str(fold_i),"_",num2str(Z),".fig");
%     savefig(h,SI_fig); 
    if isempty(find(SI_value < SI, 1))
        SI_flag = 1; % "+"
    else
        SI_flag = -1; % "-"
    end
end