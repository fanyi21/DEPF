function V = fit_obj(X, CR, flag)
    cp = valid_compactness(X, CR); 
    Dev=Devation(X, CR);      
    if flag == 1
        V = [1000*cp, Dev];
    else
        V = [-1000*cp, -Dev];
    end
end
