%funçao que calcula os fluxos nas arestas internas
%equacoes 28 e 29 (heterogeneo) ou 15 e 16 (homogeneo)

function [flowrate]=flowrateTPFA(tEq, Kbedge, p,HL)

%p,w,s,Kde,Ded,Kn,Kt,Hesq,nflag,auxflag)

global coord bedge inedge

%mobility = 1;
%auxmobility1=mobility(1:size(inedge,1),1);
%auxmobility2=mobility((size(inedge,1)+1):(size(inedge,1)+size(bedge,1)),1);
%mobility(1:size(bedge,1),1)=auxmobility2;
%mobility((size(bedge,1)+1):(size(inedge,1)+size(bedge,1)),1)=auxmobility1;


    
flowrate =   sparse(size(inedge,1) + size(bedge,1),1) ; 
%flowresult = zeros(size(inedge,1) + size(inedge,1),1);
for index = 1: size(bedge,1)

        
    lef = bedge(index,3);
    B1 = bedge(index,1);
    B2 = bedge(index,2);
    nor = norm(coord(B1,:) - coord(B2,:));  
    % both flags dirichlet 
    if (bedge(index,4) < 200) && (bedge(index,5) < 200)
        %flagr = bedge(index,5);

        
        pleft = bcflagValue(bedge(index,4));
        pright = bcflagValue(bedge(index,5));
        pavg = (pleft + pright)*0.5;
        pc = p(bedge(index,3));
        
        r=pavg-pc;
        pb=pavg+r;

        flowrate(index) =  Kbedge(index) *nor*((pavg-pc)/(1*HL(index)));  
        %flowrate(index)= -Kbedge(index) *nor* ((pb-pc)/(HL(index)));   
         
    % both flags neumann
    elseif  (bedge(index,4) > 200) && (bedge(index,5) > 200)
       flowrate(index) =  bcflagValue(bedge(index,5));
        
    %one flag dirichlet one flag neuman    
    else
        
        if bedge(index,4) < 200
            pavg = bcflagValue(bedge(index,4));
        else
            pavg = bcflagValue(bedge(index,5));                 
        end
            pc = p(bedge(index,3));
            flowrate(index) =  +Kbedge(index)*nor*((pavg-pc)/(HL(index)));         
    end
    
    
    
end



bedSize = size(bedge,1);

for index = 1:size(inedge,1)
    left = inedge(index,3); %indice do elemento a direita da aresta i
    right = inedge(index,4); %indice do elemento a esquerda da aresta i
    % nor = faceDist(index)    
    flowrate(index+bedSize) =  tEq(index)*(p(right)-p(left)) ;
end


end

% 
% 
% %Initialize "bedgesize" and "inedgesize"
% bedgesize = size(bedge,1);
% inedgesize = size(inedge,1);
% 
% %Initialize "flowrate" and "flowresult"
% flowrate = zeros(bedgesize + inedgesize,1);
% velocity = zeros(bedgesize + inedgesize,1);
% 
% flowresult = zeros(size(centelem,1),1);
% for ifacont=1:size(bedge,1);
%     lef=bedge(ifacont,3);
%     O=centelem(lef,:); % baricentro do elemento a esuqerda
%     B1=bedge(ifacont,1);
%     B2=bedge(ifacont,2);
%     nor=norm(coord(B1,:)-coord(B2,:));
%     
%     if bedge(ifacont,5)<200 % se os nós esteverem na fronteira de DIRICHLET
%         
%         c1=nflag(B1,2);
%         c2=nflag(B2,2);
%         
%         A=(Kn(ifacont)/(Hesq(ifacont)*nor));
%         
%         auxflowrate=-A*(((O-coord(B2,:)))*(coord(B1,:)-coord(B2,:))'*c1+(O-coord(B1,:))*(coord(B2,:)-coord(B1,:))'*c2-(nor^2)*p(lef))-(c2-c1)*Kt(ifacont);
% 		
%         flowrate(ifacont)= auxflowrate;
%     else
%         x=bcflag(:,1)==bedge(ifacont,5);
%         r=find(x==1);
%         flowrate(ifacont)= nor*bcflag(r,2);
%     end
%     %Attribute the flow rate to "flowresult"
%     %On the left:
%     flowresult(lef) = flowresult(lef) + flowrate(ifacont);
%     velocity(ifacont) = flowrate(ifacont)/ nor;
% end
% 
% for iface=1:size(inedge,1)
%     lef=inedge(iface,3); %indice do elemento a direita da aresta i
%     rel=inedge(iface,4); %indice do elemento a esquerda da aresta i
%     % interpolando os nós (ou vértices)
%     nec1=esurn2(inedge(iface,1)+1)-esurn2(inedge(iface,1));
%     p1=0;
%     % calculo da pressão no nó "inedge(iface,1)"
%     if nflag(inedge(iface,1),1) >200
%         if nflag(inedge(iface,1),1)==auxflag
%             for j=1:nec1
%                 element1=esurn1(esurn2(inedge(iface,1))+j);
%                 %interpolação
%                 p1=p1+w(esurn2(inedge(iface,1))+j)*p(element1);
%             end
%             p1=p1+s(inedge(iface,1),1);
%         else
%             for j=1:nec1
%                 element1=esurn1(esurn2(inedge(iface,1))+j);
%                 p1=p1+w(esurn2(inedge(iface,1))+j)*p(element1);
%             end
%         end
%         
%     else
%         p1=nflag(inedge(iface,1),2);
%     end
%     
%     % calculo da pressão no "inedge(i,2)"
%     nec2=esurn2(inedge(iface,2)+1)- esurn2(inedge(iface,2));
%     p2=0;
%     if  nflag(inedge(iface,2),1)>200
%         if nflag(inedge(iface,2),1)==auxflag
%             for j=1:nec2
%                 element2=esurn1(esurn2(inedge(iface,2))+j);
%                 p2=p2+w(esurn2(inedge(iface,2))+j)*p(element2);
%             end
%             p2=p2+s(inedge(iface,2),1);
%         else
%             for j=1:nec2
%                 element2=esurn1(esurn2(inedge(iface,2))+j);
%                 p2=p2+w(esurn2(inedge(iface,2))+j)*p(element2);
%             end
%             
%         end
%         
%     else
%         p2=nflag(inedge(iface,2),2);
%     end
%     
%     
%     B1=inedge(iface,1);
%     B2=inedge(iface,2);
%     nor=norm(coord(B1,:)-coord(B2,:));
%     
%     %calculo das vazões
%     flowrate(iface+size(bedge,1))=Kde(iface)*(p(rel)-p(lef)-Ded(iface)*(p2-p1));
%     velocity(iface+size(bedge,1)) = flowrate(iface+size(bedge,1))/ nor;
%     %Attribute the flow rate to "flowresult"
%     %On the left:
%     flowresult(lef) = flowresult(lef) + flowrate(bedgesize + iface);  
%     %On the right:
%     flowresult(rel) = flowresult(rel) - flowrate(bedgesize + iface);
% end
% 
% end