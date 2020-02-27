    %eC = oneNodeEdges(:,1);
    point = 205;
    %5 e 9
    region = 9;
    ip = point , plot(coord(ip,1),coord(ip,2),'yo')

    eC = setdiff(Nregion(point,:,region)',0);
      %  eC = setdiff(N(81,:)',0)

%     eC = setdiff(unique(Nregion(:,:,10)    ),0);
%     eC = eC - size(bedge,1);
%     eC = setdiff(eC,0);

for ii = 1: size(eC,1)
    refEdge = eC(ii);
    
    p1 = inedge(refEdge,1);
    p2 = inedge(refEdge,2);
    drawLineC(p1,p2,coord,[1 1 0]);
    ii
end
