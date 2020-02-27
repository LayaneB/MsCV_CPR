function [ fluxNormal] = fluxAdj( Flux , ind )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
global inedge bedge coord





points = inedge(ind,1:2);
normVec = normals( size(bedge,1) + ind,1:3);



center = (coord(points(1),:) +   coord(points(2),:)) / 2; 

% drawLineC(points(1), points(2),coord,[0.5 0.5 0.5])
% 
% drawLineP(center+normVec ,center )


vecb = coord(points(1),:) - coord(points(2),:) ;

baseNorm = norm(vecb)/2;
vecNorm = norm(normVec);

hipNorm = (baseNorm ^2 + vecNorm^2)^.5;



fluxNormal = (vecNorm * Flux)/hipNorm;

%fluxTang = (baseNorm * Flux)/hipNorm;



end

