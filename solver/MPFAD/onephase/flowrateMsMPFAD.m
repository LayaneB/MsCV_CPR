%funçao que calcula os fluxos nas arestas internas
%equacoes 28 e 29 (heterogeneo) ou 15 e 16 (homogeneo)

function [flowrate]=flowrateMsMPFAD(edgesOnCoarseBoundary,p,w,s,Kde,Ded,Kn,Kt,Hesq,nflag,auxflag)

global coord esurn1 esurn2  inedge centelem bcflag

%mobility = 1;
%auxmobility1=mobility(1:size(inedge,1),1);
%auxmobility2=mobility((size(inedge,1)+1):(size(inedge,1)+size(bedge,1)),1);
%mobility(1:size(bedge,1),1)=auxmobility2;
%mobility((size(bedge,1)+1):(size(inedge,1)+size(bedge,1)),1)=auxmobility1;

%Initialize "bedgesize" and "inedgesize"



%Initialize "flowrate" and "flowresult"
flowrate = zeros( size(edgesOnCoarseBoundary,1) ,1);



bedgesize = 0;

for index=1:size(edgesOnCoarseBoundary,1)
    
    iface = edgesOnCoarseBoundary(index);
    lef=inedge(iface,3); %indice do elemento a direita da aresta i
    rel=inedge(iface,4); %indice do elemento a esquerda da aresta i
    % interpolando os nós (ou vértices)
    nec1=esurn2(inedge(iface,1)+1)-esurn2(inedge(iface,1));
    p1=0;
    % calculo da pressão no nó "inedge(iface,1)"
    if nflag(inedge(iface,1),1) >200
        if nflag(inedge(iface,1),1)==auxflag
            for j=1:nec1
                element1=esurn1(esurn2(inedge(iface,1))+j);
                %interpolação
                p1=p1+w(esurn2(inedge(iface,1))+j)*p(element1);
            end
            p1=p1+s(inedge(iface,1),1);
        else
            for j=1:nec1
                element1=esurn1(esurn2(inedge(iface,1))+j);
                p1=p1+w(esurn2(inedge(iface,1))+j)*p(element1);
            end
        end
        
    else
        p1=nflag(inedge(iface,1),2);
    end
    
    % calculo da pressão no "inedge(i,2)"
    nec2=esurn2(inedge(iface,2)+1)- esurn2(inedge(iface,2));
    p2=0;
    if  nflag(inedge(iface,2),1)>200
        if nflag(inedge(iface,2),1)==auxflag
            for j=1:nec2
                element2=esurn1(esurn2(inedge(iface,2))+j);
                p2=p2+w(esurn2(inedge(iface,2))+j)*p(element2);
            end
            p2=p2+s(inedge(iface,2),1);
        else
            for j=1:nec2
                element2=esurn1(esurn2(inedge(iface,2))+j);
                p2=p2+w(esurn2(inedge(iface,2))+j)*p(element2);
            end
            
        end
        
    else
        p2=nflag(inedge(iface,2),2);
    end
%     
%     
%     B1=inedge(iface,1);
%     B2=inedge(iface,2);
%     nor=norm(coord(B1,:)-coord(B2,:));
%     
    %calculo das vazões
    flowrate(index)=Kde(iface)*(p(rel)-p(lef)-Ded(iface)*(p2-p1));
    %velocity(iface+size(bedge,1)) = flowrate(iface+size(bedge,1))/ nor;
    %Attribute the flow rate to "flowresult"
    %On the left:
    %flowresult(lef) = flowresult(lef) + flowrate(bedgesize + iface);  
    %On the right:
    %flowresult(rel) = flowresult(rel) - flowrate(bedgesize + iface);
end

end