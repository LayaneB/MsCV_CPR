function [ T, F ] = assemblyOnePhaseTPFAserial( coord, elem,bedge,inedge,bcflag,Ted)
    T = sparse(size(elem,1),size(elem,1));
    F = sparse(size(elem,1),1);
    for i=1:size(inedge,1)
        Ted3 = Ted(i);
        Ted4 = Ted(i);        
        %Contribution of elements on the right and left of the edge       
        T(inedge(i,3), inedge(i,3)) = T(inedge(i,3), inedge(i,3))- Ted3; 
        T(inedge(i,3), inedge(i,4))= T(inedge(i,3), inedge(i,4))+ Ted3;
        T(inedge(i,4), inedge(i,4))= T(inedge(i,4), inedge(i,4))- Ted4;
        T(inedge(i,4), inedge(i,3))= T(inedge(i,4), inedge(i,3))+ Ted4; 
    end
    % Loop that runs through all the bounder edges of the mesh    
    
    for i=1:size(bedge,1)        
        %Parameters Calculation
        K3=elem((bedge(i,3)),5);
        v=coord(bedge(i,1),:)-coord(bedge(i,2),:);   
%        % FIVE SPOT
%         if bedge(i,1)==1
%             F(bedge(i,3))=F(bedge(i,3))-1;
%         end        
%         if bedge(i,1)==3
%             T(bedge(i,3),:)=zeros(1,size(elem,1));
%             T(:,bedge(i,3))=zeros(1,size(elem,1));
%             T(bedge(i,3),bedge(i,3))=1;
%             F(bedge(i,3))=0;
%         end               
        % If it is a Dirichlet bounder edge:
        if (bedge(i,5)>100)&&(bedge(i,5)<200)
            Ked=K3;
            for j=1:size(bcflag,1),
                if bcflag(j,1)==bedge(i,5)
                    p0=bcflag(j,2);
                end
            end
            T(bedge(i,3),bedge(i,3))=T(bedge(i,3),bedge(i,3))-4*Ked;
            F(bedge(i,3))=F(bedge(i,3))-4*Ked*p0;
            % If it is a Neumann bounder edge:
        elseif bedge(i,5)>200
            for j=1:size(bcflag,1),
                if bcflag(j,1)==bedge(i,5)
                    f=bcflag(j,2);
                end
            end
            F(bedge(i,3))=F(bedge(i,3))-norm(v)*f;
        end             
    end   
    

end
