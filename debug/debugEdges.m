% ip = 89 , plot(coord(ip,1),coord(ip,2),'yo')
    %eC = [oneNodeEdges(:,1)]% ; edgesOnCoarseBoundary] ;
     eC = oneNodeEdges(:,1);
     eC2 = semiEdges(:,1);
     eC3 = regularEdges;
     %eC = oneNodeEdges(:,1);
     %eC = bedgeNode;
     %eC = semiEdges(:,1);  
%      ref2 = semiEdges(:,2) == 3
%      ref = semiEdges(:,2) == 2 | semiEdges(:,2) == 1
%      eC = semiEdges(:,1);  
%      ref = semiEdges(:,2) == 1 ;
%      ref = logical(ref .* ~ref2)
%      ref1 = semiEdges(:,2) == 1;
%     ref2 = semiEdges(:,2) == 2;
%     ref = ref1|ref2;
%     
%     
%     eC = semiEdges(ref,1);
    % eC = regularEdges;
%      eC = edgesOnCoarseBoundary;%(32,:);
%     eC = setdiff(Nregion(81,:,10)',0)
%        eC = setdiff(N(81,:)',0)
% 
%     eC = setdiff(unique(Nregion(:,:,10)    ),0);
%     eC = eC - size(bedge,1);
%     eC = setdiff(eC,0);

%eC =  edgesOnCoarseBoundary
% 
a= 36;
b = 35;
c = 225;

% % 
% for ii = 1: size(eC,1)
%     refEdge = eC(ii);
%     p1 = inedge(refEdge,1);
%     p2 = inedge(refEdge,2);
%     drawLineC(p1,p2,coord,[a/255 b/255 c/255]); 
%     
% end

a= 36;
b = 200;
c = 200;
% 
% for ii = 1: size(eC2,1)
%     refEdge = eC2(ii);
%     p1 = inedge(refEdge,1);
%     p2 = inedge(refEdge,2);
%     drawLineC(p1,p2,coord,[a/255 b/255 c/255]); 
%     
% end
% 
a= 0;
b = 210;
c = 15;
% 
for ii = 1: size(eC3,1)
    refEdge = eC3(ii);
    p1 = inedge(refEdge,1);
    p2 = inedge(refEdge,2);
    drawLineC(p1,p2,coord,[a/255 b/255 c/255]); 
    
end
% 




% 
% for ii = 1: size(eC,1)
%     refEdge = eC(ii);
%     p1 = inedge(refEdge,1);
%     p2 = inedge(refEdge,2);
%     drawLineC(p1,p2,coord,[1 0 1]);  
%     
% end


ref11 =  semiEdges(:,2) == 1;
ref22 =  semiEdges(:,2) == 2;
ref33 =  semiEdges(:,2) == 3;
allPoints1 = unique([inedge(semiEdges(ref11,1),1) ; inedge(semiEdges(ref22,1),2);inedge(semiEdges(ref33,1),1)  ; inedge(semiEdges(ref33,1),2)]); 




%allPoints = unique([ inedge(semiEdges(ref3,1),1)  ; inedge(semiEdges(ref3,1),2)]); 



ref1 =  oneNodeEdges(:,2) == 1;
ref2 =  oneNodeEdges(:,2) == 2;
ref3 =  oneNodeEdges(:,2) == 3;


allPoints = unique([inedge(oneNodeEdges(ref1,1),1) ; inedge(oneNodeEdges(ref2,1),2);inedge(oneNodeEdges(ref3,1),1)  ; inedge(oneNodeEdges(ref3,1),2)]); 

a1 = 210;
b1 = 0;
c1 = 0;
a2 = 45; 
b2 = 130;
c2 = 130;



%drawPoints( allPoints,(1/255)*[a1 b1 c1],2)
%drawPoints( allPoints1,(1/255)*[a2 b2 c2],1)

% 
% acum = [];
% for ii = 1 :npar
%      acum  = unique([acum ;pointWeight{ii}]);    
%     
% end
% 
% drawPoints(acum)
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
    
    
    
    
% end