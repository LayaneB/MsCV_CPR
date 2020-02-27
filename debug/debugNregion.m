    
    pq = 3;
    eC = setdiff(unique(Nregion(:,:,pq)    ),0);
    eC = setdiff(eC,0);

for ii = 1: size(eC,1)
    refEdge = eC(ii);
    
    if refEdge > size(bedge,1)
        refEdge = refEdge - size(bedge,1);
        p1 = inedge(refEdge,1);
        p2 = inedge(refEdge,2);
        
    else
        p1 = bedge(refEdge,1);
        p2 = bedge(refEdge,2);
    end
        drawLineC(p1,p2,coord,[1 1 1]);
    
  
    
end

