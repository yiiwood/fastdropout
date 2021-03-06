function [w, finalObj, exitflag] = minFuncsd(funObj, X, y, W, options)
    eps0 = 10;
    f = 0.998;
    pi = 0.5;
    pf = 0.99;
    T = 500;
    w = W;
    deltatm1 = 0;
    batchsize = 100;
    numdata = size(X,1);
    fprintf('Batchsize:%d\tMaxIter:%d\tNumdata:%d\n', ...
        batchsize, options.maxIter, numdata)
    for t = 1:options.maxIter
        if t<T
            pt = t/T*pi + (1-t/T)*pf;
        else
            pt = pf; 
        end
        epst = eps0 * f^t;
        
        batchobj = 0;
        for b = 1:ceil(size(X,1)/batchsize)
            select = (b-1)*batchsize+1:min(b*batchsize, numdata);
            [finalObj, g] = funObj(w,X(select, :), y(select,:));
            g = g / length(select);
            finalObj = finalObj / length(select);
            batchobj = batchobj + finalObj;
            
            deltat = pt * deltatm1 - (1-pt)*epst * g;
            w = w + deltat;
            deltatm1 = deltat;
        end
        fprintf('%d\t%f\t%f\n', t, batchobj, norm(deltat))
        
    exitflag = 1;

    end
end