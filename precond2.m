function [ TransFc,Q ] = precond2( TransFc,Q)
%UNTITLED8 Summary of this function goes here
%   Detailed explanation goes
    
    ref1 = find((sum(TransFc,2) == 1));    
    ref2 = find(TransFc(1:size(TransFc,2)+1:end) == 1);
    ref = intersect(ref1,ref2);
  
    vec = sparse(size(TransFc,1),1);
    vec(ref) = Q(ref);
    vecn = repelem(vec,1,size(TransFc,1))';
    Q = Q - sum(TransFc.*vecn,2);
    TransFc(ref,:) = 0;
    TransFc(:,ref) = 0;
    
    n = size(TransFc,2);
    TransFc(1:size(TransFc,2)+1:end) = diag(TransFc) - sum(TransFc,2);



end

