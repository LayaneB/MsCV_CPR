%funçao que calcula os fluxos nas arestas internas
%equacoes 28 e 29 (heterogeneo) ou 15 e 16 (homogeneo)

function [flowrate, flowresult]=flowrateMPFAD(p,w,s,Kde,Ded,Kn,Kt,Hesq,nflag,auxflag,mobility)

global coord esurn1 esurn2 bedge inedge centelem bcflag

%auxmobility1=mobility(1:size(inedge,1),1);
%auxmobility2=mobility((size(inedge,1)+1):(size(inedge,1)+size(bedge,1)),1);
%mobility(1:size(bedge,1),1)=auxmobility2;
%mobility((size(bedge,1)+1):(size(inedge,1)+size(bedge,1)),1)=auxmobility1;

%Initialize "bedgesize" and "inedgesize"
bedgesize = size(bedge,1);
inedgesize = size(inedge,1);

%Initialize "flowrate" and "flowresult"
flowrate = zeros(bedgesize + inedgesize,1);
flowresult = zeros(size(centelem,1),1);

if max(wells)~=0
    sumvol=0;
    for iw = 1:size(wells,1)
        
        if wells(iw,2)==1            % injetor
            I(wells(iw,1))= 1*elemarea(wells(iw,1));        % injeta um m3 de agua por dia (d)
            sumvol=sumvol+ elemarea(wells(iw,1));
        end
    end
    I=I./sumvol;
else
    for ifacont=1:size(bedge,1);
        lef=bedge(ifacont,3);
        O=centelem(lef,:); % baricentro do elemento a esuqerda
        B1=bedge(ifacont,1);
        B2=bedge(ifacont,2);
        nor=norm(coord(B1,:)-coord(B2,:));
        
        if bedge(ifacont,5)<200 % se os nós esteverem na fronteira de DIRICHLET
            
            c1=nflag(B1,2);
            c2=nflag(B2,2);
            
            A=(Kn(ifacont)/(Hesq(ifacont)*nor));
            
            auxflowrate=-A*(((O-coord(B2,:)))*(coord(B1,:)-coord(B2,:))'*c1+(O-coord(B1,:))*(coord(B2,:)-coord(B1,:))'*c2-(nor^2)*p(lef))-(c2-c1)*Kt(ifacont);
            
            flowrate(ifacont)= auxflowrate; % *mobility(ifacont);
        else
            x=bcflag(:,1)==bedge(ifacont,5);
            r=find(x==1);
            flowrate(ifacont)= nor*bcflag(r,2);
        end
        %Attribute the flow rate to "flowresult"
        %On the left:
        flowresult(lef) = flowresult(lef) + flowrate(ifacont);
    end
end
for iface=1:size(inedge,1)
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
    
    %calculo das vazões
    flowrate(iface+size(bedge,1))=mobility(iface+size(bedge,1))*Kde(iface)*(p(rel)-p(lef)-Ded(iface)*(p2-p1));
    %Attribute the flow rate to "flowresult"
    %On the left:
    flowresult(lef) = flowresult(lef) + flowrate(bedgesize + iface);  
    %On the right:
    flowresult(rel) = flowresult(rel) - flowrate(bedgesize + iface);
end

end