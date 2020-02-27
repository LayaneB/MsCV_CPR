coarseConsv1 = zeros(npar,1);
flowMs = flowrate((size(bedge,1) +1):end) ;
%flowMs = flowrate;
for face = 1:size(edgesOnCoarseBoundary,1)
   
    lar =  elemloc(inedge(edgesOnCoarseBoundary(face),3:4))';
    
    coarseConsv1(lar(1)) = coarseConsv1(lar(1)) -  flowMs(edgesOnCoarseBoundary(face));
    coarseConsv1(lar(2)) = coarseConsv1(lar(2)) +  flowMs(edgesOnCoarseBoundary(face));
   
    
    
end