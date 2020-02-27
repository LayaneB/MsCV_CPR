function [ w,s] = Pre_LPEW_2(kmap,N)
global coord bcflag bedge nsurn1 nsurn2 inedge 
% devolve os pesos "w" cujos elementos são organizados em um vetor
%Retorna todos os parâmetros necessários às expressões dos fluxos.
apw=ones(size(coord,1),1);
r=zeros(size(coord,1),2);
for No=1:size(coord,1)
    % calcula
    % O--> coordenadas do baricentro na vizinhança do nó "No"
    % P--> coordenadas dos vértices na vizinhança do nó "No"
    % T--> coordenadas dos pontos medios nas vizinhas ao nó "No"
    % Qo-> coordenada do nó em questão
    %tranquilo
	[ O, P, T, Qo ] = OPT_Interp_LPEW(No);
    % calcula os angulos apropiados para calculas os pesos
    
    [ ve2, ve1, theta2, theta1 ] = angulos_Interp_LPEW2( O, P, T, Qo,No );
    % calculas as netas uma relação de de alturas
    
    [ neta ] = netas_Interp_LPEW( O, P, T, Qo, No );
    % calculas as projeções normais em torno do nó "No"
    %deletou informacao
    %reintroduzir mobilidade nessa linha
    [ Kt1, Kt2, Kn1, Kn2 ] = Ks_Interp_LPEW2( O, T, Qo, kmap, No);
    % calcula os lambdas
    [ lambda,r ] =  Lamdas_Weights_LPEW2( Kt1, Kt2, Kn1, Kn2, theta1,...
        theta2, ve1, ve2, neta, P, O,Qo,No,T,r );
    for k=0:size(O,1)-1,
        w(apw(No)+k)=lambda(k+1)/sum(lambda); %Os pesos fazem sentido
    end
    apw(No+1)=apw(No)+size(O,1);
    % calculando os pesos relativos a condição de contorno de Neumann
    
    vetor=nsurn1(nsurn2(No)+1:nsurn2(No+1));
    comp1=N(No,1);
    comp2=N(No,length(vetor));
    if comp1>size(inedge,1) && comp2>size(inedge,1)
        a=bcflag(:,1)==bedge(comp1-size(inedge,1),5);
        s1=find(a==1);
        b=bcflag(:,1)==bedge(comp2-size(inedge,1),5);
        s2=find(b==1);
        
        s(No,1)=-(1/sum(lambda))*(r(No,1)*bcflag(s1,2)+r(No,2)*bcflag(s2,2));
    end
    
end
end

