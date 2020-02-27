function [ out] = sorDirichIteration(A,B,x, numit, wreal, itnum, fx)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    global npar
    presDirch = zeros(size(x,1),npar);
    
    for ii = 1:numit       
        presDirch = zeros(size(x,1),npar);
        
        for jj = 1:npar
           pressDirch(:,jj) =  solvDich(A,B,x,jj);         
        end
        x = sum(pressDirch,2);
        [ x, err, iter, flag ] = sor(A, x, B, wreal, itnum, fx);
        
    end
    
    out = x;

end

