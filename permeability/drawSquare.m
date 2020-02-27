function [ out ] = drawSquare( Xm1,Ym1,L1,H1,PHI,mat1,ref )
%returns coordinates of a square polygon
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
  if ref == 1
       out =   squarePerm( Xm1,Ym1,L1,H1,mat1);
  else
       out =   squarePermCenter( Xm1,Ym1,L1,H1,mat1,PHI);
  end
end

