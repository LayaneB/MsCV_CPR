
classdef dynamic < handle
    %UNTITLED3 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        pointWeight
        npar
        dics
        W
        S
    end
    
    methods
        function obj = dynamic( point)
            obj.pointWeight = point;
            obj.npar = size(obj.pointWeight,1);
            %creatinga all dictionaries
            create_containers = @(n)arrayfun(@(x)containers.Map(obj.pointWeight{x}',[1:size(obj.pointWeight{x},1)]), 1:n, 'UniformOutput', false);
            obj.dics = create_containers(obj.npar);
            obj.W = cell(obj.npar,1);
            obj.S = cell(obj.npar,1);
            
            for ii = 1: obj.npar
                obj.W{ii} = cell( size(obj.pointWeight{ii},1),1);
                obj.S{ii} = zeros( size(obj.pointWeight{ii},1),1);                
                for jj = 1 : size(obj.pointWeight{ii},1)
                    node = obj.pointWeight{ii}(jj);
                    sizeEsurn = size(esurnOrd(node,ii),1);
                    obj.W{ii}{jj} = zeros(sizeEsurn,1);
                    %obj.S{ii}{jj} = zeros(sizeEsurn,1);
                end
               
                
            
            end
%             



        end
        
        function obj = setW(obj,point,region,k, value)
            obj.W{region}{obj.dics{region}(point)}(k) = value;            
        end
        function obj = setS(obj,point,region, value)
            obj.S{region}(obj.dics{region}(point)) = value;            
        end        
        function out = readW(obj,point,region)
             out = obj.W{region}{obj.dics{region}(point)};
%               try
% %                 out = obj.W{region}{obj.dics{region}(point)};
% %             catch
% %                 global w esurn2
% %                     nec1=esurn2(point+1)-esurn2(point);
% %                     acum = [];
% %                     for j=1:nec1
% %                         acum = [acum;w(esurn2(point)+j)];
% %                     end
% %                 out = acum;
%             end
        end
        function out = readS(obj,point,region)
            try
                out = obj.S{region}(obj.dics{region}(point));            
            catch
                global s
               
                try
                     out = s(point);
                catch
                    out = 0;
                end  
            end
        end
        end
end