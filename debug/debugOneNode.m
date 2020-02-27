
for ii = 1: size(oneNodeEdges,1)
   edge = oneNodeEdges(ii,1); 
   flag =   oneNodeEdges(ii,2); 
   
   drawEdgesC(edge,[1 0 1]);
   if flag == 1
       point = inedge(edge,1);
       drawPoints(point);
   elseif flag == 2
       point = inedge(edge,2);
       drawPoints(point);
   else
       point1 = inedge(edge,1);
       point2 = inedge(edge,2);
       drawPoints(point1);
       drawPoints(point2);
   end
    
end