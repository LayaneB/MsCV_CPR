

for ii = 1: size(semiEdges,1)
   edge = semiEdges(ii,1); 
   flag =   semiEdges(ii,2); 
   
   drawEdgesC(edge,[1 1 1]);
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