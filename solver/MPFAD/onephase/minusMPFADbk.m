function [ M, I ] = minusMPFAD(M,I, edgesOnCoarseBoundary, w,s, Kde, Ded, Kn, Kt, nflag, Hesq,mobility)

global elem esurn1 esurn2 inedge oneNodeEdges bedge semiEdges
auxmobility1=mobility(1:size(inedge,1),1);
auxmobility2=mobility((size(inedge,1)+1):(size(inedge,1)+size(bedge,1)),1);
mobility(1:size(bedge,1),1)=auxmobility2;
mobility((size(bedge,1)+1):(size(inedge,1)+size(bedge,1)),1)=auxmobility1;
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

%% retira influencia das arestas entre coarse volumes
for index=1:size(edgesOnCoarseBoundary,1)
    % pressão prescrita no elemento do poço injetor
    iface = edgesOnCoarseBoundary(index);
    %Contabiliza as contribuições do fluxo numa aresta para os elementos %
    %a direita e a esquerda dela.                                        %
    
    M(inedge(iface,3), inedge(iface,3))=M(inedge(iface,3), inedge(iface,3))+ mobility(iface+size(bedge,1))* Kde(iface);
    M(inedge(iface,3), inedge(iface,4))=M(inedge(iface,3), inedge(iface,4))- mobility(iface+size(bedge,1))* Kde(iface);
    M(inedge(iface,4), inedge(iface,4))=M(inedge(iface,4), inedge(iface,4))+ mobility(iface+size(bedge,1))* Kde(iface);
    M(inedge(iface,4), inedge(iface,3))=M(inedge(iface,4), inedge(iface,3))- mobility(iface+size(bedge,1))* Kde(iface);
    
    %Se os nós das arestas estiverem em fronteiras de Dirichlet, suas
    %contribuições serão contabilizadas logo abaixo.
    %CHECANDO SE OS NOS INTERNOS SAO CONDICAO DE NEUMAN OU DIRICHLET
    if nflag(inedge(iface,1),1)<200
        I(inedge(iface,3))=I(inedge(iface,3))+mobility(iface+size(bedge,1))*Kde(iface)*Ded(iface)*nflag(inedge(iface,1),2);
        I(inedge(iface,4))=I(inedge(iface,4))-mobility(iface+size(bedge,1))*Kde(iface)*Ded(iface)*nflag(inedge(iface,1),2);
    end
    if nflag(inedge(iface,2),1)<200
        I(inedge(iface,3))=I(inedge(iface,3))-mobility(iface+size(bedge,1))*Kde(iface)*Ded(iface)*nflag(inedge(iface,2),2);
        I(inedge(iface,4))=I(inedge(iface,4))+mobility(iface+size(bedge,1))*Kde(iface)*Ded(iface)*nflag(inedge(iface,2),2);
    end

    
    %Contabilização das contribuições dos nós que não estão na
    %fronteiras de Dirichlet.
    %Ponto 1
    if nflag(inedge(iface,1),1)>200
%        disp('entrou em dirichlet ponto 1')
        for j=1:(esurn2(inedge(iface,1)+1)-esurn2(inedge(iface,1)))            
            post_cont=esurn2(inedge(iface,1))+j;            
            M(inedge(iface,3), esurn1(post_cont))=M(inedge(iface,3),esurn1(post_cont)) -mobility(iface+size(bedge,1))*Kde(iface)*Ded(iface)*w(post_cont);            
            M(inedge(iface,4), esurn1(post_cont))=M(inedge(iface,4),esurn1(post_cont)) +mobility(iface+size(bedge,1))*Kde(iface)*Ded(iface)*w(post_cont);
            
        end
    end
    %Ponto 2
    if nflag(inedge(iface,2),1)>200
