function [ O, P, T, Qo ] = OPT_Interp_LPEWMS(ni,region)
global esurn1 esurn2 coord nsurn1 nsurn2 elem
%Retorna os vetores O, P, T e Qo.
% Lembrando que estes esurn1, nsurn1 já estan ordenados em sentido
% anti-horario, sequencialmente. 

%Pré-alocação dos vetores.%
eOrd = esurnOrd(ni,region);
nOrd = nsurnOrd(ni,region);

P=zeros(size(nOrd,1),3); % vetor de pontos na vizinhança do nó "ni".
T=zeros(size(nOrd,1),3); % vetor de pontos dinamicos na vizinhança do nó "ni".
O=zeros(size(eOrd,1),3); % vetor de baricentro na vizinhança do nó "ni".
Qo=coord(ni,:);                     % coordenada do nó "ni".

%Construção dos vetores P, dos nós vizinhos ao nó "ni", e T, dos pontos%
%médios das fases que concorrem no nó "ni".                            %

for i=1:size(P,1),
    P(i,:) = coord(nOrd(i),:);
    T(i,:)=(P(i,:)+Qo)/2;
end



%Construção do vetor O, dos centróides (pontos de colocação) dos elementos%
%que concorrem no nó ni.                                                  %

for i=1:size(O,1),
    %Verifica se o elemento é um quadrilátero ou um triângulo.
    if elem(eOrd(i),4)==0 % lenbrando que o quarta columna
        b=3;                  
    else
        b=4;  % da matriz de elementos é para quadrilateros
    end
    %Carrega adequadamente o vetor O (baraicentro de cada elemento)
    for j=1:b
        O(i,1)=O(i,1)+(coord(elem(eOrd(i),j),1)/b);
        O(i,2)=O(i,2)+(coord(elem(eOrd(i),j),2)/b);
        O(i,3)=O(i,3)+(coord(elem(eOrd(i),j),3)/b);
    end
end


% 
% tmp = nsurn(ni,3,region);
% 
% P = P(tmp,:);
% T = T(tmp,:);
% O = O(esurn(ni,3,region),:);

%adjusting to element only in the region




end
