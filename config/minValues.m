function [ value ] = minValues (vec, t )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    copyvec = vec;
    value = [];
    for ii = 1:t
       ref = find( copyvec == min(copyvec));
       ref = ref(1);
       locMin = copyvec(ref);
       copyvec = copyvec (~(copyvec == locMin ));
       value = [value; locMin];
    end

end

