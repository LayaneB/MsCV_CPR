function [ edge ] = findEdge( p1,p2,inedge )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
%global inedge

edge = find((inedge(:,1) == p1 & inedge(:,2) == p2) | (inedge(:,2) == p1 & inedge(:,1) == p2));

end

