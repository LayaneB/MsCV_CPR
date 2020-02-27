%ip = 89 , plot(coord(ip,1),coord(ip,2),'yo')
    %eC = oneNodeEdges(:,1);
    %eC = edges(1);
    
    %eC = edgesOnCoarseBoundary(32,:);
    %eC = setdiff(Nregion(81,:,10)',0)
      %  eC = setdiff(N(81,:)',0)

%     eC = setdiff(unique(Nregion(:,:,10)    ),0);
%     eC = eC - size(bedge,1);
%     eC = setdiff(eC,0);
color = [ 1 1 1];
eC = setdiff(unique(V(1,:,340)),0)';
for ii = 1: size(eC,1)
    refEdge = eC(ii);
    
    
    if refEdge > size(inedge,1)
        refEdge = refEdge - size(inedge,1);
        p1 = bedge(refEdge,1);
        p2 = bedge(refEdge,2);
        drawLineC(p1,p2,coord,color);
        

    else
        p1 = inedge(refEdge,1);
        p2 = inedge(refEdge,2);
        drawLineC(p1,p2,coord,color);
    end
    
    ii
end

% 
% for ii = 1:size(oneNodeEdges,1)
%     
%     flag = oneNodeEdges(ii,2);
%     
%     if flag == 1
%         1+1;
%        point = inedge(oneNodeEdges(ii,1),1); 
%        cd = coord(point,:);
%        plot(cd(1),cd(2),'ro');
%     elseif flag == 2
%        1+1;
%        point = inedge(oneNodeEdges(ii,1),2);
%        cd = coord(point,:);
%        plot(cd(1),cd(2),'ro');
%     else
%         point1 = inedge(oneNodeEdges(ii,1),1);
%         point2 = inedge(oneNodeEdges(ii,1),2);
%         cd1 = coord(point1,:);
%         cd2 = coord(point2,:);
%         plot(cd1(1),cd1(2),'ro');
%         plot(cd2(1),cd2(2),'ro');
%     end
%     
%     
%     
%     
%     
% end