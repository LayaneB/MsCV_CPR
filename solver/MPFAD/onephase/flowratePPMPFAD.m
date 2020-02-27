%funçao que calcula os fluxos nas arestas internas
%equacoes 28 e 29 (heterogeneo) ou 15 e 16 (homogeneo)

function [flowrate, flowresult,velocity]=flowratePPMPFAD(p,w,s,wsdynamic, Kde,Ded,Kn,Kt,Hesq,nflag,auxflag,mobility,mob)
%check for TWO-PHASE
global coord esurn1 esurn2 bedge inedge centelem bcflag semiEdges oneNodeEdges regularEdges elemloc

auxmobility1=mobility(1:size(inedge,1),:);
auxmobility2=mobility((size(inedge,1)+1):(size(inedge,1)+size(bedge,1)),:);
mobility(1:size(bedge,1),:)=auxmobility2;
mobility((size(bedge,1)+1):(size(inedge,1)+size(bedge,1)),:)=auxmobility1;



auxmobility1=mob(1:size(inedge,1),:);
auxmobility2=mob((size(inedge,1)+1):(size(inedge,1)+size(bedge,1)),:);
mob(1:size(bedge,1),:)=auxmobility2;
mob((size(bedge,1)+1):(size(inedge,1)+size(bedge,1)),:)=auxmobility1;

%Initialize "bedgesize" and "inedgesize"
bedgesize = size(bedge,1);
inedgesize = size(inedge,1);

%Initialize "flowrate" and "flowresult"
flowrate = zeros(bedgesize + inedgesize,1);
velocity = zeros(bedgesize + inedgesize,1);

flowresult = zeros(size(centelem,1),1);
for ifacont=1:size(bedge,1);
    lef=bedge(ifacont,3);
    O=centelem(lef,:); % baricentro do elemento a esuqerda
    B1=bedge(ifacont,1);
    B2=bedge(ifacont,2);
    nor=norm(coord(B1,:)-coord(B2,:));

%     if ifacont == 320
%         1+1
%     end
    if bedge(ifacont,5)<200 % se os nós esteverem na fronteira de DIRICHLET
        
        c1=nflag(B1,2);
        c2=nflag(B2,2);
        region = elemloc(bedge(ifacont,3));
        A=(Kn(ifacont)/(Hesq(ifacont)*nor));
        
        auxflowrate=-A*(((O-coord(B2,:)))*(coord(B1,:)-coord(B2,:))'*c1+(O-coord(B1,:))*(coord(B2,:)-coord(B1,:))'*c2-(nor^2)*p(lef))-(c2-c1)*Kt(ifacont);
		
        %flowrate(ifacont)= mobility(ifacont)*auxflowrate;
        flowrate(ifacont)= mob(ifacont,region)*auxflowrate;
        
        
    else
        x=bcflag(:,1)==bedge(ifacont,5);
        r=find(x==1);
        flowrate(ifacont)= nor*bcflag(r,2);
    end
    %Attribute the flow rate to "flowresult"
    %On the left:
    flowresult(lef) = flowresult(lef) + flowrate(ifacont);
    velocity(ifacont) = flowrate(ifacont)/ nor;
end



for ii=1:size(regularEdges,1)
    
    iface = regularEdges(ii);
    if iface == 512
        1+1;
    end
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
    
    
    B1=inedge(iface,1);
    B2=inedge(iface,2);
    nor=norm(coord(B1,:)-coord(B2,:));
    
    %calculo das vazões
    flowrate(iface+size(bedge,1))= mobility(iface+size(bedge,1))*Kde(iface)*(p(rel)-p(lef)-Ded(iface)*(p2-p1));
    velocity(iface+size(bedge,1)) = flowrate(iface+size(bedge,1))/ nor;
    %Attribute the flow rate to "flowresult"
    %On the left:
    flowresult(lef) = flowresult(lef) + flowrate(bedgesize + iface);  
    %On the right:
    flowresult(rel) = flowresult(rel) - flowrate(bedgesize + iface);
end


%% segmento para calcular oneNodeEdges




