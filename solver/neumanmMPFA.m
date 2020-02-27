function [ pms ] = neumanmMPFA(A,B, coarseelem , edgesOnCoarseBoundary, fluxMs,pc )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

global refCenterInCoaseElem npar inedge intinterface elemloc coarseelem coarseDiricht edgesCoarseDict 

pms = sparse(size(B,1),1);
%%Adicionar a influência em ambos os lados do fluxo


for index = 1:size(edgesOnCoarseBoundary)
    if index == 16
        1+1;
    end
    
    refEdge = edgesOnCoarseBoundary(index);
    leftElem = inedge(refEdge,3);
    rightElem = inedge(refEdge,4);
%     
%     leftSign = elemloc(leftElem)
%     rightSign = elemloc(rightElem)
%     
    
    %¨PARECE QUEEXISTE ALGUMA DIFERENÇA NO SINAL DO FLUXO DE FERNANDO
    B(leftElem) = B(leftElem) - fluxMs(index);
    B(rightElem) = B(rightElem) -  fluxMs(index); 
    
end

%%Separar em matrizes menores e resolver o sistema
comp = zeros(npar,1);
for index = 1:npar    
    if index == 15
        %1+1
    end

    ag = [];
    
    
    for jj = 1: size(intinterface,2)
       if ~isempty(intinterface{index,jj})
         ag = unique([ag intinterface{index,jj}']);
       end
    end
    size(ag)
    refConv = zeros(size(ag));
    if ~isempty(ag)
        for kk = 1:size(ag,2)
            refConv(kk) = edgesCoarseDict(ag(kk));
        end
    end
    
    
    left = inedge(ag,3);
    right = inedge(ag,4);
    
    %auxmat = [elemloc(left) elemloc(right)];
    sig = double(elemloc(left) == index);
    
    
   
    
    auxelemRef = [inedge(ag,3) inedge(ag,4)];
    
    elemRef = zeros(size(auxelemRef,1),1);
    
    
    
    
    elemRef(logical(sig))= auxelemRef(logical(sig),2);
    elemRef(logical(~sig))= auxelemRef(logical(~sig),1);
    
   % elemloc(elemRef)
    
    sig( sig == 0 ) = -1;
    
    
    %sum((fluxMs(refConv) .* sig))
    
    B(elemRef) = B(elemRef)  + (fluxMs(refConv) .* sig);
    %peqB(refConv) = peqB(refConv) + (fluxMs(refConv) .* sig);
    comp(index) = sum((fluxMs(refConv) .* sig));
   
    
end    



 for index = 1:npar  
     
         
    peqA = A(coarseelem{index},:);
    peqA = peqA(:,coarseelem{index});
    peqB = B(coarseelem{index});
    if sum(coarseDiricht == index) == 0
        
        %impondo dirichlet se os elementos nao estiverem na fronteira ja
        %com valor de dirichlet. problema ja bem posto
        peqA(refCenterInCoaseElem(index),:) = 0;
        peqA(refCenterInCoaseElem(index),refCenterInCoaseElem(index)) = 1;
        
        %somar os fluxos em peqB antes de rodar para testar se esta de fato
        %conservativo, boa maneira de debugar
        
        peqB(refCenterInCoaseElem(index)) = pc(index);
    end
    
    
    peqSol =   peqA\peqB;
    
    if max(peqSol) > 3
        1+1
    end
    
    pms(coarseelem{index}) = peqSol;
end

%%Adicionar as influências das vazoes calculadas

%%Resolver os sistemas menores


%% Devolver a resposta para um mesmo vetor e retornar
pms = [pms]% comp];
end

