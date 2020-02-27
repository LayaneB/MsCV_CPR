function [ q ] = fluxSummation( vel )
%fluxSummation Sum the flux in all elements
%   INPUT:
%   flowrate
%   OUTPUT
%   q being generated in all elements
%   q must be 0 for a trully conservative method
global inedge bedge elem

q = zeros(size(elem,1),1);



for index = 1 : size(bedge,1)
    left = bedge(index,3);
    q(left) = q(left) + vel(index);  
end


bed = size(bedge,1);



for index = 1 : size(inedge,1)
   left = inedge(index,3);
   right = inedge(index,4);
   q(left) = q(left) + vel(index+bed);
   q(right) = q(right) - vel(index+bed);
    
end

end