%        disp('entrou em dirichlet ponto 2')
        for j=1:(esurn2(inedge(iface,2)+1)-esurn2(inedge(iface,2))), ...
            post_cont=esurn2(inedge(iface,2))+j;            
            M(inedge(iface,3), esurn1(post_cont))=M(inedge(iface,3),esurn1(post_cont)) +mobility(iface+size(bedge,1))* Kde(iface)*Ded(iface)*w(post_cont);
            M(inedge(iface,4), esurn1(post_cont))=M(inedge(iface,4),esurn1(post_cont)) -mobility(iface+size(bedge,1))* Kde(iface)*Ded(iface)*w(post_cont);
        end
    end
end


for index=1:size(oneNodeEdges,1)
    % pressão prescrita no elemento do poço injetor
    
    iface = oneNodeEdges(index,1);    
    %Contabiliza as contribuições do fluxo numa aresta para os elementos %
    %a direita e a esquerda dela.                                        %
    
    M(inedge(iface,3), inedge(iface,3))=M(inedge(iface,3), inedge(iface,3))+ mobility(iface+size(bedge,1))* Kde(iface);
    M(inedge(iface,3), inedge(iface,4))=M(inedge(iface,3), inedge(iface,4))- mobility(iface+size(bedge,1))* Kde(iface);
    M(inedge(iface,4), inedge(iface,4))=M(inedge(iface,4), inedge(iface,4))+ mobility(iface+size(bedge,1))* Kde(iface);
    M(inedge(iface,4), inedge(iface,3))=M(inedge(iface,4), inedge(iface,3))- mobility(iface+size(bedge,1))* Kde(iface);
    
    %Se os nós das arestas estiverem em fronteiras de Dirichlet, suas
    %contribuições serão contabilizadas logo abaixo.
    %CHECANDO SE OS NOS INTERNOS SAO CONDICAO DE NEUMAN OU DIRICHLET
    if nflag(inedge(iface,1),1)<200
        I(inedge(iface,3))=I(inedge(iface,3))+mobility(iface+size(bedge,1))*Kde(iface)*Ded(iface)*nflag(inedge(iface,1),2);
        I(inedge(iface,4))=I(inedge(iface,4))-mobility(iface+size(bedge,1))*Kde(iface)*Ded(iface)*nflag(inedge(iface,1),2);
    end
    if nflag(inedge(iface,2),1)<200
        I(inedge(iface,3))=I(inedge(iface,3))-mobility(iface+size(bedge,1))*Kde(iface)*Ded(iface)*nflag(inedge(iface,2),2);
        I(inedge(iface,4))=I(inedge(iface,4))+mobility(iface+size(bedge,1))*Kde(iface)*Ded(iface)*nflag(inedge(iface,2),2);
    end

    
    %Contabilização das contribuições dos nós que não estão na
    %fronteiras de Dirichlet.
    %Ponto 1
    if nflag(inedge(iface,1),1)>200
%        disp('entrou em dirichlet ponto 1')
        for j=1:(esurn2(inedge(iface,1)+1)-esurn2(inedge(iface,1)))            
            post_cont=esurn2(inedge(iface,1))+j;            
            M(inedge(iface,3), esurn1(post_cont))=M(inedge(iface,3),esurn1(post_cont)) -mobility(iface+size(bedge,1))*Kde(iface)*Ded(iface)*w(post_cont);            
            M(inedge(iface,4), esurn1(post_cont))=M(inedge(iface,4),esurn1(post_cont)) +mobility(iface+size(bedge,1))*Kde(iface)*Ded(iface)*w(post_cont);
            
        end
    end
    %Ponto 2
    if nflag(inedge(iface,2),1)>200
%        disp('entrou em dirichlet ponto 2')
        for j=1:(esurn2(inedge(iface,2)+1)-esurn2(inedge(iface,2))), ...
            post_cont=esurn2(inedge(iface,2))+j;            
            M(inedge(iface,3), esurn1(post_cont))=M(inedge(iface,3),esurn1(post_cont)) +mobility(iface+size(bedge,1))* Kde(iface)*Ded(iface)*w(post_cont);
            M(inedge(iface,4), esurn1(post_cont))=M(inedge(iface,4),esurn1(post_cont)) -mobility(iface+size(bedge,1))* Kde(iface)*Ded(iface)*w(post_cont);
        end
    end
