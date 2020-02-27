function [ outvec ] = fixNumb( vec )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    outvec = zeros(size(vec,1),1);
    a = unique(vec);
    b = 1:size(a,1);

    for ii = 1: size(vec,1)
        jj = 1;
        
        while true == true 
            if vec(ii) == a(jj)
               outvec(ii) = b(jj);
               break
            end
            jj = jj + 1;
        end
   
    end
end

