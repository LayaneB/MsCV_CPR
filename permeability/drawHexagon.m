function [out] = drawHexagon( Xm,Ym, Side,PHI,mat)
%UNTITLED Summary of this function goes here 
%   Detailed explanation goes here
    center = [Xm,Ym]';
    PHI = pi * PHI/180;
    rotMat = [ cos(PHI) -sin(PHI); sin(PHI) cos(PHI)];
    
    AA = Side * cos(pi/6);
    BB = Side * sin(pi/6);
    
    L1 = [Xm, Ym + Side];
    L2 = [Xm + AA, Ym + BB];
    L3 = [Xm + AA, Ym - BB];
    L4 = [Xm , Ym - Side];
    L5 = [Xm - AA, Ym - BB];
    L6 = [Xm - AA, Ym + BB];
    
   % CAC = [ L1, L2
    
    vec1 = L1' - center;
    vec2 = L2' - center;
    vec3 = L3' - center;
    vec4 = L4' - center;
    vec5 = L5' - center;
    vec6 = L6' - center;
    
    
    L1N = rotMat*vec1 + center;
    L2N = rotMat*vec2 + center;
    L3N = rotMat*vec3 + center;
    L4N = rotMat*vec4 + center;
    L5N = rotMat*vec5 + center;
    L6N = rotMat*vec6 + center;

   
    listop = [L1N';L2N';L3N';L4N';L5N';L6N'];
    out = {listop,mat};
    
    
end

