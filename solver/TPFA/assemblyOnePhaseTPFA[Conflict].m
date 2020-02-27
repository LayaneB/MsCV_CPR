function [ A, B ] = assemblyOnePhaseTPFA( coord, elem,bedge,inedge,bcflag,Ted,Kbedge)
    global wells elemarea normals
    A = sparse(size(elem,1),size(elem,1));
    B = sparse(size(elem,1),1); 
    ii = [1:size(inedge,1)];
    [r,c] = size(A);
    sub2indVec = @(ol1,oc1,ol2,oc2,ol3,oc3,ol4,oc4) [ (ol1+r.*(oc1-1)) (ol2+r.*(oc2-1)) (ol3+r.*(oc3-1)) (ol4+r.*(oc4-1))];
    sub2indVecSingle = @(ol1,oc1)  (ol1+r.*(oc1-1));
    normVec = @(x,y,z) sqrt( x.^2+ y.^2 + z.^2);
    GlobalPoint = sub2indVec(inedge(ii,3) , inedge(ii,3),inedge(ii,3) , inedge(ii,4),inedge(ii,4) , inedge(ii,3),inedge(ii,4) , inedge(ii,4));
    LM = localMatrix(Ted, Ted); 
    
    for i=1:size(LM,1)
        A(GlobalPoint(i,:)) =  A(GlobalPoint(i,:)) + LM(i,:);        
    end
    

    dirichletRef =  ( bedge(:,5) > 100 ) & ( bedge(:,5) < 200)  & ...
        ( bedge(:,4) > 100 ) & ( bedge(:,4) < 200);
    
    neumannRef = bedge(:,5) > 200 & bedge(:,4) > 200;
    
    dirichletOneRef = ~(dirichletRef | neumannRef);
    
    p0 = zeros([sum(dirichletRef) 1] );
    flux = zeros([sum(neumannRef) 1] );
    
    %K3 is the K on the bedges
    K3= Kbedge(dirichletRef);
    
    v= coord(bedge(neumannRef,1),:)-coord(bedge(neumannRef,2),:);
    
    acum = zeros(size(bedge(dirichletRef),1),1);
    
    %% Dirichlet Boundary Condition
    for jj = 1 : size(bcflag,1)        
        refP = bedge(dirichletRef,5) == bcflag(jj,1);
        acum = acum + refP;
        p0(refP) = p0(refP) + bcflag(jj,2); 
    end   
   
   for jj = 1 : size(bcflag,1)        
        refP = bedge(dirichletRef,4) == bcflag(jj,1);
        acum = acum + refP;
        p0(refP) = p0(refP) + bcflag(jj,2); 
   end   
        p0 = p0 ./ acum;  
      
    %rodando testes
    %%pode ter erro neste pedaço
    %A(bedge(dirichletRef,3),:) = 0;
    %ppx = 1.275
    ppx = 2;
    
    
    %%
    A(sub2indVecSingle(bedge(dirichletRef,3),bedge(dirichletRef,3))) = ...
        A(sub2indVecSingle(bedge(dirichletRef,3),bedge(dirichletRef,3))) + ppx.*K3;
    
    B(bedge(dirichletRef,3))=B(bedge(dirichletRef,3)) + ppx.*K3.*p0;
    
    
    %% One Point Dirichlet One Point Neuman
   
    
    
   % dirchletOneRef = ~(dirichletRef | neumannRef);
    p0 = zeros([sum(dirichletOneRef) 1] );
    %K3 is the K on the bedges
    K3= Kbedge(dirichletOneRef);
  
    auxmat = bedge(dirichletOneRef,:); 
    for jj = 1 : size(bcflag,1)        
        
        %flag2 dirichlet
        pl1 = bedge(dirichletOneRef,4) > 200;
        %flag1 dirichlet
        pl2 = ~pl1;   
       
        
        refP1 = auxmat(pl1,5) == bcflag(jj,1);
        refP2 = auxmat(pl2,4) == bcflag(jj,1);
        
        %acum = acum + refP;
        p0(refP1) = bcflag(jj,2); 
        p0(refP2) = bcflag(jj,2); 

    end   
    
    %rodando testes
    %%pode ter erro neste pedaço
    %A(bedge(dirichletOneRef,3),:) = 0;
    %%
    
    
    A(sub2indVecSingle(bedge(dirichletOneRef,3),bedge(dirichletOneRef,3))) = ...
        A(sub2indVecSingle(bedge(dirichletOneRef,3),bedge(dirichletOneRef,3))) + ppx.*K3;
    
    B(bedge(dirichletOneRef,3))=B(bedge(dirichletOneRef,3)) + ppx.*K3.*p0;
    
    
    
    
    %% Neunmman Boundary Condition
     for jj = 1 : size(bcflag,1)        
        refP = bedge(neumannRef,5) == bcflag(jj,1);
        flux(refP) = bcflag(jj,2); 
    end    
    
    B(bedge(neumannRef,3))=B(bedge(neumannRef,3))-normVec(v(:,1),v(:,2),v(:,3)).*flux;
    
  
    
