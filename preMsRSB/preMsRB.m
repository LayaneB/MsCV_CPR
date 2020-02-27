function [ intRegion ,  boundRegion, GlobalBoundary, H, outSupport, ...
    coarseElemCenter,refCenterInCoaseElem, dictionary,edgesCoarseDict,coarseDiricht] = preMsRB(npar,coarseneigh, centelem, ...
 coarseelem,coarseblockcenter,exinterface,multiCC)    
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
%finding neighbors 
global intCoord elem coord inedge bedge esurn1 esurn2 elemloc edgesOnCoarseBoundary


coarseElemCenter = zeros([npar 1]);
for ii = 1:npar
   

    xp = intCoord(coarseblockcenter(ii),1);
    yp = intCoord(coarseblockcenter(ii),2);
    X = centelem(coarseelem{ii},1);
    Y = centelem(coarseelem{ii},2);
    groupDist = @(x,y)( sqrt((xp - x)^2 + (y-yp)^2));
    distance = arrayfun(groupDist, X,Y);
    if ii == 64
        1+1;
    end
    
    %modificação dia 26 - 01
    %flag 
    vep =  minValues(distance,6);
    

 
%     pepe = coarseelem{ii}(find(distance == min(distance)));
    % forcing coarse volume center to be elements that share at least one
    % edge with the boundary
    if sum(coarseneigh(ii,end-3:end)) > 0 && multiCC == 2
        checkElem = coarseelem{ii}(ismember(distance,vep)) ;
        pepe = bedgefaceCheck( checkElem);
        
        
    else
        pepe = coarseelem{ii}(find(distance == min(distance)));
    end
    coarseElemCenter(ii) = pepe(1);
   
    %ajustando aqui
    ct1 = find(intCoord(:,3) == 1 & intCoord(:,4) == ii );
    
    %replacing center of coarse cell with the center of the element which
    %is center of the coarse cell
        if sum(coarseneigh(ii,end-3:end)) == 0
             intCoord(ct1, 1) = centelem(coarseElemCenter(ii),1);  
             intCoord(ct1, 2) = centelem(coarseElemCenter(ii),2);
        end     

    
        
end


%splitting bedge into 4 sections
sbedgeR = [];
sbedgeT = [];
sbedgeL = [];
sbedgeB = [];
xmax = max( coord(:,1));
xmin = min (coord(:,1));

ymax = max( coord(:,2));
ymin = min (coord(:,2));
for ii = 1: size(bedge,1)
   p1 = bedge(ii,1);
   p2 = bedge(ii,2);
   
   c1 = coord(p1,1:2);
   c2 = coord(p2,1:2);
   
   
   if (c1(:,1) == xmin) && (c2(:,1) == xmin) 
        %adding edges on the LEFT
        sbedgeL = [sbedgeL; ii ];
   elseif (c1(:,1) == xmax) && (c2(:,1) == xmax) 
       %adding edges on the RIGHT
       sbedgeR = [sbedgeR; ii ];
   elseif (c1(:,2) == ymin) && (c2(:,2) == ymin) 
       %adding edges on the BOTTOM 
       sbedgeB = [sbedgeB; ii ];   
   elseif (c1(:,2) == ymax) && (c2(:,2) == ymax) 
       %adding edges on the TOP 
       sbedgeT = [sbedgeT; ii ];      
   end

end