end





% 
% %desacoplando o oneNode
for index=1:size(oneNodeEdges,1)
    iface = oneNodeEdges(index,1);
    iflag = oneNodeEdges(index,2);
    
    
    %if iflag == 1 || iflag  == 3
     if true
        if nflag(inedge(iface,1),1)<200
            I(inedge(iface,3))=I(inedge(iface,3))+mobility(iface+size(bedge,1))*Kde(iface)*Ded(iface)*nflag(inedge(iface,1),2);
            I(inedge(iface,4))=I(inedge(iface,4))-mobility(iface+size(bedge,1))*Kde(iface)*Ded(iface)*nflag(inedge(iface,1),2);
        end
    end
    %if iflag == 2 || iflag  == 3
    if true
        if nflag(inedge(iface,2),1)<200
            I(inedge(iface,3))=I(inedge(iface,3))-mobility(iface+size(bedge,1))*Kde(iface)*Ded(iface)*nflag(inedge(iface,2),2);
            I(inedge(iface,4))=I(inedge(iface,4))+mobility(iface+size(bedge,1))*Kde(iface)*Ded(iface)*nflag(inedge(iface,2),2);
        end
    end
%    quando o nó pertece ao contorno de Neumann
%     if iflag == 1 || iflag  == 3
%         if nflag(inedge(iface,1),1)==202
%             disp('neuman bc - 01 ')
%             I(inedge(iface,3))=I(inedge(iface,3))+mobility(iface+size(bedge,1))*Kde(iface)*Ded(iface)*s(inedge(iface,1)); %ok
%             I(inedge(iface,4))=I(inedge(iface,4))-mobility(iface+size(bedge,1))*Kde(iface)*Ded(iface)*s(inedge(iface,1)); %ok
%         end
%     end
%     
%     if iflag == 2 || iflag  == 3
%         if nflag(inedge(iface,2),1)==202
%             disp('neuman bc - 02 ')
%             I(inedge(iface,3))=I(inedge(iface,3))-mobility(iface+size(bedge,1))*Kde(iface)*Ded(iface)*s(inedge(iface,2)); %ok
%             I(inedge(iface,4))=I(inedge(iface,4))+mobility(iface+size(bedge,1))*Kde(iface)*Ded(iface)*s(inedge(iface,2)); %ok
%         end
%     end
    %Contabilização das contribuições dos nós que não estão na
    %fronteiras de Dirichlet.
    %Ponto 1
    %if iflag == 1 || iflag  == 3
    if true 
        if nflag(inedge(iface,1),1)>200
            for j=1:(esurn2(inedge(iface,1)+1)-esurn2(inedge(iface,1)))
                post_cont=esurn2(inedge(iface,1))+j;
                M(inedge(iface,3), esurn1(post_cont))=M(inedge(iface,3),esurn1(post_cont)) -mobility(iface+size(bedge,1))*Kde(iface)*Ded(iface)*w(post_cont);
                M(inedge(iface,4), esurn1(post_cont))=M(inedge(iface,4),esurn1(post_cont)) +mobility(iface+size(bedge,1))*Kde(iface)*Ded(iface)*w(post_cont);
            end
        end
    end
    %if iflag == 2 || iflag  == 3
    %Ponto 2
    if true
        if nflag(inedge(iface,2),1)>200
            for j=1:(esurn2(inedge(iface,2)+1)-esurn2(inedge(iface,2))), ...
                post_cont=esurn2(inedge(iface,2))+j;            
                M(inedge(iface,3), esurn1(post_cont))=M(inedge(iface,3),esurn1(post_cont)) +mobility(iface+size(bedge,1))* Kde(iface)*Ded(iface)*w(post_cont);
                M(inedge(iface,4), esurn1(post_cont))=M(inedge(iface,4),esurn1(post_cont)) -mobility(iface+size(bedge,1))* Kde(iface)*Ded(iface)*w(post_cont);
            end
        end    
    end
