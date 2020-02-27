function [ out ] = bedgefaceCheck( listElem )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
global elem bedge

points = elem(listElem,1:4);
%add 27-3 - difference between triangular and quadrangular elements
pointZero = points == 0;


ref = ismember(points, bedge(:,1:2));
%add 27-03
ref(pointZero) = 0;


out = listElem((sum(ref,2) == 2));




beg = sum(ref,2) == 3;

if sum(beg) ~= 0
    out = listElem(beg);
end

end

