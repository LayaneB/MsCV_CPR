function [ out ] = leastDist( a,b,coord,tol)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
	px = coord(a,1);
    py = coord(a,2);
    alldist = ( (px - b(:,1)).^2 +   (py - b(:,2)).^2 ).^.5 ; 
    
    wep = find(abs(alldist)  == min(alldist))% < tol; 
    %out = find(wep);
    out = wep;
    %out = out(1);
    
    
    
end

