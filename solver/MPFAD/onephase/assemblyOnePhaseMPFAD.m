function [ M, I ] = assemblyOnePhaseMPFAD( w,s, Kde, Ded, Kn, Kt, nflag, Hesq)

global coord elem esurn1 esurn2  bedge inedge  centelem bcflag wells elemarea 
% auxmobility1=mobility(1:size(inedge,1),1);
% auxmobility2=mobility((size(inedge,1)+1):(size(inedge,1)+size(bedge,1)),1);
% mobility(1:size(bedge,1),1)=auxmobility2;
% mobility((size(bedge,1)+1):(size(inedge,1)+size(bedge,1)),1)=auxmobility1;
%-----------------------inicio da rotina ----------------------------------%
%Constrói a matriz global.

M=sparse(size(elem,1),size(elem,1)); %Prealocação de M.
I=sparse(size(elem,1),1);
% fonte
%I=I+fonte.*elemarea;

%criar matriz monofasica
% if max(wells)~=0
%     sumvol=0;
%     for iw = 1:size(wells,1)
%         
%         if wells(iw,2)==1            % injetor
%             I(wells(iw,1))= 1*elemarea(wells(iw,1));        % injeta um m3 de agua por dia (d)
%             sumvol=sumvol+ elemarea(wells(iw,1));
%         end
%     end
%     I=I./sumvol;
% else
    for ifacont=1:size(bedge,1)
        
        v0=coord(bedge(ifacont,2),:)-coord(bedge(ifacont,1),:); %fase.
        v1=centelem(bedge(ifacont,3),:)-coord(bedge(ifacont,1),:);
        v2=centelem(bedge(ifacont,3),:)-coord(bedge(ifacont,2),:);
        normcont=norm(v0);
        % Tratamento do nó nos vértices 2 e 4%
        
        if bedge(ifacont,5)<200
            %DIRICHLET
            c1=nflag(bedge(ifacont,1),2);
            c2=nflag(bedge(ifacont,2),2);
            
            A=-Kn(ifacont)/(Hesq(ifacont)*norm(v0));
            
            %Preenchimento
            
            M(bedge(ifacont,3),bedge(ifacont,3))=M(bedge(ifacont,3),bedge(ifacont,3))-A*(norm(v0)^2);
            
            I(bedge(ifacont,3))=I(bedge(ifacont,3))-(dot(v2,-v0)*c1+dot ...
                (v1,v0)*c2)*A+(c2-c1)*Kt(ifacont);
            
        else
            %NEUMANN
            x=bcflag(:,1)==bedge(ifacont,5);
            r=find(x==1);
            I(bedge(ifacont,3))=I(bedge(ifacont,3)) -normcont*bcflag(r,2);
        end
    end
%end

% contribuição nas faces internas
for iface=1:size(inedge,1)
    % pressão prescrita no elemento do poço injetor
    
    
    %Contabiliza as contribuições do fluxo numa aresta para os elementos %
    %a direita e a esquerda dela.                                        %
    
    M(inedge(iface,3), inedge(iface,3))=M(inedge(iface,3), inedge(iface,3))- Kde(iface);
    M(inedge(iface,3), inedge(iface,4))=M(inedge(iface,3), inedge(iface,4))+ Kde(iface);
    M(inedge(iface,4), inedge(iface,4))=M(inedge(iface,4), inedge(iface,4))- Kde(iface);
    M(inedge(iface,4), inedge(iface,3))=M(inedge(iface,4), inedge(iface,3))+ Kde(iface);
    
    %Se os nós das arestas estiverem em fronteiras de Dirichlet, suas
    %contribuições serão contabilizadas logo abaixo.
    %CHECANDO SE OS NOS INTERNOS SAO CONDICAO DE NEUMAN OU DIRICHLET
   
    %%APPLYING DIRICHLET BOUNDARY CONDITIONS FOR INTERNAL EDGES
    %NO NEED TO INTERPOLATE I AND J as THEY ARE ALREADY DIRICHLET NODES
    if nflag(inedge(iface,1),1)<200  
%        disp('codigo 101 - 1')
        I(inedge(iface,3))=I(inedge(iface,3))-Kde(iface)*Ded(iface)*nflag(inedge(iface,1),2);
        I(inedge(iface,4))=I(inedge(iface,4))+Kde(iface)*Ded(iface)*nflag(inedge(iface,1),2);
    end
    if nflag(inedge(iface,2),1)<200
