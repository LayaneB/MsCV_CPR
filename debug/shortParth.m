DG = sparse(size(elem,1));
for ii = 1:size(inedge,1)
    
    DG(inedge(ii,3),inedge(ii,4)) = 1;
    
    
end