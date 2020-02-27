function [ B ] = equalTol( A,tol )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
B = abs(A) > tol;
end

