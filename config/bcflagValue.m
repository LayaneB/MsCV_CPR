function [ out ] = bcflagValue( flag )
%bcflagValue Looks in bcflag for the value of the input argument
%   INPUT:
%   flag - flag that belongs to bcflag
%   OUTPUT:
%   out = value of the input flag

global bcflag

out = bcflag(bcflag(:,1) ==  flag,2);


end

