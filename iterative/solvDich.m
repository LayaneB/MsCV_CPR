function [ plim ] = solvDich(A,B,x,nCoarse)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    global elem coarseelem
    plim = zeros(size(x));
    point = true(size(elem,1),1);
    point(coarseelem{nCoarse},1) = false; 
    Asmall = A(~point,:);
    
    Res = Asmall(:,point);
    Asmall = Asmall(:,~point);
    Bsmall = B(~point) - Res*x(point);
    plim(~point) = Asmall \Bsmall;
    
end