% para meio anisotropico 1 para 10 usar 7 para 8
%for a retangle coarse mesh
PPP = max(coord);
LengX = PPP(1); 
LengY = PPP(2);
%% config aqui
%6 e 17
numX = 4;
numY = 4;

% for a hexagonal mesh
Side = 0.125/2;

AA = cos(pi/6) * Side;
BB = sin(pi/6) * Side;


% [ 1 - SQUARE 2 - HEXAGON 3 Hexagon Real ]
meshPolygon = 1;

if meshPolygon == 1
    
    LPP = 1/numX;
    HPP = 1/numY;
    xc = (LPP/2):LPP:1;
    yc = (HPP/2):HPP:1;
    [xPP,yPP] = meshgrid(xc, yc);
    centConstr = [(1:numX*numY)' , xPP(:), yPP(:)];
    npar = numX * numY;
    listas = cell(numX*numY,1);
    for index = 1:size(centConstr,1)
        listas{index} = drawSquare(centConstr(index,2),centConstr(index,3),LPP,HPP,0,centConstr(index,1),2);
        listas{index}{1}(:,1) =  LengX * listas{index}{1}(:,1);
        listas{index}{1}(:,2) =  LengY * listas{index}{1}(:,2);
    end

    
elseif meshPolygon == 2
    xcc1 = 0:2*AA:1+AA;
    ycc1 = 0:3*Side:1+Side;
    [xPP,yPP] = meshgrid(xcc1, ycc1);
    centConstr = [(1:size(xPP(:),1))' , xPP(:), yPP(:)];
    
    prevSi = size(centConstr,1);
    xcc2 = AA:2*AA:1+AA;
    ycc2 = 1.5*Side:3*Side:1+Side;
    [xPP,yPP] = meshgrid(xcc2, ycc2);
    
    centConstr = [ centConstr; ((1+prevSi):(size(xPP(:),1)+prevSi))' , xPP(:), yPP(:)]; 
    npar = size(centConstr,1);
    listas = cell(size(centConstr,1),1);
    for index = 1:size(centConstr,1)
        listas{index} = drawHexagon(centConstr(index,2),centConstr(index,3),Side,0,centConstr(index,1));
   %drawHexagon( Xm,Ym, Side,PHI,mat)
    end

elseif meshPolygon == 3
    LPP = 1/(numX);
    HPP = 1/(numY);
    
    
    xcc1 = 0:2*LPP:1;
    ycc1 = 0:3*HPP:1;
    
    [xPP,yPP] = meshgrid(xcc1, ycc1);
    centConstr = [(1:size(xPP(:),1))' , xPP(:), yPP(:)];
    
    
    
    
    prevSi = size(centConstr,1);
    xcc2 = LPP:2*LPP:1;
    ycc2 = 1.5*HPP:3*HPP:1;
    [xPP,yPP] = meshgrid(xcc2, ycc2);
    
    centConstr = [ centConstr; ((1+prevSi):(size(xPP(:),1)+prevSi))' , xPP(:), yPP(:)]; 
    
    
    
    npar = size(centConstr,1);
    listas = cell(size(centConstr,1),1);
    
    
    
    for index = 1:size(centConstr,1)
        listas{index} = drawHexagonIrregular(centConstr(index,2),centConstr(index,3),LPP,HPP,0,centConstr(index,1));
   %drawHexagon( Xm,Ym, Side,PHI,mat)
    end   
end



%running tests on cool meshes

listTest1 = drawSquare(0.5,0.5,0.3,0.3,45,4000,2);
listTest2 = drawSquare(0.5,0.5,0.1,0.1,-45,4000,2);

%listTest2 = drawSquare(0.5,0.5,0.4,0.4,45,4000,2);

%listTest2 = drawSquare(0.75,0.65,0.3,0.4,0,4001,2);

%listTest3 = drawSquare(0.25,0.35,0.3,0.4,0,4003,2);
%listTest4 = drawSquare(0.75,0.35,0.3,0.4,0,4004,2);

%npar esta calculado errado


elemloc = isBar(centelem(:,1),centelem(:,2),listas{:}); %,listTest1);%,listTest1);%;,listas{:},listTest1);%,listTest1)%,listTest1,listTest2); % ,listTest1,listTest2);%,listTest1);%,listTest1)%,listTest2,listTest3,listTest4);
elemloc = fixNumb(elemloc);

npar = max(elemloc);


ref = (elemloc(inedge(:,3)) ~= elemloc(inedge(:,4))) ;
checkelem = setdiff( unique(inedge(ref,3:4)),0);

listedeges = zeros(size(checkelem,1),4);

ref = false(size(checkelem,1),1);
	
for ii = 1:size(checkelem,1)
    el = checkelem(ii);
  
    list = findallEdges(el,elem,inedge);
   
    %list = findallEdges(el,elem,inedge);
    list = elemloc(inedge(list,3:4));
    
    ref2 = list(:,1) ~= list(:,2);
    
    if sum(ref2) == size(ref2,1)
        ref(ii) = true;
    end
    %ref(ii) = sum(list == elemloc(el));
  
    
end


listelem = checkelem(ref);


for ii = listelem'
   list = findallEdges(ii,elem,inedge);
   list = elemloc(inedge(list,3:4));
   list = reshape(list,[],1);
   list = list(~(list == elemloc(ii)));
   value = mode(list);
   elemloc(ii) = value;
end

%elemloc(checkelem) == elemloc(listedges,1) 


%verificando integridade



%LISTA JA ESTA COM A PARTICAO