refNode = cell([npar 1]);
%adding nodes to refNode to perform a triangulation
for ii = 1:npar
    %Finding out neighbors and where is located on the mesh (top, bottom,
    %righ, or left)
    celsur = find(coarseneigh(ii,1:npar));
    vecbor = find(coarseneigh(ii,npar+1:npar+4));      
    %adding connection points (points on the edges)    
    refNode{ii} = [refNode{ii} ;find(intCoord(:,3) == 4 & intCoord(:,4) == ii)];
    %adding center of neighbors coarseblocks
    %looking for neighbors centers
    ct1 = find(intCoord(:,3) == 1);
    ct2 = ismember(intCoord(ct1,4), celsur);  
    %adding neighbors centers
    refNode{ii} = [refNode{ii}; ct1(ct2)];
    %adding the interface center between neighbors
    %finding out the interface between neighbors
    comb = combnk(celsur,2);
    ct1 = find(intCoord(:,3) == 2);
    ct2 = (ismember(intCoord(ct1,4),comb(:,1)) & ...
        ismember(intCoord(ct1,5),comb(:,2))) | ...
        (ismember(intCoord(ct1,4),comb(:,2)) & ... 
        ismember(intCoord(ct1,5),comb(:,1)));
    %adding interfaces between neighbors
    refNode{ii} = [refNode{ii}; ct1(ct2,:)];
    %checking if any of the neighbors share a boundary
    ct1 = find(intCoord(:,3) == 3);
    ct2 = ismember(intCoord(ct1,5), vecbor) &  ismember(intCoord(ct1,4), celsur);
    refNode{ii} = [refNode{ii}; ct1(ct2,:)];
    %adding coarse cell node
    ct1 = find(intCoord(:,3) == 1  & intCoord(:,4) ==ii);
    refNode{ii} = [refNode{ii}; ct1];
    
        
    if multiCC == 2 && sum(coarseneigh(ii,end-3:end)) == 2
            true;         
    else
            ct1 = find(intCoord(:,3) == 2  & (intCoord(:,4) == ii  |intCoord(:,5) == ii)) ;
            refNode{ii} = [refNode{ii}; ct1];
    end
    
 
    
    
    %adding interface between coarse cell and boundary
    ct1 = find(intCoord(:,3) == 3  & intCoord(:,4) ==ii);
    refNode{ii} = [refNode{ii}; ct1];
    
end


%intFront stores a convexhul intDel stores a delauney triangulation
intFront = cell([npar,1]);
intDel = cell([npar ,2]);


warning('off');

for ii = 1:npar
    %boundary location
    vecbor = sum(coarseneigh(ii,npar+1:npar+4));      
    %gets neighbors
    celsur = find(coarseneigh(ii,1:npar));
    %forming a convex polygon with the main nodes
    %point has all reference to the nodes the form that polygon
    point = refNode{ii}(convhull(intCoord(refNode{ii},1) , intCoord(refNode{ii},2)));
    %saves these points
    intFront{ii} = point;
    %delaunayTriangulation    
    point = refNode{ii}(delaunay(intCoord(refNode{ii},1) , intCoord(refNode{ii},2)));

    x = intCoord(refNode{ii},1);
    y = intCoord(refNode{ii},2);
    flag = intCoord(refNode{ii},3);
    bel = intCoord(refNode{ii},4);
    t = delaunayTriangulation(x,y);    
    if sum(coarseneigh(ii,end-3:end)) == 2 && multiCC == 2
        intDel{ii,1} = t.ConnectivityList;
        intDel{ii,2} = [x,y];
    else
        intDel{ii,1} = trianremove(freeBoundary(t), t.ConnectivityList,x,y,flag,bel,celsur,vecbor);
        intDel{ii,2} = [x,y];
    end
    
end
% 
%generating interaction region boundary region

intRegion = cell([npar 1]);
boundRegion = cell([npar 1 ]);
% id = 'MATLAB:triangulation:PtsNotInTriWarnId';
% warning('off',id);