for ii=1:size(oneNodeEdges,1)
    
    iface = oneNodeEdges(ii,1);
    pp1 = inedge(iface,1);
    pp2 = inedge(iface,2);
    flag = oneNodeEdges(ii,2);
    region = elemloc(inedge(iface,3));
    if iface == 512
        1+1;
    end
    lef=inedge(iface,3); %indice do elemento a direita da aresta i
    rel=inedge(iface,4); %indice do elemento a esquerda da aresta i
    % interpolando os nós (ou vértices)
    listEl1 = esurnOrd(inedge(iface,1),region);
    nec1 = size(listEl1,1);
    listEl2 = esurnOrd(inedge(iface,2),region);
    nec2 = size(listEl2,1);    
    %nec1=esurn2(inedge(iface,1)+1)-esurn2(inedge(iface,1));
    p1=0;

    %% interpolando Pi e Pj
    % calculo da pressão no nó "inedge(iface,1)"
    if nflag(inedge(iface,1),1) >200
        if true
        %if  ( (flag == 1) || (flag == 3)) % nflag(inedge(iface,1),1)==auxflag  &&
            
            wD = wsdynamic.readW(inedge(iface,1),region);
            sD = wsdynamic.readS(inedge(iface,1),region);
            
            for j=1:nec1
                element1 = listEl1(j);
                %element1=esurn1(esurn2(inedge(iface,1))+j);
                %interpolação
                
                p1= p1 + wD(j)*p(element1);
                
                %p1=p1+w(esurn2(inedge(iface,1))+j)*p(element1);
            end
            p1=p1+sD;
            %p1=p1+s(inedge(iface,1),1);
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
    %nec2=esurn2(inedge(iface,2)+1)- esurn2(inedge(iface,2));
    p2=0;
    if  nflag(inedge(iface,2),1)>200
       if true
       % if ( (flag == 2) || (flag == 3)) % nflag(inedge(iface,2),1)==auxflag  && 
            wD = wsdynamic.readW(inedge(iface,2),region);
            
            sD = wsdynamic.readS(inedge(iface,2),region);

            for j=1:nec2
                element2 = listEl2(j);
                %element2=esurn1(esurn2(inedge(iface,2))+j);
                p2= p2 + wD(j)*p(element2);
                %p2=p2+w(esurn2(inedge(iface,2))+j)*p(element2);
            end
            p2=p2+sD;
 %           p2=p2+s(inedge(iface,2),1);
        else
            for j=1:nec2
                element2=esurn1(esurn2(inedge(iface,2))+j);
                p2=p2+w(esurn2(inedge(iface,2))+j)*p(element2);
            end
            
        end
        
    else
        p2=nflag(inedge(iface,2),2);
    end
    
    
    B1=inedge(iface,1);
    B2=inedge(iface,2);
    nor=norm(coord(B1,:)-coord(B2,:));
    
    %calculo das vazões
    flowrate(iface+size(bedge,1))=mob(iface+size(bedge,1),region)*Kde(iface)*(p(rel)-p(lef)-Ded(iface)*(p2-p1));
    velocity(iface+size(bedge,1)) = flowrate(iface+size(bedge,1))/ nor;
    %Attribute the flow rate to "flowresult"
    %On the left:
    flowresult(lef) = flowresult(lef) + flowrate(bedgesize + iface);  
    %On the right:
    flowresult(rel) = flowresult(rel) - flowrate(bedgesize + iface);
end


%semiEdges
for ii=1:size(semiEdges,1)
    
    iface = semiEdges(ii,1);
    pp1 = inedge(iface,1);
    pp2 = inedge(iface,2);
    flag = semiEdges(ii,2);
    region = elemloc(inedge(iface,3));
    if iface == 512
        1+1;
    end
    lef=inedge(iface,3); %indice do elemento a direita da aresta i
    rel=inedge(iface,4); %indice do elemento a esquerda da aresta i
    % interpolando os nós (ou vértices)
    listEl1 = esurnOrd(inedge(iface,1),region);
    nec1 = size(listEl1,1);
    listEl2 = esurnOrd(inedge(iface,2),region);
    nec2 = size(listEl2,1);    
    %nec1=esurn2(inedge(iface,1)+1)-esurn2(inedge(iface,1));
    p1=0;

    %% interpolando Pi e Pj
    % calculo da pressão no nó "inedge(iface,1)"
    if nflag(inedge(iface,1),1) >200
        %if true
        if  ( (flag == 1) || (flag == 3)) % nflag(inedge(iface,1),1)==auxflag  &&
            
            wD = wsdynamic.readW(inedge(iface,1),region);
            sD = wsdynamic.readS(inedge(iface,1),region);
            
            for j=1:nec1
                element1 = listEl1(j);
                %element1=esurn1(esurn2(inedge(iface,1))+j);
                %interpolação
                
                p1= p1 + wD(j)*p(element1);
                
                %p1=p1+w(esurn2(inedge(iface,1))+j)*p(element1);
            end
            p1=p1+sD;
            %p1=p1+s(inedge(iface,1),1);
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
    %nec2=esurn2(inedge(iface,2)+1)- esurn2(inedge(iface,2));
    p2=0;
    if  nflag(inedge(iface,2),1)>200
       %if true
        if ( (flag == 2) || (flag == 3)) % nflag(inedge(iface,2),1)==auxflag  && 
            wD = wsdynamic.readW(inedge(iface,2),region);
            
            sD = wsdynamic.readS(inedge(iface,2),region);

            for j=1:nec2
                element2 = listEl2(j);
                %element2=esurn1(esurn2(inedge(iface,2))+j);
                p2= p2 + wD(j)*p(element2);
                %p2=p2+w(esurn2(inedge(iface,2))+j)*p(element2);
            end
            p2=p2+sD;
 %           p2=p2+s(inedge(iface,2),1);
        else
            for j=1:nec2
                element2=esurn1(esurn2(inedge(iface,2))+j);
                p2=p2+w(esurn2(inedge(iface,2))+j)*p(element2);
            end
            
        end
        
    else
        p2=nflag(inedge(iface,2),2);
    end
    
    
    B1=inedge(iface,1);
    B2=inedge(iface,2);
    nor=norm(coord(B1,:)-coord(B2,:));
    
    %calculo das vazões
    flowrate(iface+size(bedge,1))=mob(iface+size(bedge,1),region)*Kde(iface)*(p(rel)-p(lef)-Ded(iface)*(p2-p1));
    velocity(iface+size(bedge,1)) =flowrate(iface+size(bedge,1))/ nor;
    %Attribute the flow rate to "flowresult"
    %On the left:
    flowresult(lef) = flowresult(lef) + flowrate(bedgesize + iface);  
    %On the right:
    flowresult(rel) = flowresult(rel) - flowrate(bedgesize + iface);
end

end