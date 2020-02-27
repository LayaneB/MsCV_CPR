
classdef dynamicStruct
    %UNTITLED3 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        pointWeight
        npar
        
    end
    
    methods
        function obj = dynamicStruct( point)
            obj.pointWeight = point;
            obj.npar = size(obj.pointWeight,1);
            
        end
        
    end
end