%% Adding the influence of the wells on the matrix
% if size(wells,2) > 1
% wellSolv;
% if ~isempty(wells)    
%     %Saturation flags
%     for index = 1:size(flagsSatElem,1)
%         B(flagsSatElem{index})=  (flagsSatValue(index)/flagsSatTotalArea(index))  * elemarea(flagsSatElem{index});         
%     end
%     
%     for index = 1: size(flagsInjElem,1)
%          A(flagsInjElem{index},:) = 0* A(flagsInjElem{index},:);       
%          %flagsInjElem{index},:)
%          for ii = 1 : size(flagsInjElem{index},2)
%              A(flagsInjElem{index}(ii),flagsInjElem{index}(ii)) = 1;
%              B(flagsInjElem{index}(ii)) = flagsInjValue(index);
%          end
%          %for ii = 1: size(flags
%     end
% 
%     for index = 1: size(flagsProdElem,1)
%          A(flagsProdElem{index},:) = 0* A(flagsProdElem{index},:);       
%          %flagsInjElem{index},:)
%          for ii = 1 : size(flagsProdElem{index},2)
%              A(flagsProdElem{index}(ii),flagsProdElem{index}(ii)) = 1;
%              B(flagsProdElem{index}(ii)) = flagsProdValue(index);
%          end
%          %for ii = 1: size(flags
%     end
% end
% end
    
%% Adding the influence of the wells on the matrix
if size(wells,2) > 1
    wellSolv;
    if ~isempty(wells)
        %Saturation flags
        for index = 1:size(flagsSatElem,1)
            B(flagsSatElem{index})=  (flagsSatValue(index)/flagsSatTotalArea(index))  * elemarea(flagsSatElem{index});
        end
        
        for index = 1: size(flagsInjElem,1)
            A(flagsInjElem{index},:) = 0* A(flagsInjElem{index},:);
            %fl    agsInjElem{index},:)
            for ii = 1 : size(flagsInjElem{index},2)
                A(flagsInjElem{index}(ii),flagsInjElem{index}(ii)) = 1;
                B(flagsInjElem{index}(ii)) = flagsInjValue(index);
            end
            %for ii = 1: size(flags
        end
        
        for index = 1: size(flagsProdElem,1)
            A(flagsProdElem{index},:) = 0* A(flagsProdElem{index},:);
            %flagsInjElem{index},:)
            for ii = 1 : size(flagsProdElem{index},2)
                A(flagsProdElem{index}(ii),flagsProdElem{index}(ii)) = 1;
                B(flagsProdElem{index}(ii)) = flagsProdValue(index);
            end
            %for ii = 1: size(flags
        end
    end
    
end
end

function [out] = localMatrix(TedL, TedR) 
        %[ lambd, TedL, TedR] 
        out = [-TedL , TedL, TedR, -TedR];
end
