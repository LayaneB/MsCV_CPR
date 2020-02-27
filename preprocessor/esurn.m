function [ out ] = esurn(node, inp, region )
%ESURN 
%   inp == 1 : return de number of elements around inside region
%   inp == 2 : return the elements itself inside region
%   inp == 4: return ref

global esurn1 esurn2 elemloc

point = esurn2(node)+1;
length = esurn2(node+1) - esurn2(node);
element = esurn1(point :(point+length-1));



ref = (elemloc(element)  == region);


if inp == 1
    out = sum(ref) ;
elseif inp == 2
    out = element(ref);
else
    out = ref;

end

end

