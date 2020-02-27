function [p,step,errorelativo,flowrate,flowresult,M_old, RHS_old]=iterpicardmsnl2(M_old,RHS_old,...
    nitpicard,tolpicard,parameter,metodoP,w,s,fonte,p_old,nflagno,mobility)
global superFolder kmap
%% calculo do residuo Inicial
%R0=norm(M_old*p_old-RHS_old);
global pointWeight elem coarseelem  edgesOnCoarseBoundary npar bedge oneNodeEdges wells coarseElemCenter
errorelativo=0;

%[w,s]=Pre_LPEW_2T(kmap,mobility,V,S_old,nw,no,N);
%mobRegion = mobilityfaceRegion(S_old,nw,no,auxflag,S_cont,mobility);
%wsdynamic = dynamic(pointWeight);
OR  = genRestrictionOperator(size(elem,1), npar);
OR_old  = OR;
%[TransFc,RHS_old] = precond(M_old,RHS_old);
%OP_old =  genProlongationOperator(OR',  TransFc, 2/3,10200);
OP_old =  genProlongationOperator(OR',  M_old, 2/3,10000);

if size(wells,2) > 1
        ref = wells(:,5) > 400;
        %% %testes
%          OP_old(wells(find(ref),1),:) = 0 ;
%          OR(:,wells(find(ref),1)) = 0 ;
end
%ac = OR * TransFc * OP_old;
ac = OR * M_old* OP_old;
bc = OR * RHS_old;
   


% R0 = norm(ac*pc- bc);



auxflag = 0;
%% 
%% inicializando dados para itera��o Picard
step=0;
er=1;




while (tolpicard<er || tolpicard==er) && (step<nitpicard)
    %% atualiza itera��es
    step=step+1
    %% calculo da press�o utilizando o precondicionador
    %pre condition matrix
    pc = ac\bc;
    p_new = OP_old*pc;
%     if size(wells,2) > 1
%         p_new(wells(ref,1)) = wells(ref,end);
%     end
%    [cond(TransFc) cond(M_old)]
    %p_new=M_old\RHS_old;  % invers�o sem pivotamento
    %postprocessorTMS(full(p_new),full(p_new),step,superFolder,'Picard');
    %% plotagem no visit
    S=ones(size(p_new,1),1);
    %postprocessor(p_new,S,step)
    
    %% Calculo da matriz global
    % interpola��o nos n�s ou faces
    [pinterp_new]=pressureinterp(p_new,nflagno,w,s);
    [M_new,RHS_new]=assemblematrixGYZS(pinterp_new,parameter,fonte,mobility);
    
   % [TransFcn,RHS_old] = precond(M_new,RHS_new);
%    OP_new=  genProlongationOperator(OR_old',  TransFcn, 2/3,1200);
    %OP_new=  genProlongationOperator(OR_old',  M_new, 2/3,10200);
    OP_new=  genProlongationOperator(OP_old,  M_new, 2/3,2000);

    
    if size(wells,2) > 1
        ref = wells(:,5) > 400;
        %% %testes
%         OP_new(wells(find(ref),1),:) = 0 ;
    end  
%    ac = OR * TransFcn * OP_new;
    ac = OR * M_old* OP_old;
    bc = OR * RHS_old;
    pcn = ac\bc;
    p_new = OP_new*pcn;
    %
%     if size(wells,2) > 1
%         p_new(wells(ref,1)) = wells(ref,end);
%     end
    %% Calculo do residuo multiescala
%     R1 = norm(ac*pc- bc)
%     if (R0 ~= 0.0)
%         er = abs(R1/R0)
%     else
%         er = 0.0; %exact
%     end
%     errorelativo(step)=er;
    
    % calculo do erro
    
    %Rm = norm(full(TransFcn*OP_old))
    
    %R =  norm(full(M_new - M_old))
    R = max(max(abs(M_new-M_old)))
    R2 = max(max(abs(RHS_new-RHS_old)))
    %R = norm(M_new*p_new - RHS_new)
    
%     if (R0 ~= 0.0)
%         er = abs(R/R0)
%     else
%         er = 0.0; %exact
%     end
    er = abs(R)
    errorelativo(step)=er;
    
    %% atualizar
    
   
    M_old=M_new;
    OP_old = OP_new;
    RHS_old=RHS_new;
%     TransFc = TransFcn;
end
p=p_new;




[pinterp]=pressureinterp(p,nflagno,w,s);

[flowrate,flowresult]=flowrateNLFV(p, pinterp, parameter,mobility);

residuo=er;
niteracoes=step;

name = metodoP;
X = sprintf('Calculo o campo de press�o pelo m�todo: %s ',name);
disp(X)

x=['Erro:',num2str(residuo)];
disp(x);
y=['Numero de iteracoes:',num2str(niteracoes)];
disp(y);

end