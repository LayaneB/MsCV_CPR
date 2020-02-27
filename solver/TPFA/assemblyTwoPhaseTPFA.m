function [ T, F ] = assemblyOnePhaseTPFA( coord, elem,bedge,inedge,bcflag, lambd, lambd_cont, Ted)
    T=sparse(size(elem,1),size(elem,1));
    %T = full(T);
    A = sparse(size(elem,1),size(elem,1));
    %A = full(A);
    
    F=sparse(size(elem,1),1);   
    %T = full(T);
    %Loop that runs through all the inner edges of the mesh.
    disp('melhorando tempo')
    
    tic
   % ii = zeros( [size(inedge,1) 1]);
    ii = [1:size(inedge,1)];
    
    
    
   % GlobalPoint = [  sub2ind(size(A), inedge(ii,3) , inedge(ii,3)) , sub2ind(size(A), inedge(ii,3) , inedge(ii,4)) ...
    %   sub2ind(size(A), inedge(ii,4) , inedge(ii,3))  ,sub2ind(size(A), inedge(ii,4) , inedge(ii,4))];
    
%     GlobalPoint = [  sub2ind(size(A), [inedge(ii,3) , inedge(ii,3)] , [inedge(ii,3) , inedge(ii,4)], ...
%        [ inedge(ii,4) , inedge(ii,3) ] , [ inedge(ii,4) , inedge(ii,4)] )];
    
   
    [r,c] = size(A);
    sub2indVec = @(ol1,oc1,ol2,oc2,ol3,oc3,ol4,oc4) [ (ol1+r.*(oc1-1)) (ol2+r.*(oc2-1)) (ol3+r.*(oc3-1)) (ol4+r.*(oc4-1))];
    

    GlobalPoint = sub2indVec(inedge(ii,3) , inedge(ii,3),inedge(ii,3) , inedge(ii,4),inedge(ii,4) , inedge(ii,3),inedge(ii,4) , inedge(ii,4));
    
    
    
   % GlobalPoint = [ sub2indVec(inedge(ii,3) , inedge(ii,3)
    
    %LM = zeros([size(inedge,1) 4] );
    LM = localMatrix(lambd(ii),Ted(ii,3), Ted(ii,4)); 
    
    for i=1:size(LM,1)
        A(GlobalPoint(i,:)) =  A(GlobalPoint(i,:)) + LM(i,:);        
    end
    
    toc
%     [vals,~,ind] = unique(GlobalPoint);
%     sums = zeros([size(vals,1) 1]);
%     sums = accumarray(ind, LM(:));
%     A(vals) = A(vals) + sums;
    
    
    
    A(1,1)
   
    
    
    tic
    
    for i=1:size(inedge,1)
        Ted3 = lambd(i)*Ted(i,3);
        Ted4 = lambd(i)*Ted(i,4);
        
        %Contribution of elements on the right and left of the edge.
    
        
        T(inedge(i,3), inedge(i,3)) = T(inedge(i,3), inedge(i,3))- Ted3;
        
       
        
        
        T(inedge(i,3), inedge(i,4))= T(inedge(i,3), inedge(i,4))+ Ted3;
        T(inedge(i,4), inedge(i,4))= T(inedge(i,4), inedge(i,4))- Ted4;
        T(inedge(i,4), inedge(i,3))= T(inedge(i,4), inedge(i,3))+ Ted4; 
        
        
       %[ T(inedge(i,3), inedge(i,3))   T(inedge(i,3), inedge(i,4))  T(inedge(i,4), inedge(i,4)) ...
        %    T(inedge(i,4), inedge(i,3))   vLoop1(i,lambd,Ted,inedge,T)    ]
        % [ vLoop1(i,lambd,Ted)]
    end
    % Loop that runs through all the bounder edges of the mesh
    toc
    
    T(1,1)

    ii = [1:size(bedge,1)];
    K3 = elem((bedge(ii,3)),5);   
    v= coord(bedge(ii,1),:)-coord(bedge(ii,2),:);
    
    %5spot like problem
    %finding point 1 and point 3
    fivespotRef1 = bedge(:,1) == 1;
    fivespotRef2 = bedge(:,3) == 3;
    
    
    
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
            Ked=lambd_cont(i)*K3;
            for j=1:size(bcflag,1),
                if bcflag(j,1)==bedge(i,5)
                    p0=bcflag(j,2);
                end
            end
            T(bedge(i,3),bedge(i,3))=T(bedge(i,3),bedge(i,3))-2*Ked;
            F(bedge(i,3))=F(bedge(i,3))-2*Ked*p0;
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
    
    T = sparse(T);
    spy(T)
end

function [out] = localMatrix(lambd,TedL, TedR) 
        %[ lambd, TedL, TedR] 
        TedLp = dot(lambd,TedL,2);
        TedRp = dot(lambd,TedR,2);
        out = [-TedLp , TedLp, TedRp, -TedRp];
end
