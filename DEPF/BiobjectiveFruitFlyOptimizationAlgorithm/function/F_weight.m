function [N,W] = F_weight(p1,p2,M)
%产生(约)M维均匀分布的向量,每个向量各维之和恒为1
% [P1 = 13, P2 = 0, P3 = 3]
    [N,W] = T_weight(p1,M);
    if p2 > 0
        [N2,W2] = T_weight(p2,M);
        N = N+N2;
        W = [W;W2/2+1/(2*M)];
    end
end

function [N,W] = T_weight(H,M)
    % [H = 13, M = 3]
    % nchoosek: Cn(k) N = (13+3-1)/(3-1) = 105
    N = nchoosek(H+M-1,M-1);
    % B = REPMAT(A,[M,N]) Temp[105,2]
    Temp = nchoosek(1:H+M-1,M-1)-repmat(0:M-2,nchoosek(H+M-1,M-1),1)-1;
    % W[105, 3]
    W = zeros(N,M);
    W(:,1) = Temp(:,1)-0;
    for i = 2 : M-1
        W(:,i) = Temp(:,i)-Temp(:,i-1);
    end
    W(:,end) = H-Temp(:,end);
    W = W/H;
end

