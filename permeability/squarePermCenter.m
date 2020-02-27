function [ out ] = squarePermCenter( Xm,Ym,L,H,mat, PHI )
%returns coordinates of a square polygon
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
    center = [Xm,Ym]';
    PHI = pi * PHI/180;
    rotMat = [ cos(PHI) -sin(PHI); sin(PHI) cos(PHI)];
    L1 = [Xm - L/2 , Ym + H/2];
    L2 = [Xm - L/2 , Ym - H/2];
    L3 = [Xm + L/2 , Ym - H/2];
    L4 = [Xm + L/2 , Ym + H/2];
    
    vec1 = L1' - center;
    vec2 = L2' - center;
    vec3 = L3' - center;
    vec4 = L4' - center;
    
    L1N = rotMat*vec1 + center;
    L2N = rotMat*vec2 + center;
    L3N = rotMat*vec3 + center;
    L4N = rotMat*vec4 + center;
   
    list = [L1N';L2N';L3N';L4N'];
    out = {list,mat};
end

