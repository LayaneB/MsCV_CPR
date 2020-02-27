function [d] = disCalc(node,coord)
        %vectorial way to calculate distances
        
        c1 = coord(node(1),:);
        c2 = coord(node(2),:);
        d = ((c1(:,1) - c2(:,1)).^2 + (c1(:,2) - c2(:,2)).^2).^0.5;    
end