function [ edges ] = findallEdges( setElem,elem, inedge )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
%global elem inedge
point = noZero(elem(setElem,1:4));

if size(point,2) == 3
    edges = [ findEdge(point(1),point(2),inedge);findEdge(point(2),point(3),inedge);findEdge(point(3),point(1),inedge)];
else
    edges = [ findEdge(point(1),point(2),inedge);findEdge(point(2),point(3),inedge);findEdge(point(3),point(4),inedge) ;findEdge(point(4),point(1),inedge)];
end

edges = sort(edges);
end

