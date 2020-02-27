function [ out] = ordEdges( node, edges,region )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
%ooo = setdiff(Nregion(82,:,10),0)
global inedge bedge elemloc

refBedge = edges > size(inedge,1);
refInedge = ~refBedge;

count = sum(refBedge);

pointAndNeigh = zeros(size(edges,1),4);

pointAndNeigh(refInedge,1:4) = inedge(edges(refInedge),1:4);

pointAndNeigh(refBedge,1:3) = bedge(edges(refBedge)  - size(inedge,1),1:3);


pointAndNeigh(refInedge,3:4) = elemloc(pointAndNeigh(refInedge,3:4));
pointAndNeigh(refBedge,3) = elemloc(pointAndNeigh(refBedge,3));

ref = pointAndNeigh(:,2) == node;

%swap left and right cade node is on the second collumn
tmp = pointAndNeigh( ref,4);
pointAndNeigh( ref,4) =pointAndNeigh( ref,3);
pointAndNeigh( ref,3) =tmp;

count = 0;
%olhar com cuidado
flag = isequal(pointAndNeigh(:,3:4), region*ones(size(pointAndNeigh,1),2 ));

if flag == 0
    while -1
       tmp = circshift(pointAndNeigh,count);
       if (tmp(1,4) ~= region) &  (tmp(end,3) ~= region)
         break
       end
        count = count +1;
    end
end
% %checar se esta completo 
% global coord
% for ii = 1: size(pointAndNeigh,1)
%     
%     p1 = pointAndNeigh(ii,1);
%     p2 = pointAndNeigh(ii,2);
%     drawLineC(p1,p2,coord,[1 1 0]);
%     ii;
% end

out = circshift(edges,count);
end

