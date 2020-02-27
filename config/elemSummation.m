function [ acum ] = elemSummation( refElem,vel)
%fluxSummation Sum the flux in all elements
%   INPUT:
%   flowrate
%   OUTPUT
%   q being generated in all elements
%   q must be 0 for a trully conservative method
global inedge bedge

%q = zeros(size(elem,1),1);
edges = findallEdges(refElem);

% 
% for index = 1 : size(bedge,1)
%     left = bedge(index,3);
%     q(left) = q(left) + vel(index);  
% end


bed = size(bedge,1);


acum = [0];
for index = 1 : size(edges,1)   
   left = inedge(edges(index),3);
  % right = inedge(index,4);
   if left == refElem
        acum = acum + vel(index+bed);
   else
        acum = acum - vel(index+bed);
   end

%    q(left) = q(left) + vel(index+bed);
%    q(right) = q(right) - vel(index+bed);
end

end