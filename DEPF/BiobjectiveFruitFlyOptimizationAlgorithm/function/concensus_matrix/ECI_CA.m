function [LWCA] = ECI_CA(baseCls, para_theta, M)
     %bcs: baseCls[124,20]每行元素对应加上[0, 5,10,15,20]
     %baseClsSegs: 100 * 124的稀疏矩阵
     [bcs, baseClsSegs] = getAllSegs(baseCls);
     
     % ECI 计算100个熵
     ECI = computeECI(bcs, baseClsSegs, para_theta);
%      M
     % 一致性矩阵 Get locally weighted co-association matrix
     LWCA= computeLWCA(baseClsSegs, ECI, M);
end

%% getAllSegs
function [bcs, baseClsSegs] = getAllSegs(baseCls)

    [N,M] = size(baseCls);
    
    bcs = baseCls;
    
    nClsOrig = max(bcs,[],1); 
    
    C = cumsum(nClsOrig); 
    
    bcs = bsxfun(@plus, bcs,[0 C(1:end-1)]); 

    nCls = nClsOrig(end)+C(end-1);
    
    baseClsSegs=sparse(bcs(:),repmat([1:N]',1,M), 1,nCls,N); 

end

%% computeECI
function ECI = computeECI(bcs, baseClsSegs, para_theta)
    M = size(bcs,2);
    ETs = getAllClsEntropy(bcs, baseClsSegs);
    ECI = exp(-ETs./para_theta./M);
end

function Es = getAllClsEntropy(bcs, baseClsSegs)
    
    baseClsSegs = baseClsSegs';
    
    [~, nCls] = size(baseClsSegs);
    
    Es = zeros(nCls,1);
    for i = 1:nCls
        partBcs = bcs(baseClsSegs(:,i)~=0,:);
        Es(i) = getOneClsEntropy(partBcs);
    end
end

function E = getOneClsEntropy(partBcs)    
    E = 0;
    for i = 1:size(partBcs,2)
        tmp = sort(partBcs(:,i));
        uTmp = unique(tmp);
        
        if numel(uTmp) <= 1
            continue;
        end
        cnts = zeros(size(uTmp));
        for j = 1:numel(uTmp)
            cnts(j)=sum(sum(tmp==uTmp(j))); 
        end
        
        cnts = cnts./sum(cnts(:));
        E = E-sum(cnts.*log2(cnts));
    end
end
%% computeLWCA
function LWCA = computeLWCA(baseClsSegs,ECI,M)
    baseClsSegs = baseClsSegs';
    N = size(baseClsSegs,1);
    LWCA = (bsxfun(@times, baseClsSegs, ECI')) * baseClsSegs' / M;    
    LWCA = LWCA-diag(diag(LWCA))+eye(N);
end
