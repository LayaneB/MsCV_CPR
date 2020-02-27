function [ out ] = orLogic( a,b )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
out = zeros(size(a,1),size(a,2));

ref1 = find(a ~= 0); 
ref2 = find(b ~= 0);

out(ref1) = a(ref1);
out(ref2) = b(ref2);


end

