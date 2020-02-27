function [HL,HR,edgeVecDist]= heightCalc(inedge, coord, centelem)
    %Calculate all the Height of Element on the Left and On the Right of an
    %Edge
    %Checks inedge and calculate all the heights of element of to the left
    % and elements to the right
    % OUTPUT:
    % HL = Height of Left Element
    % HR = Height of Right Element
    normVec = @(x,y,z) sqrt( x.^2+ y.^2 + z.^2);
    ii = [1:size(inedge,1)];


    bLeft = centelem(inedge(ii,3),:);
    bRight = centelem(inedge(ii,4),:);
    %distLR = bRight - bLeft;

    edgeVec = coord(inedge(ii,2),:) -  coord(inedge(ii,1),:);


    vecLeftCenter = bLeft -  coord(inedge(ii,1),:);
    vecRightCenter = bRight -  coord(inedge(ii,1),:);

    CL = cross(edgeVec,vecLeftCenter);
    CR = cross(edgeVec,vecRightCenter);
    edgeVecDist = normVec(edgeVec(:,1), edgeVec(:,2),edgeVec(:,3));
    HL = normVec(CL(:,1),CL(:,2),CL(:,3))./edgeVecDist;
    HR = normVec(CR(:,1),CR(:,2),CR(:,3))./edgeVecDist;
end