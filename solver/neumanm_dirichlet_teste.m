function [ pms ] = neumanm_dirichlet_teste(A,B, coarseelem , edgesOnCoarseBoundary, fluxMs,pc )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

global refCenterInCoaseElem npar inedge bedge elemloc  dictionary coarseDiricht

pms = sparse(size(B,1),1);
%%Adicionar a influência em ambos os lados do fluxo

%%Separar em matrizes menores e resolver o sistema

for index = 1:npar    
%     if index == 1
%         1
%     end
    
    ce=coarseelem{index};
% ################# teste #################
%     cb = 0;
%     j=1;
%     k=1;
%     for i=1:size(ce,2)
% %      a=find(bedge(:,3)==ce(i));
% %      if a ~= 0
% %          cb = [cb ce(i)];
% %      end
%      b=find(inedge(:,3)==ce(i));
%      c=find(inedge(:,4)==ce(i));
%      d=find(inedge(b,4)==ce);e=find(inedge(c,3)==ce);
%      l= isempty(d);m = isempty(e);
%      if l ==1
%          f=0;
%      else
%          f=size(d,1);
%      end
%      if m==1
%          g =0;
%      else
%          g=size(e,1);
%      end
%   
%      if f+g==2
%          cb=[cb ce(i)];
%          j=j+1;
%          h(k)=find(cb(j)==ce);
%          k=k+1;
%      end
%     
%     end
% ########################################## 
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
    
%     for ii = 1:size(h,2)
%         peqA(h(ii),:) = 0;
%         peqA(h(ii),h(ii)) = 1;
%         peqB(h(ii)) = pc(h(ii));
%     end
    
    
    peqSol =   peqA\peqB;
    
    if max(peqSol) > 1
        1+1;
    end
    clear h
    pms(coarseelem{index}) = peqSol;
end

%%Adicionar as influências das vazoes calculadas

%%Resolver os sistemas menores


%% Devolver a resposta para um mesmo vetor e retornar

end