for ii = 1 : npar
    
    zone = triangulation(intDel{ii},intDel{ii,2});
    %getting the boundary of the triangulation
    edpoly = freeBoundary(zone);
    %changing edges into sequence of points
    ppoly = [edpoly(1,1); edpoly(:,2)];
    celsur = find(coarseneigh(ii,1:npar));
    %testing points
    Xp = zone.Points(ppoly,1);
    Yp = zone.Points(ppoly,2);
  
    [~,stmp] = size(celsur);
    testelem = [];    
    for index = 1:stmp
        testelem = [testelem; coarseelem{celsur(index)}'];
    end
    X = centelem(testelem,1);
    Y = centelem(testelem,2);
    %checking on neighbors
    in = inpolygon(X,Y,Xp,Yp);

    %adding the elements inside the coarse edge
    intRegion{ii} = sort([coarseelem{ii}';testelem(find(in))]);
    %removing coarse center elements from other cells
  
    intRegion{ii} = intRegion{ii} ...
         ((find(~ismember( intRegion{ii}, coarseElemCenter))));
% 
%     testelem = tInteractionRegion(size(elem,1),intRegion,coarseElemCenter);
% 
%     if ~isempty(testelem)    
%         for ind = 1:size(testelem,2)
%             intRegion{elemloc(testelem(ind))} = union(intRegion{elemloc(testelem(ind))}, testelem(ind));        
%         end
%     end


    
    
    %finding edges on the boundary
    Op = elem(intRegion{ii},1:4);
    tri = (Op(:,4) == 0);
    quad = ~(Op(:,4) == 0);
       
    triEd = [Op(tri,1) Op(tri,2); Op(tri,2) Op(tri,3); ...
        Op(tri,3) Op(tri,1)];
    quadEd = [Op(quad,1) Op(quad,2); Op(quad,2) Op(quad,3); ...
        Op(quad,3) Op(quad,4);Op(quad,4) Op(quad,1)];
    %removing edges with 0
    [Ed, ~, inum] = unique([triEd ; quadEd],'rows');
    counts = accumarray(inum(:), 1);   
    %intEd has the edges on the interface
    
    
    intEd = Ed(counts==1,:);
    intEd = unique(intEd, 'rows');
    
    %points on the boundary
    pointBound = unique(intEd);
    
    %defining as the boundary region all elements that share at least
    % on point with pointBound
    
    t = size(pointBound ,1);
    pI = zeros(t,1);
    dPoint = zeros(t,1);  
    pI(pointBound == pointBound ) = esurn2(pointBound ) + 1;
    dPoint = esurn2( pointBound  + 1 ) - pI ;    
    elSur = @(A,B) esurn1(A:(A+B));    
    elBord = cell2mat(arrayfun(elSur,pI,dPoint,'uniformoutput',false));    
    boundRegion{ii} = unique(elBord(~ismember(elBord, intRegion{ii})));
     
   

    
    
    bound = cell2mat(exinterface(celsur));
    protect1 = fElonBound( boundRegion{ii} , bound, celsur,elem,bedge);
    protect2 = coarseElemCenter(celsur);
    protect = [protect1 ; protect2];
    removedEl = fTooth(boundRegion{ii},elem,protect );
    intRegion{ii} = sort([intRegion{ii}; removedEl]);
    %removing all elements that share only one edge with the interface
    % TOOTH 
    boundRegion{ii} = setdiff(boundRegion{ii},removedEl );
        
    %fixing case where tooth is a coarse element center
    %finding which elements falls in the case
    
    elCase = fTooth(boundRegion{ii},elem,protect1);
    
    outPut = fCoarseToothEdge(elCase,boundRegion{ii}, elem, inedge );
    edgesTurn = unique( outPut{1});
    elfind = outPut{2};
    
    clear outPut
    
    
    %turn on with esurn
    %turn remove remaining tooth
    t = size(edgesTurn,2);
    pI = zeros(t,1);
    dPoint = zeros(t,1);
    pI = esurn2(edgesTurn ) + 1;
    dPoint = esurn2( edgesTurn  + 1 ) - pI;
    elAround = cell2mat(arrayfun(elSur,pI,dPoint,'uniformoutput',false))  ;
    
    %removes element Around from IntRegion
    intRegion{ii} = setdiff(intRegion{ii},elAround);
    %add element around to the bound region
    boundRegion{ii} = union(boundRegion{ii},elAround);
    
    %removes element that shared an edge with a coarse element
    
    %plot(centelem(elAround ,1),centelem(elAround ,2),'x');
    boundRegion{ii} = setdiff(boundRegion{ii} , elfind);
    
    
    while true
        elCase = fTooth(boundRegion{ii},elem,protect1);
        if isempty(elCase)
            break
        end
        boundRegion{ii} = setdiff(boundRegion{ii} , elCase);
    end
    
    %removing self coarse node

    tmp = boundRegion{ii};
    tst = ~ismember(boundRegion{ii},coarseElemCenter(ii));     
    %adicionei um = ao inves de == PODE TER ERRO AQUI 
    %o erro esta aqui
    % TEM ERRO AQUI =
    boundRegion{ii} == unique(tmp(~tst));
 
    %finding and removing border elements on the boundary
    
%     tmp =  fElonBoundEdge( boundRegion{ii} , bound, celsur,elem,bedge);    
%     boundRegion{ii} = setdiff(boundRegion{ii}, tmp);
%     
%     intRegion{ii} = unique([intRegion{ii};tmp]); 
%     
    
end
    


%removing coarsenode center from bounRegion
for index = 1:npar
   
    boundRegion{index} = setdiff(boundRegion{index},coarseElemCenter);
    
end


    




if multiCC == 2
    %running fixer to work on problem on multiCC on boundary
    [intRegion, boundRegion] = multiCCfixer(intRegion, boundRegion,npar,coarseneigh,coarseElemCenter,sbedgeR,sbedgeT,sbedgeB,sbedgeL);

end


%%

% testelem = tInteractionRegion(size(elem,1),intRegion,coarseElemCenter)'
% 
% if ~isempty(testelem)    
%     for ind = 1:size(testelem,2)
%         intRegion{elemloc(testelem(ind))} = union(intRegion{elemloc(testelem(ind))}, testelem(ind));        
%     end
% end




GlobalBoundary = cat(1,boundRegion{:});
GlobalBoundary = ismember(1:size(elem,1),GlobalBoundary);
H = cell(npar,1);
for ii =1:npar
    
    H{ii} = unique(intersect(intRegion{ii},GlobalBoundary) );
    
end




%generate a list with all elements that do not belong to neither interaction region not boundary region
%outSupport = zeros(npar,size(elem,1));
outSupport = false(size(elem,1),npar);
size(outSupport)
wholeSet = 1:size(elem,1);
for jj = 1 : npar
    %ismember(wholeSet,intRegion{jj})
    outSupport(:,jj) = ~ismember(wholeSet,intRegion{jj})';
    
    %outSupport{jj} = logical(setdiff(wholeSet, intRegion{jj}));
    %outSupport{jj} = setdiff(outSupport{jj},boundRegion{jj}); 
end

%plotting script
%debugInt
%meshplot(elem(testelem,1:4), coord(:,1), coord(:,2),'color',colormat(03,:), 'LineWidth' , 1.7);


% boundRegionLogical = cell(npar,1);
% for index = 1:npar
%     boundRegionLogical{index} = ismember(wholeSet,boundRegion{index});
% end


refGlobal2Local

disp('MsRB preprocessing successfully executed!');
end




function [intRegion, boundRegion] = multiCCfixer(intRegion, boundRegion,npar,coarseneigh, coarseElemCenter,sbedgeR,sbedgeT,sbedgeB,sbedgeL)
 
    global esurn1 esurn2

    for ii = 1:npar
        ii;
        if ii == 10
            1+1;
        end
            
        %finding neighbors
        celsur = find(coarseneigh(ii,1:end-4));
        %checking internal coarse cells
        if sum(coarseneigh(ii,end-3:end))== 0
           
            %checking if there is a coarse cell inside interaction region
            
            %checking if this coarse cell is neighbors with the cell on the
            %corner or in the boundary
            celCorner =  celsur(sum(coarseneigh(celsur,end-3:end),2) >= 1);
             if celCorner ~= 0
                 list = fElonBoundEdge(intRegion{ii},unique([sbedgeR,sbedgeT,sbedgeB,sbedgeL]));
                 intRegion{ii} = setdiff(intRegion{ii},[0; list]);
                 boundRegion{ii} = setdiff(unique([list; boundRegion{ii}]),[0]);
             
             end               
        %checking nodes on the boundary but not in the corner
        elseif sum(coarseneigh(ii,end-3:end))== 1
            %checking nodes on the left and right
            if (coarseneigh(ii,end-3) == 1) || (coarseneigh(ii,end-1) == 1) 
                 
                list = fElonBoundEdge(intRegion{ii},unique([sbedgeT,sbedgeB]));
                 intRegion{ii} = setdiff(intRegion{ii},[0; list]);
                 boundRegion{ii} = setdiff(unique([list; boundRegion{ii}]),[0]);
            elseif (coarseneigh(ii,end-2) == 1) || (coarseneigh(ii,end) == 1)
                 list = fElonBoundEdge(intRegion{ii},unique([sbedgeR,sbedgeL]));
                 intRegion{ii} = setdiff(intRegion{ii},[0; list]);
                 boundRegion{ii} = setdiff(unique([list; boundRegion{ii}]),[0]);        
                               
            end
        elseif  sum(coarseneigh(ii,end-3:end))== 2  
            coarseElemList = coarseElemCenter(find(coarseneigh(ii,1:end-4)));
            pointBound = pointConnection(coarseElemList, boundRegion{ii});
            
            
            t = size(pointBound ,1);
            if ~isempty(pointBound)
                pI = zeros(t,1);
                dPoint = zeros(t,1);
                pI(pointBound == pointBound ) = esurn2(pointBound ) + 1;
                dPoint = esurn2( pointBound  + 1 ) - pI ;
                elSur = @(A,B) esurn1(A:(A+B));
                elBord = cell2mat(arrayfun(elSur,pI,dPoint,'uniformoutput',false));
                
                eln = setdiff(elBord,boundRegion{ii});
                
                boundRegion{ii} =  unique([boundRegion{ii};eln]);
                intRegion{ii} = setdiff(intRegion{ii},eln);
                
            end
            
            %points on the boundary
            
            %defining as the boundary region all elements that share at least
            % on point with pointBound
            
                
                
        end
        
    end
    end



function [out] = tInteractionRegion(nelem,intRegion,coarseElemCenter)
    %checks all elements to see if all finecoarse cells belong to a
    %interaction region
    %INPUT: nelem = number of element, intRegion - interaction region
    %OUTPUT: elements outside intRegion
    p = [1:nelem];
    elemIn = unique(cat(1,coarseElemCenter,intRegion{:}));
    out = setdiff(p,elemIn);
%     %p(~ismember(p,elemIn ));
%     
%     if nelem ~= size(elemIn)
%         disp('DEBUG FLAG 001 RAISED');
%     end
  
end

function [out] =  fCoarseToothEdge(ctooth,bound, elem, inedge )
%     outPut = fCoarseToothEdge(elCase,boundRegion{ii}, elem, inedge );
%     checks the if ctooth (reference to a tooth) that belong to bound
%     (boundary region) finds the edge it shares with the bound and the
%     the element that shares this edge
%   INPUT: ctooth - reference to the tooth to be analyzed
%          bound - boundary of the tooth
%          elem - element matrix
%          inedge - inedge matrix
%   OUTPUT: out = {Points of the Edge ctooth shares with bound,
%                      Element that shares this Edge}
% NOT VERY WELL COODED
    %[978,1026])
    if ~isempty(ctooth) && (ctooth(1) == 978 || ctooth(1) == 1026)
        disp('teste')
    end
    points = unique(elem(ctooth,1:4),'rows');
    bound = setdiff( bound,ctooth);
    pointsBound = unique(elem(bound,1:4));
    edgeCtooth = zeros([size(ctooth,1) ,2]);
    
    op = ismember(points,pointsBound) & points ~= 0;
    
    for index = 1:size(op,1)
        edgeCtooth(index,:) = points(index,find(op(index,:)));
    end
    edgeCtooth  = sort(edgeCtooth,2);
       
    vecedge = find(ismember(inedge(:,1:2), edgeCtooth, 'rows'));
    
    vecEl = unique(inedge(vecedge,3:4));
    
    out = {edgeCtooth,  setdiff(vecEl,ctooth)};
    
end

function [out] = pointConnection(set1, set2)
%get a set of elements and checks which nodes are connected to a second
%set of elements
%INPUT
%set1 - Set of Elements 1
%set 2 - Set of Elements 2
%OUTPUT
%out - point that is shared by only between set 1 and set2 

global elem

out = [];
auxmat = elem(set1,1:4);
list = setdiff(unique(elem(set2,1:4)),0);

auxres = ismember(auxmat,list);

for index = 1: size(auxres,1)
    if sum(auxres(index,:)) == 1       
       p =  dot(auxres(index,:) + 0,auxmat(index,:));
       out = [out; p];
    end
end

end

function [out] = fElonBoundEdge( elemSet , bound)
    %finds Elements that share a POINT with the Boundary
    %finds which elements in elemSet shares an edge with the boundary
    
    %INPUT: elemSet - set of references to elements to be analyzed
    %       bound  - set of references to boundary edges
    %       elem - element matrix
    %       bedge - bedge matrix
    %       celsur - coarse cells surrounding a coarse cell
    %OUTPUT; which elements in elemSet are in the boundary
    global elem bedge
    points = elem(elemSet,1:4);
    boundPoints = unique(bedge(bound,1:2));
    
    
    %editando aqui
    
    sp = sum(ismember(points, boundPoints),2);
    ref = (sp >= 1);
    
    if sum(sp) == 0
        out = 0;
    else
        out = elemSet(ref);
    end
end



function [out] = fElonBound( elemSet , bound, celsur,elem,bedge)
    %finds Elements on the Boundary
    %finds which elements in elemSet belong to a boundary
    
    %INPUT: elemSet - set of references to elements to be analyzed
    %       bound  - set of references to boundary edges
    %       elem - element matrix
    %       bedge - bedge matrix
    %       celsur - coarse cells surrounding a coarse cell
    %OUTPUT; which elements in elemSet are in the boundary
    points = elem(elemSet,1:4);
    boundPoints = unique(bedge(bound,1:2));
    sp = sum(ismember(points, boundPoints),2);
    sp = sp ~= 0;
    if sum(sp) == 0
        out = 0;
    else
        out = elemSet(find(sp));
    end
end

function [out] = fTooth(elemSet,elem, varargin)
        %removedEl = fTooth(boundRegion{ii},elem,protect );
%finds  tooth in elementSet (elements that share only one edge with
%elementSet) 
% 
% INPUT : elemSet - set of elements to be analyzed
%         elem - element matrix
%         vargin - takes special elements that even if they are found to be
%         tooth they are not to be considers as a tooth (egg. elements on
%         the boundary)
% OUTPUT: list of tooth minus elements in vargin

    
    elemOnEnd = cat(1,varargin{:});
  
    %
    points = elem(elemSet,1:4);
    elemEdge = zeros([size(points,1) , 8]);
    elemEdgeRef = zeros([size(points,1) , 4]);
    triRef = (points(:,4) == 0);
    quadRef = ~triRef;
  
    edgeTri = unique([ points(triRef,1) points(triRef,2); ...
        points(triRef,2) points(triRef,3); ...
        points(triRef,3) points(triRef,1)],'rows');
        
    edgeQuad = unique([points(quadRef,1) points(quadRef,2); ...
        points(quadRef,2) points(quadRef,3); ...
        points(quadRef,3) points(quadRef,4); ...
        points(quadRef,4) points(quadRef,1)],'rows');
    
    edges = unique(sort([edgeTri; edgeQuad],2),'rows');
    elemEdge = elemEdgeGen(points,edges);
    
    VecC = [1:size(elemEdge,1)];
    ComB = allcomb(VecC,VecC);
    
    ComB = ComB(ComB(:,1) ~=  ComB(:,2),:);
    
  
    Res = zeros([size(ComB,1) 1]);
    %reference to when comparing 2 triangle elements
    % when comparting 2 triangle elements 0 will always count,
    % we need to remove 1 from the sum whenever comparing two triangles
    refM = ismember(ComB(:,1), find(triRef))& ismember(ComB(:,2), find(triRef));
    Res = fIntersect( elemEdge(ComB(:,1),:),elemEdge(ComB(:,2),:));
    Res(refM) = Res(refM) - 1 ;
    
    elemEdgeCount = zeros([size(elemEdge,1) 1]);
    %elemEdge has the number of edges that an element shares with the rest
    %of the group
    for jj = 1: size(elemEdge,1)
       elemEdgeCount(jj) = sum(Res(find( ComB(:,1) == jj) ));
    end
    
   
    out = setdiff(elemSet(elemEdgeCount == 1), elemOnEnd(1:end) );
    
    
    
    
end

function [auxmat] = elemEdgeGen(point,edgesList)
    %INPUT 
    %point - list of points of an element
    %edges - list of edges
    %OUTPUT
    %auxmat = matrix that used references to edgesList instead of points
    
    compEdge = @(x,y,list)  find(  ((x == list(:,1)) & (y == list(:,2))  ...
        | ((x == list(:,2)) & (y == list(:,1)) ) ))     ;

    auxmat = zeros([size(point,1),4]);
    
     for index = 1:size(auxmat,1)
        if point(:,4) == 0
            auxmat(index,:) = [ compEdge(point(index,1), point(index,2),edgesList) ...
                compEdge(point(index,2), point(index,3),edgesList) ...
                compEdge(point(index,3), point(index,1),edgesList) 0 ];
        else
            auxmat(index,:) = [ compEdge(point(index,1), point(index,2),edgesList) ...
                compEdge(point(index,2), point(index,3),edgesList) ...
                compEdge(point(index,3), point(index,4),edgesList) ...
                compEdge(point(index,4), point(index,1),edgesList) ];
            
        end            
            

     end

end

function [out] = fRepair(intReg, elem)
    %unsed function 
    points = elem(:,1:4);
    refTri = points(:,4) == 0;
    refQuad =  ~ refTri;
    
    triEdges = unique([ points(refTri,1) points(refTri,2); ...
        points(refTri,2) points(refTri,3) ; ...
        points(refTri,3) points(refTri,1)],'rows');
    
    quadEdges = unique([points(refQuad,1) points(refQuad,2); ...
        points(refQuad,2) points(refQuad,3); ...
        points(refQuad,3) points(refQuad,4); 
        points(refQuad,4) points(refQuad,1)],'rows');   
    allEdges = [triEdges; quadEdges]
    elemEdges = zeros([size(allEdges,1) 4]);
  

end

function [nodes] = discPoint(intReg,elem,bedge,exinterface, celsur)
%unused function
%finds all  discontinuous points
    %looks for nodes that show only twice
    % elements connected by a single node
    
    pointOnBor = unique(bedge(cell2mat(exinterface(celsur)),2));
    elNode = sort(elem(intReg,1:4),2);
    [stmp,~] = size(elNode);
    
    nodes = unique(elNode);   
      
    com = combnk([1:stmp],2);
    
    lexo = fIntersect(elNode(com(:,1),:), elNode(com(:,2),:));
      
    ref = zeros([ size(elNode(com(:,1),:),1) 1]);
    
    cond = (elNode(com(:,1),1) == 0) & (elNode(com(:,2),1) == 0);
    
    ref(cond) = lexo(cond) == 2;
    ref(~cond) = lexo(~cond) == 1;    
    
    ref = logical(ref);
    com = com(ref,:); 
    
    nodes = zeros([size(elNode(com(:,1),:),1) 1]);
    B = elNode(com(:,2),:) ;    A = elNode(com(:,1),:) ;

     
    for index = 1 : size(A,1)
       nodes(index) = setdiff(intersect(A(index,:) ,B(index,:)), [0]);   
    end                                    
    
    ref = sum(ismember(elNode, pointOnBor),2) == 1;
    auxmat = elNode(ref,:);
    ismember(elNode(ref,:),pointOnBor);
    extranode =  unique(auxmat(ismember(elNode(ref,:),pointOnBor)));
    nodes = [ nodes;extranode];

end

function [out] = fIntersect(vec1,vec2)
    %compares rows from vec1 with rows from vec2 and returns
    %the number of equal elements
    %egg:
    % vec1                 |   vec2                     out
    % 78   534    80     0 |   79   533    78     0   |  2
    % 78   534    80     0 |  153   452   151     0   |  1
    %
   
  out = sum((vec1 == vec2),2) +  sum((vec1 == circshift(vec2,[0 1])),2) + ...
    sum((vec1 == circshift(vec2,[0 2])),2) + ...
    sum((vec1 == circshift(vec2,[0 3])),2); 
end




function [out] = fContinue(bound, inbound, discnode, nodesFromNeighCoarseCenter,esurn1,esurn2,coord, ind)
%function unused,        
             
        discnoderef = discnode == discnode;
        closeCoarse = ismember(discnode , nodesFromNeighCoarseCenter);   

        notCloseCoarse = ~ismember(discnode , nodesFromNeighCoarseCenter) ;
     
        
        t = size(discnode,1);
        pI = zeros(t,1);
        dPoint = zeros(t,1);
        
        
        pI(discnoderef) = esurn2(discnode) + 1;
        dPoint = esurn2( discnode + 1 ) - pI ;
        
      
        elSur = @(A,B) esurn1(A:(A+B));        

        
        op = arrayfun(elSur,pI(closeCoarse),dPoint(closeCoarse),'uniformoutput',false);
       
        elemDown = unique(cell2mat(op));        
        active1 = elemDown(ismember(elemDown,inbound))';
        
        

        op = arrayfun(elSur,pI(notCloseCoarse),dPoint(notCloseCoarse),'uniformoutput',false);
        
        
        
        
        
        
        active2 = unique(cell2mat(op));
                
        active2 = active2(~ismember(active2,inbound));

        out = unique([bound ; active1';active2]);
       

              
end


function [dtn] = trianremove(bt,dt,x,y,flag,bel,celsur,vecbor)
%function responsable for removing triangles in delauney triangulation
%that would exclude center nodes from the boundary of the triangulation
%INPUT - bt  - edges on the boundary of the triangulation
%        dt  - all triangles as: Ref1 Ref2 Ref3
%        Ref1 to Ref3 are references to different nodes
%       Egg:
%           1 3 4
%           4 5 6
%           9 8 7
%
%       - x and y both column vectors with the coordinates pointed by BT/DT
%       - flag is a column vector with the flag from intCoord that says
%       which type of node it is. Check reference of the 3rd column in
%       intCoord
%       - bel is the element it belongs to. Comes from the 4th column in
%       intCoord
%       - celsur - coarse cells surrounding a coarse cell
%       - vecbor  - location of vector in the boundary
%              0 no interface, 1 - interface 2 - interfaces
%
%  ____________
% |  ______    |
% | |      |   |
% | |______|   |
% |____________|
% 
% 0 interfaces of the cell with the boundary
% 
% 
%  ____________
% |	           |
% |    ____    |
% |   |	   |   |
% |___|____|___|
% 
% 1 - interface of cell with the boundary
% 
%  ____________
% |	           |
% |_____       |
% |     |	   |
% |_____|______|
% 
% 
% 2 - interface of cell with the boundary

%output = dtn = new triangulation stored as dt with all cellcenters type
%nodes in the boundary

st = [3 4; 3 3];

if vecbor == 1
    count = [0 , 2];
elseif vecbor == 2
    count = [2 , 2];    
end

[s , ~] = size(bt);
marker = zeros([s 1]);

%procurar celsur faltando

marker = find(~(ismember(flag(bt), st(1,:),'rows') + ...
    ismember(flag(bt),fliplr(st(1,:)),'rows')+ ...
    ismember(flag(bt), st(2,:),'rows')));

ct1 = (bt(marker,:));
ct2 = (flag(bt(marker,:))== 1);
celfront = bel(unique(ct1(ct2)))';
miss = setdiff(celsur,celfront);

if isempty(miss)
    dtmp = dt;
else
    [stmp1, ~] = size(miss);
    [stmp2, ~] = size(ct1); 
    [stmp3, ~] = size(dt);
    acum = zeros([stmp3 1]);
    for ii = 1:stmp1
      %find reference to the node from the coarse cell missing (miss)
      refmiss = find(flag == 1 & bel == miss(ii));
      trisearch = sort([ct1, refmiss*ones([stmp2 1])],2);
      acum = acum + ismember(sort(dt,2),trisearch,'rows');
    end
    ver = find(~acum);
    dtmp = dt(ver,:);        
end

    %[ x, y, flag,bel];
    %removing triangles with only coarse nodes
    refC = sum(flag(dtmp),2) == 3;

    dtn = dtmp(~refC,:);
end

