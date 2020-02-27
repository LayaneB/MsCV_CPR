function [ TransFc,F ] = precond( TransFc,F)
%UNTITLED8 Summary of this function goes here
%   Detailed explanation goes
    n = size(TransFc,2);
    TransFc(1:size(TransFc,2)+1:end) = diag(TransFc) - sum(TransFc,2);
end

