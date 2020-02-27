function [ OR ] = genRestrictionOperator(nelem, npar)
%genProlongationOperator Generates Restriction Operator
%   INPUT:
%   nelem = number of elements in the mesh
%   npar = number of partions
%   OUTPUT:
%   OR = Restriction operator
    global coarseelem
    OR = sparse(zeros([npar , nelem]));
    for ii = 1:npar;
        OR(ii,coarseelem{ii}) = 1;
    end
    %OR = sparse(OR);
end

