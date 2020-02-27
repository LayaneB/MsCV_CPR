function [ outlist ] = nsurnOrd( node,region )
%NsurnOrd - Node, Region
%   OUTPUT : Sorted List of Points around in coarse region
global Nregion inedge bedge elemloc


faces = noZero( Nregion(node,:,region))';

listPoint  = zeros(size(faces,1),2);



refBedge = faces > size(inedge,1);
refInedge = ~refBedge;



listPoint(refInedge,1:2) = inedge( faces(refInedge),1:2);
listPoint(refBedge,1:2) = bedge( faces(refBedge) - size(inedge,1),1:2);


refSwap = listPoint(:,2) == node;

tmp = listPoint(refSwap,2);

listPoint(refSwap,2) = listPoint(refSwap,1);
listPoint(refSwap,1) = tmp;

outlist = listPoint(:,2);


end