end



%%desacoplando semiEdges
for index=1:size(semiEdges,1)
    iface = semiEdges(index,1);
    iflag = semiEdges(index,2);
    
    
    if iflag == 1 || iflag  == 3
       if nflag(inedge(iface,1),1)<200
            I(inedge(iface,3))=I(inedge(iface,3))+mobility(iface+size(bedge,1))*Kde(iface)*Ded(iface)*nflag(inedge(iface,1),2);
            I(inedge(iface,4))=I(inedge(iface,4))-mobility(iface+size(bedge,1))*Kde(iface)*Ded(iface)*nflag(inedge(iface,1),2);
        end
    end
    if iflag == 2 || iflag  == 3
        if nflag(inedge(iface,2),1)<200
            I(inedge(iface,3))=I(inedge(iface,3))-mobility(iface+size(bedge,1))*Kde(iface)*Ded(iface)*nflag(inedge(iface,2),2);
            I(inedge(iface,4))=I(inedge(iface,4))+mobility(iface+size(bedge,1))*Kde(iface)*Ded(iface)*nflag(inedge(iface,2),2);
        end
    end
%    quando o nó pertece ao contorno de Neumann
%     if iflag == 1 || iflag  == 3
%         if nflag(inedge(iface,1),1)==202
%             disp('neuman bc - 01 ')
%             I(inedge(iface,3))=I(inedge(iface,3))+mobility(iface+size(bedge,1))*Kde(iface)*Ded(iface)*s(inedge(iface,1)); %ok
%             I(inedge(iface,4))=I(inedge(iface,4))-mobility(iface+size(bedge,1))*Kde(iface)*Ded(iface)*s(inedge(iface,1)); %ok
%         end
%     end
%     
%     if iflag == 2 || iflag  == 3
%         if nflag(inedge(iface,2),1)==202
%             disp('neuman bc - 02 ')
%             I(inedge(iface,3))=I(inedge(iface,3))-mobility(iface+size(bedge,1))*Kde(iface)*Ded(iface)*s(inedge(iface,2)); %ok
%             I(inedge(iface,4))=I(inedge(iface,4))+mobility(iface+size(bedge,1))*Kde(iface)*Ded(iface)*s(inedge(iface,2)); %ok
%         end
%     end
    %Contabilização das contribuições dos nós que não estão na
    %fronteiras de Dirichlet.
    %Ponto 1
    if iflag == 1 || iflag  == 3
        if nflag(inedge(iface,1),1)>200
            for j=1:(esurn2(inedge(iface,1)+1)-esurn2(inedge(iface,1)))
                post_cont=esurn2(inedge(iface,1))+j;
                M(inedge(iface,3), esurn1(post_cont))=M(inedge(iface,3),esurn1(post_cont)) -mobility(iface+size(bedge,1))*Kde(iface)*Ded(iface)*w(post_cont);
                M(inedge(iface,4), esurn1(post_cont))=M(inedge(iface,4),esurn1(post_cont)) +mobility(iface+size(bedge,1))*Kde(iface)*Ded(iface)*w(post_cont);
            end
        end
    end
    if iflag == 2 || iflag  == 3
    %Ponto 2
        if nflag(inedge(iface,2),1)>200
            for j=1:(esurn2(inedge(iface,2)+1)-esurn2(inedge(iface,2))), ...
                post_cont=esurn2(inedge(iface,2))+j;            
                M(inedge(iface,3), esurn1(post_cont))=M(inedge(iface,3),esurn1(post_cont)) +mobility(iface+size(bedge,1))* Kde(iface)*Ded(iface)*w(post_cont);
                M(inedge(iface,4), esurn1(post_cont))=M(inedge(iface,4),esurn1(post_cont)) -mobility(iface+size(bedge,1))* Kde(iface)*Ded(iface)*w(post_cont);
            end
        end    
    end
end


% 
% %


end

