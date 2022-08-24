%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                   %
% This is a demo for the LWEA and LWGP algorithms. If you find this %
% code useful for your research, please cite the paper below.       %
%                                                                   %
% Dong Huang, Chang-Dong Wang, and Jian-Huang Lai.                  %
% "Locally weighted ensemble clustering."                           %
% IEEE Transactions on Cybernetics, 2018, 48(5), pp.1460-1473.      %
%                                                                   %
% The code has been tested in Matlab R2014a and Matlab R2015a on a  %
% workstation with Windows Server 2008 R2 64-bit.                   %
%                                                                   %
% https://www.researchgate.net/publication/316681928                %
%                                                                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function resultsLWEA = runLWEA(S, ks)
% Input: the co-association matrix
%        and the numbers of clusters.
% Output: clustering results by LWEA-AL.

N = size(S,1);

d = stod2(S); clear S %convert similarity matrix to distance vector
% average linkage 
%  Agglomerative hierarchical cluster tree（凝聚成层次聚类树）
Zal = linkage(d,'average'); clear d
% complete, average have problem

resultsLWEA = zeros(N, numel(ks));
% disp('.');
 for i = 1:numel(ks)
     K = ks(i);
%     disp(['Obtain ',num2str(K),' clusters by LWEA.']); 
%     tic;
    % Construct agglomerative clusters from linkages(从聚类树结构中构建聚类)
    resultsLWEA(:,i) = cluster(Zal,'maxclust',K);
%     toc;
 end
% disp('.');
end