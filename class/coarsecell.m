classdef coarsecell
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        num
        coarseneigh
        celsur
        ntotal
        right
        up
        left
        down
        center
        corner
        intNeigh
        intBound
        
    end
    
    methods
        function obj = coarsecell(val,Coord,matneigh)
            obj.num = val;
            obj.coarseneigh = matneigh;
            [obj.ntotal, ~] = size(obj.coarseneigh);
            obj.celsur = find(obj.coarseneigh(obj.num,1:obj.ntotal));
            obj.right= logical(obj.coarseneigh(obj.num,obj.ntotal+1));
            obj.up= logical(obj.coarseneigh(obj.num,obj.ntotal+2));
            obj.left= logical(obj.coarseneigh(obj.num,obj.ntotal+3));
            obj.down= logical(obj.coarseneigh(obj.num,obj.ntotal+4));
            
            %finding information about the centers
            obj.center = find(Coord(:,3) == 1 & Coord(:,4) == obj.num);
            %finding information about interfaces
            [~,t] = size(obj.celsur);
            obj.intNeigh = zeros([1 t]);
            %pode ser que venha a dar pau para malha estruturada com um
            %ponto só de contato.
            obj.celsur
            for index = 1:t
                tmp = find((( Coord(:,3) == 2)) & (((Coord(:,4) == obj.num) & (Coord(:,5) == obj.celsur(index))) | ((Coord(:,5) == obj.num) & (Coord(:,4) == obj.celsur(index)))))
                Coord(tmp,:)
                obj.intNeigh(index) = tmp               
            end
            %find information on corner
            obj.corner = find((Coord(:,3) == 4) & (Coord(:,4) == obj.num))
            
            %find information on 
            obj.intBound = zeros([1 4])
            for index = 1:4
                 t = find( (Coord(:,3) == 3) & (Coord(:,4) == obj.num) & (Coord(:,5) == index)) ;
                 if ~isempty(t)
                   obj.intBound(index) =  t;
                 end
            end
            
            %Coord(obj.intBound(3),:)
            disp('aqui:')
            obj.intBound
            %find information on the interface cellcoarse boundary
            %ob
            
            
            
        end
    end
    
end

