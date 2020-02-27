

tol = 10^-14
for ii = 1:npar
   siz = size(pointWeight{ii},1);
   
   for jj = 1:siz
       point = pointWeight{ii}(jj);
       leq = sum(wsdynamic.readW(point,jj));
       if abs(leq - 1) > tol
          [ii jj] 
       end
   end
    
    
end