%        disp('codigo 102 - 1')
        I(inedge(iface,3))=I(inedge(iface,3))+Kde(iface)*Ded(iface)*nflag(inedge(iface,2),2);
        I(inedge(iface,4))=I(inedge(iface,4))-Kde(iface)*Ded(iface)*nflag(inedge(iface,2),2);
    end
    % quando o nó pertece ao contorno de Neumann

%% provavelmente lixo no codigo do fernando    NAO DELETAR
%     %%APPLYING NEUMANN BOUNDARY CONDITIONS FOR INTERNAL EDGES
%     if nflag(inedge(iface,1),1)==202
%         disp('codigo 201 - 1')
%         I(inedge(iface,3))=I(inedge(iface,3))-Kde(iface)*Ded(iface)*s(inedge(iface,1)); %ok        
%         I(inedge(iface,4))=I(inedge(iface,4))+Kde(iface)*Ded(iface)*s(inedge(iface,1)); %ok
%     end
%     if nflag(inedge(iface,2),1)==202
%         disp('codigo 201 - 2')
%         I(inedge(iface,3))=I(inedge(iface,3))+Kde(iface)*Ded(iface)*s(inedge(iface,2)); %ok
%         I(inedge(iface,4))=I(inedge(iface,4))-Kde(iface)*Ded(iface)*s(inedge(iface,2)); %ok
%     end
%
%%     
    %Contabilização das contribuições dos nós que não estão na
    %fronteiras de Dirichlet.
    
    if nflag(inedge(iface,1),1)>200
        for j=1:(esurn2(inedge(iface,1)+1)-esurn2(inedge(iface,1)))
            
            post_cont=esurn2(inedge(iface,1))+j;
            
            M(inedge(iface,3), esurn1(post_cont))=M(inedge(iface,3),esurn1(post_cont)) +Kde(iface)*Ded(iface)*w(post_cont);
            M(inedge(iface,4), esurn1(post_cont))=M(inedge(iface,4),esurn1(post_cont)) -Kde(iface)*Ded(iface)*w(post_cont);
            
        end
    end
    if nflag(inedge(iface,2),1)>200
        for j=1:(esurn2(inedge(iface,2)+1)-esurn2(inedge(iface,2))), ...
            post_cont=esurn2(inedge(iface,2))+j;            
            M(inedge(iface,3), esurn1(post_cont))=M(inedge(iface,3),esurn1(post_cont)) - Kde(iface)*Ded(iface)*w(post_cont);
            M(inedge(iface,4), esurn1(post_cont))=M(inedge(iface,4),esurn1(post_cont)) + Kde(iface)*Ded(iface)*w(post_cont);
        end
    end
end


%% Adding the influence of the wells on the matrix
if size(wells,2) > 1 
    wellSolv;
    if ~isempty(wells)
        %Saturation flags
        for index = 1:size(flagsSatElem,1)
            I(flagsSatElem{index})=  (flagsSatValue(index)/flagsSatTotalArea(index))  * elemarea(flagsSatElem{index});
        end
        
        for index = 1: size(flagsInjElem,1)
            M(flagsInjElem{index},:) = 0* M(flagsInjElem{index},:);
            %flagsInjElem{index},:)
            for ii = 1 : size(flagsInjElem{index},2)
                M(flagsInjElem{index}(ii),flagsInjElem{index}(ii)) = 1;
                I(flagsInjElem{index}(ii)) = flagsInjValue(index);
            end
            %for ii = 1: size(flags
        end
        
        for index = 1: size(flagsProdElem,1)
            M(flagsProdElem{index},:) = 0* M(flagsProdElem{index},:);
            %flagsInjElem{index},:)
            for ii = 1 : size(flagsProdElem{index},2)
                M(flagsProdElem{index}(ii),flagsProdElem{index}(ii)) = 1;
                I(flagsProdElem{index}(ii)) = flagsProdValue(index);
            end
            %for ii = 1: size(flags
        end
    end
end
%%

% adequação da matriz nos poços produtores

% contribuição dos poços
% if max(wells)~=0
%     sumvol=0;
%     for iw = 1:size(wells,1)  
%         if wells(iw,2)==1            % injetor
%             I(wells(iw,1))= 1*elemarea(wells(iw,1));        % injeta um m3 de agua por dia (d)
%             sumvol=sumvol+ elemarea(wells(iw,1));
%         end
%     end
%     I=I./sumvol;
% end


% 
% if max(wells)~=0
%     for iw = 1:size(wells,1)
%         if wells(iw,2)==2 %produtor
%             M(wells(iw,1),:)=0*M(wells(iw,1),:);
%             M(wells(iw,1),wells(iw,1))=1;
%             I(wells(iw,1))=0;
%         end
%     end
% end

end

