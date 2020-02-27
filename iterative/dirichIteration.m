function [ out] = dirichIteration(A,B,x, numit)
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
    end
    
    out = x;

end

