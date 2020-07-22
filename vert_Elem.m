function vE = vert_Elem
Globals2D_CPR; 
global coord
C = num2cell(EToV,2);
ix = [C{:}]';
cellLengths = cellfun(@length, C);
cs = cumsum(cellLengths);
jy = arrayfun(@(k) nnz(cs < k), (1:cs(end))) + 1;
vE = sparse(ix, jy, true, size(coord,1), size(C, 1));
