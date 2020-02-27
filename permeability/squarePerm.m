function [ out ] = squarePerm( Xm,Ym,L,H,mat )
%returns coordinates of a square polygon
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
    L1 = [Xm, Ym];
    L2 = [Xm, Ym+ H];
    L3 = [Xm + L , Ym + H];
    L4 = [Xm + L, Ym];
    list = [L1;L2;L3;L4];
    out = {list,mat};
end

