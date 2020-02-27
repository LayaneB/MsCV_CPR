function [ TransFc,F ] = precond3( TransFc,F)
%UNTITLED8 Summary of this function goes here
%   Detailed explanation goes
   
    ref = diag(TransFc) == 1 & (sum(TransFc,2) == 1);
    %TransFc(ref,ref) = 
    
    TransFc(1:size(TransFc,2)+1:end) = diag(TransFc) - sum(TransFc,2);
end

