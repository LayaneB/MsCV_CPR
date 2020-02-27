function [wsdynamic] = Pre_LPEW_2MS(kmap, wsdynamic,flux,mobility,S_old,nw,no)
%Pre_LPEW_2T(kmap,mobility,V,S_old,nw,no,N)
global coord bcflag bedge inedge npar pointWeight Nregion w s esurn2 ...
       flagboundcoarse centelem elemloc normals
% devolve os pesos "w" cujos elementos são organizados em um vetor
%Retorna todos os parâmetros necessários às expressões dos fluxos.
%apw=ones(size(coord,1),1);
%r=zeros(size(coord,1),2);

%FLUX MUST BE THE WHOLE FLUX SIZE AND NOT ONLY FLUX ON EDGES ON COARSE
%BOUNDARY
%mobility(:,:) = 1;
for region = 1: npar

listPoint = pointWeight{region};
apw=ones(size(coord,1),1);
r=zeros(size(coord,1),2);
    
    for tt=1:size(listPoint,1)
        No = listPoint(tt);
        if flagboundcoarse(No)==1
            % calcula
            % O--> coordenadas do baricentro na vizinhança do nó "No"
            % P--> coordenadas dos vértices na vizinhança do nó "No"
            % T--> coordenadas dos pontos medios nas vizinhas ao nó "No"
            % Qo-> coordenada do nó em questão
            %tranquilo

            [ O, P, T, Qo ] = OPT_Interp_LPEWMS(No,region);

            % calcula os angulos apropiados para calculas os pesos

            [ ve2, ve1, theta2, theta1 ] = angulos_Interp_LPEW2MS( O, P, T, Qo,No,region );
            % calculas as netas uma relação de de alturas

            [ neta ] = netas_Interp_LPEWMS( O, P, T, Qo, No,region );
            % calculas as projeções normais em torno do nó "No"
            %deletou informacao
            %[ Kt1, Kt2, Kn1, Kn2 ] = Ks_Interp_LPEW2MS( O, T, Qo, kmap, No,region);
             [ Kt1, Kt2, Kn1, Kn2 ] = Ks_Interp_LPEW2MS( O, T, Qo, kmap, No,region,mobility(:,region),S_old,nw,no);
            % calcula os lambdas
            [ lambda,r ] =  Lamdas_Weights_LPEW2MS( Kt1, Kt2, Kn1, Kn2, theta1,...
                theta2, ve1, ve2, neta, P, O,Qo,No,T,r );

    %         for k=0:size(O,1)-1,
    %             
    %             w(apw(No)+k)=lambda(k+1)/sum(lambda); %Os pesos fazem sentido
    %         end
    %         

            for k = 1:size(O,1)
                tpp = lambda(k)/sum(lambda);
                wsdynamic.setW(No,region,k,tpp);

            end
            %Wregion = cell array
            %INPUT: node
            %OUTPUT: weights around node

            %Sregion = cell array
            %INPUT: node
            %OUTPUT: weights around node

            %apk eh contador 


            %melhorar isso aqui
            %TA UMA BOSTA!!!!!!!!!!!!
            %pensar numa funcao para alocar os fluxos como condicao de contorno
            % apw(No+1)=apw(No)+size(O,1);
            % calculando os pesos relativos a condição de contorno de Neumann


            %edges around node No, use Nregion

            vetor = nsurnOrd(No,region);
            %vetor=nsurn1(nsurn2(No)+1:nsurn2(No+1));

            %comp1 = first face
            %comp2 = lastt face
            %comp1=N(No,1);
            %comp2=N(No,length(vetor));

            comp1 = Nregion(No,1,region);
            comp2 = Nregion(No,length(vetor),region);

            %comp 1 ou comp2 are bedges?
            class1 = comp1 > size(inedge,1);
            class2 = comp2 > size(inedge,1);

    %      both edges are bedges


            if class1 == true && class2 == true
                %neuman na face comp1
                a=bcflag(:,1)==bedge(comp1-size(inedge,1),5);
                s1=find(a==1);
                %neuman na face comp2

                b=bcflag(:,1)==bedge(comp2-size(inedge,1),5);
                s2=find(b==1);
                %ver equacao 2.26 do artigo do gau
                tpp = -(1/sum(lambda))*(r(No,1)*bcflag(s1,2)+r(No,2)*bcflag(s2,2));
    %            s(No,1)=-(1/sum(lambda))*(r(No,1)*bcflag(s1,2)+r(No,2)*bcflag(s2,2));
                wsdynamic.setS(No,region,tpp);

            %both edges are inedge
            elseif class1 == false && class2 == false

               edgesFlux = -[ flux(comp1 + size( bedge,1)); flux(comp2+ size( bedge,1))];     

              if region==elemloc(inedge(comp1,3))
                  edgesFlux(1) = - edgesFlux(1);  
               end
               if region==elemloc(inedge(comp2,3))
                  edgesFlux(2) = - edgesFlux(2);  
               end
                            

               %s(No,1)=-(1/sum(lambda))*(r(No,1)*bcflag(s1,2)+r(No,2)*bcflag(s2,2));
               tpp = -(1/sum(lambda))*(r(No,1)*edgesFlux(1)+r(No,2)*edgesFlux(2));
               wsdynamic.setS(No,region,tpp);


            %one bedge, one inedge
            elseif class1 == true && class2 == false

                edgesFlux = -[ flux(comp2 + size( bedge,1))];
                
               
               if region==elemloc(inedge(comp2,3))
                  edgesFlux = - edgesFlux;  
               end


                b=bcflag(:,1)==bedge(comp1-size(inedge,1),5);
                s1=find(b==1);

               % s(No,1)=-(1/sum(lambda))*(r(No,1)*bcflag(s1,2)+r(No,2)*bcflag(s2,2));

                tpp = -(1/sum(lambda))*(r(No,1)*bcflag(s1,2)+r(No,2)*edgesFlux );
                wsdynamic.setS(No,region,tpp);

                %first edge inedge
                %second edge type
            elseif class1 == false && class2 == true
                % parte do codigo tem a referencia como inedge + bedge
                % essa parte abaixo eh o contrario, bedge inedge

                %verificar sempre aqui
                %referencia trocada nesta merda
                edgesFlux = -[ flux(comp1 + size( bedge,1))];

                if region==elemloc(inedge(comp1,3))
                  edgesFlux = - edgesFlux;  
                end
               

                a=bcflag(:,1)==bedge(comp2-size(inedge,1),5);
                s2=find(a==1);
               %s(No,1)=-(1/sum(lambda))*(r(No,1)*bcflag(s1,2)+r(No,2)*bcflag(s2,2));
                tpp = -(1/sum(lambda))*(r(No,1)*edgesFlux+r(No,2)*bcflag(s2,2));
                wsdynamic.setS(No,region,tpp);


            end
            
        else
            
            for k=1:(esurn2(No+1)-esurn2(No))
                post_cont = esurn2(No)+k;
                tpp = w(post_cont);
                wsdynamic.setW(No,region,k,tpp);
            end
            
            bno1 = find(bedge(:,1)==No);
            bno2 = find(bedge(:,2)==No);
            if isempty(bno1)==0 || isempty(bno2)==0
                tpp = s(No);
                wsdynamic.setS(No,region,tpp);
            end
            
        end
    end
    
end


end

