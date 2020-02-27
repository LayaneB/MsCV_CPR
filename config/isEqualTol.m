function [ out ] = isEqualTol( a,b,tol )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    out = abs(a-b) < tol;
    
end

