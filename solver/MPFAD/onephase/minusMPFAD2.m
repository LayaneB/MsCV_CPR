function [ M, I ] = minusMPFAD2(M,I, edgesOnCoarseBoundary, w,s, Kde, Ded, Kn, Kt, nflag, Hesq)

global elem esurn1 esurn2 inedge
% auxmobility1=mobility(1:size(inedge,1),1);
% auxmobility2=mobility((size(inedge,1)+1):(size(inedge,1)+size(bedge,1)),1);
% mobility(1:size(bedge,1),1)=auxmobility2;
% mobility((size(bedge,1)+1):(size(inedge,1)+size(bedge,1)),1)=auxmobility1;
%-----------------------inicio da rotina ----------------------------------%
%Constrói a matriz global.


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

for index=1:size(edgesOnCoarseBoundary,1)
    % pressão prescrita no elemento do poço injetor
    
    iface = edgesOnCoarseBoundary(index);
    
    %Contabiliza as contribuições do fluxo numa aresta para os elementos %
    %a direita e a esquerda dela.                                        %
    
    M(inedge(iface,3), inedge(iface,3))=M(inedge(iface,3), inedge(iface,3))+ Kde(iface);
    M(inedge(iface,3), inedge(iface,4))=M(inedge(iface,3), inedge(iface,4))- Kde(iface);
    M(inedge(iface,4), inedge(iface,4))=M(inedge(iface,4), inedge(iface,4))+ Kde(iface);
    M(inedge(iface,4), inedge(iface,3))=M(inedge(iface,4), inedge(iface,3))- Kde(iface);
    
    
end


allnodes = unique(inedge(edgesOnCoarseBoundary,1:2));


for jj = 1 : size(allnodes)
    
    %Contabilização das contribuições dos nós que não estão na
    %fronteiras de Dirichlet.
    node = allnodes(jj);
    
    if nflag(inedge(iface,1),1)>200
        for j=1:(esurn2(inedge(iface,1)+1)-esurn2(inedge(iface,1)))
            
            post_cont=esurn2(inedge(iface,1))+j;
            
            M(inedge(iface,3), esurn1(post_cont))=M(inedge(iface,3),esurn1(post_cont)) -Kde(iface)*Ded(iface)*w(post_cont);
            
            M(inedge(iface,4), esurn1(post_cont))=M(inedge(iface,4),esurn1(post_cont)) +Kde(iface)*Ded(iface)*w(post_cont);
            
        end
    end
    if nflag(inedge(iface,2),1)>200
        for j=1:(esurn2(inedge(iface,2)+1)-esurn2(inedge(iface,2))), ...
            post_cont=esurn2(inedge(iface,2))+j;            
            M(inedge(iface,3), esurn1(post_cont))=M(inedge(iface,3),esurn1(post_cont)) + Kde(iface)*Ded(iface)*w(post_cont);
            M(inedge(iface,4), esurn1(post_cont))=M(inedge(iface,4),esurn1(post_cont)) - Kde(iface)*Ded(iface)*w(post_cont);
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

