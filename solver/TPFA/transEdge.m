function [ kEdge ] = transEdge( kL,kR, hL, hR,face )
%transEdge Project the transmissibility on the edge
%   Detailed explanation goes here
% INPUT:
% kL / kR k of element on the left and right of an edge
% hL / hR height of an element on the left and right on an edge
% OUTPUT:
% kEdge - equivalent K projected on the edge.
kEdge =   -1*(face) .* ((kL .* kR) ./ ((kL .* hR) + (kR.*hL))) ; 


end

