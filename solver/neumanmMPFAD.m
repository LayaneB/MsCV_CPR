function [ pms ] = neumanm(A,B, coarseelem , edgesOnCoarseBoundary, fluxMs,pc )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

global refCenterInCoaseElem npar inedge elemloc coarseelem dictionary coarseDiricht

pms = sparse(size(B,1),1);
%%Adicionar a influência em ambos os lados do fluxo



%%Separar em matrizes menores e resolver o sistema

for index = 1:npar    
%     if index == 1
%         1
%     end
    ce=coarseelem{index};
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
        
        peqB(refCenterInCoaseElem(index)) = pc(ce(refCenterInCoaseElem(index)));
    end
    
    
    peqSol =   peqA\peqB;
    
    if max(peqSol) > 1
        1+1;
    end
    
    pms(coarseelem{index}) = peqSol;
end

%%Adicionar as influências das vazoes calculadas

%%Resolver os sistemas menores


%% Devolver a resposta para um mesmo vetor e retornar

end

