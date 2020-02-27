function [ outlist ] = esurnOrd( node,region )
%esurnOrd - Node, Region
%   OUTPUT : Sorted List of Elements around in coarse region
global Nregion inedge bedge elemloc


faces = noZero( Nregion(node,:,region))';
listElem = zeros(size(faces,1),2);

listPoint  = zeros(size(faces,1),2);
refBedge = faces > size(inedge,1);
refInedge = ~refBedge;

listElem(refInedge,1:2) = inedge( faces(refInedge),3:4);
listElem(refBedge,1) = bedge( faces(refBedge) - size(inedge,1),3);

listPoint(refInedge,1:2) = inedge( faces(refInedge),1:2);
listPoint(refBedge,1:2) = bedge( faces(refBedge) - size(inedge,1),1:2);


refSwap = listPoint(:,2) == node;


tmp = listElem(refSwap,2);

listElem(refSwap,2) = listElem(refSwap,1);
listElem(refSwap,1) = tmp;

ordElem  = [ listElem(1,2) ; listElem(1:end,1)];

ordElem = noZero(ordElem);
refRegion = elemloc(ordElem) == region;

outlist = ordElem(refRegion);

if outlist(end) == outlist(1) & size(outlist,1) > 1
    outlist = outlist(1:end-1);
    %outlist = outlist(2:end);
end


end

