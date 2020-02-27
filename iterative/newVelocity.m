function [ velocity ] = newVelocity( flow )
%UNTITLED8 Summary of this function goes here
%   Detailed explanation goes here
    global bedge coord inedge
    pointDist = @(x1,x2,y1,y2) ((x1 - x2).^2 + (y1-y2).^2).^0.5 ;
    velocity = zeros(size(flow));
    %tratando bedges
       bedS =  bedge(:,1:2);
       x1 = coord(bedS(:,1),1);
       y1 = coord(bedS(:,1),2);
       x2 = coord(bedS(:,2),1);
       y2 = coord(bedS(:,2),2);
       mep = pointDist(x1,x2,y1,y2);
       bedS =  inedge(:,1:2);
       x1 = coord(bedS(:,1),1);
       y1 = coord(bedS(:,1),2);
       x2 = coord(bedS(:,2),1);
       y2 = coord(bedS(:,2),2); 
       mep2 = pointDist(x1,x2,y1,y2);
       
       
    velocity(1:size(bedge,1)) = flow(1:size(bedge,1))' ./ mep;
    velocity((size(bedge,1)+1):(size(inedge,1)+size(bedge,1))) = flow((size(bedge,1)+1):(size(inedge,1)+size(bedge,1)))' ./ mep2;
    
end

