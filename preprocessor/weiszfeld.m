%--------------------------------------------------------------------------
% WEISZFELD - Base on the Weiszfeld  algorithm 
%--------------------------------------------------------------------------
% Generate the coordinates of the center of the element
% Implementation of an interative algorthim to solve the geometric median
%--------------------------------------------------------------------------
% OUTPUT:  center of the interface : 
%                 [0.34044 3.4335]
%--------------------------------------------------------------------------
% INPUT: 
% points - center of each interface in the coarse region
% ex: points =
% X      Y
% 0.35   0.3
% 1      3.2
% ...
% 1.3    5.4
%--------------------------------------------------------------------------
function [ out ] = weiszfeld( points )
%UNTITLED Summary of this function goes here
%   a = [.5 0 ; 1 0.5 ; 0.5 1 ; 0 0.5]
    t = size(points);
    x = 0;
    y = 0;
    x_n = 0;
    y_n = 0;
    tol = .00001;
    max_int = 100000;
    index = 0;
    den = 0;
    numx = 0;
    numy = 0;
    while 1
    for j = 1:t(1)
          den = den + 1/sqrt(((points(j,1) - x)^2) + ((points(j,2) - y)^2)) ; 
          numx = numx + points(j,1)/sqrt(((points(j,1) - x)^2) + ((points(j,2) - y)^2)) ;
          numy = numy + points(j,2)/sqrt(((points(j,1) - x)^2) + ((points(j,2) - y)^2)) ;
    end
    x_n = numx/den;
    y_n = numy/den;
    e_x = abs(x_n - x);
    e_y = abs(y_n - y);
    
    if ((e_x < tol) & (e_y < tol)) | (index > max_int)
        out = [x_n y_n];
        break
   
    else
        x = x_n;
        y = y_n;
        x_n = 0;
        y_n = 0;
        index = index + 1;
    end
    end
    
end

