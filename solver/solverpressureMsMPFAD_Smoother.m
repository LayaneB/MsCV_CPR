function [pressure,errorelativo,flowrate,flowresult,OP_old,b2,b3,tempo,velocity]=solverpressureMsMPFAD_Smoother(kmap,fonte,...
    mobility,wells,S_old,V,nw,no,N,auxflag,Hesq, Kde, Kn, Kt, Ded,nflag,OP_old,S_cont)
global w s flagboundcoarse
% function [pressure,errorelativo,flowrate,flowresult]=solverpressure(kmap,nflagface,nflagno,fonte,...
%     tol, nit,p_old,mobility,gamma,wells,S_old,V,nw,no,N,parameter,metodoP,...
%     auxflag,interptype,Heseyh v, Kde, Kn, Kt, Ded,weightDMP,auxface,benchmark,iteration,nflag)

% TO DO
% adaptar calculo PRE_LPEW_2M para contar com mobilidade
% adaptar calculo dos fluxos globais e fluxos do inside coarse mesh para
% contar com mobilidade
global pointWeight elem coarseelem  edgesOnCoarseBoundary npar bedge oneNodeEdges flagSuavizador ...
       suavizador MetodoSuavizador Wc Wf
errorelativo=0;

wsdynamic = dynamic(pointWeight);


[w,s]=Pre_LPEW_2T(kmap,mobility,V,S_old,nw,no,N);
mobRegion = mobilityfaceRegion(S_old,nw,no,auxflag,S_cont,mobility);
%assembly da matriz
[ TransF, F] = globalmatrixmpfadn( w,s, Kde, Ded, Kn, Kt, nflag, Hesq,wells,mobility,fonte);
%%MultiScale
%pre condition matrix 
TransFc = TransF; %original
n = size(TransFc,2);
TransFc(1:size(TransFc,2)+1:end) = diag(TransFc) - sum(TransFc,2);
auxflag = 0;
% %OP_old
OR  = genRestrictionOperator(size(elem,1), npar);
if OP_old == -1;
    OP =  genProlongationOperator(OR', TransFc, 2/3,1300);
else
    OP =  genProlongationOperator(OP_old, TransFc, 2/3,300); 
end

OP_old = OP;
% 
% %% wells treatment
if size(wells,2) > 1
    ref = wells(:,5) > 400;
    %% %testes
     OP(wells(find(ref),1),:) = 0 ;
end
 %% Precondicionador para resolver o sistema A*x=b
% r = symrcm(TransF);
% TransF = TransF(r,r);
% A = M\TransF; b =M\F;
% A = M*TransF; b =M*F;
% A = TransF; b = F;
ac = OR * TransF * OP; 
bc = OR * F; 
%% Solu��o multiescala
pc = ac\bc;
pd = OP*pc;
%% Suavizador
tinic = tic;
if strcmp(flagSuavizador, 'on')
    if strcmp(suavizador, 'SOR')
%         L = tril(TransF, -1);
        U = triu(TransF,  1);
        D = diag(diag(TransF));
        S = (D+Wf*U);
%         M = (D+Wf*L);

        if strcmp(MetodoSuavizador, 'S_MN')
            
            L1 = tril(ac, -1) ;
            U1 = triu(ac,  1) ;
            D1 = diag(diag(ac)); 
            Sc = (D1+Wc*L1); % Suavizador na escala coarse
            Sf = S; % Suavizador na escala fina
        end
        
    elseif strcmp(suavizador, 'ILU')
%         [L,U] = ilu(TransF);
        [L,U] = ilu(TransF,struct('type','ilutp','droptol',1e-5));
        S = L*U;
%         [L,U] = ilu(A,struct('type','ilutp','droptol',1e-6)); % fun��o do pr�prio Matlab
   
        if strcmp(MetodoSuavizador, 'S_MN')
            [l,u] = ilu(ac,struct('type','ilutp','droptol',1e-5));
            Sc = l*u; % Suavizador na escala coarse
            Sf = S; % Suavizador na escala fina
        end
    elseif strcmp(suavizador, 'GS')
         L = tril(TransF, -1);
%          U = triu(TransF,  1);
         D = diag(diag(TransF));
         S = (D+L);
         if strcmp(MetodoSuavizador, 'S_MN')
%             Lc = tril(ac, -1);
            Uc = triu(ac,  1);
            Dc = diag(diag(ac));
            Sc = (Dc+Uc);            
            Sf = S; % Suavizador na escala fina
         end
         
    end
%% Testar esses depois
% [pc,fl1,rr1,it1,rv1]=bicgstab(ac,bc,1e-10,1000,S); % fun��o do pr�prio Matlab
% [pc,fl1,rr1,it1,rv1]=gmres(ac,bc,10,1e-9,50,S1); % fun��o do pr�prio matlab
%%
if size(wells,2) > 1
  pd(wells(ref,1)) = wells(ref,end);
end
%% Etapa iterativa

pf = pd; % Entrada da etapa iterativa 
rf = F - TransF * pf; 
tol = 10^-7; v=0;
erro=10^7;
% while max(abs(rf)) > tol
while v < 15
    
    if strcmp(MetodoSuavizador, 'S_Multiescala')
    %--------Etapa multiescala------------
        rc = OR * rf;
        dpc = ac\rc;
        dpf = OP * dpc; 
        pff = pf + dpf;
        rff = F - TransF * pff;
        dpf2 = bicgstabl(TransF,rff,10^-5, 400, S);
%         dpf2 =gmres(TransF,rff,10,10^-5, 200, S);
    %---------Etapa de Suaviza��o---------
        pf = pff + dpf2;
    elseif strcmp(MetodoSuavizador, 'S_MN')
        dpf = bicgstabl(TransF,rf,10^-5, 100, Sf);
        pf3 = pf + dpf;
        rf2 = F - TransF*pf3; rc = OR*rf2;
        dpc = bicgstabl(ac,rc,10^-5, 100, Sc);
        pf2 = pf3 + OP*dpc;
        rf3 = F - TransF*pf2;
        dpf2 = bicgstabl(TransF,rf3,10^-5, 100, Sf);
        pf = pf2 + dpf2;
        
%        pf3 = pf + Sf\(F - TransF*pf);
%        pf2 = pf3 + OP*(Sc\OR)*(F - TransF*pf3); 
%        pf = pf2 + Sf\(F - TransF*pf2);
    elseif strcmp(MetodoSuavizador, 'Olav')
% %--------------Olav--------------     
%--------Etapa multiescala------------
        rc = OR * rf;
        dp = bicgstabl(TransF,rf,10^-5, 200, S);
        rcs = OR*TransF*dp;
        dpc = ac\(rc-rcs);
        dpf = OP * dpc; 
        pff = pf + dpf;
%         rff = F - TransF * pff;
%         dpf2 = bicgstabl(TransF,rff,10^-5, 200, S);
%---------Etapa de Suaviza��o---------
        pf = pff + dp;
%        yrf = S\rf;
%        pf = pf + (OP*(ac\OR))*(rf-TransF*yrf)+yrf;
       
    elseif strcmp(MetodoSuavizador, 'S_R')
        dpf = bicgstabl(TransF,rf,10^-5, 200, S);
        pf = pf + dpf;
    
    end
  
    rf = F - TransF * pf; 
    
    v=v+1;
%     if abs(rf) <= tol 
%     if v == 30
%     erro = sqrt(sum((rf).^2));
%     if erro <= tol 
%        break 
%     end
%   pref = load('REF_P');  
% Linf(v) = max(abs(pref.REF_P-pf))/max(abs(pref.REF_P)); L1(v) = sum(abs(pref.REF_P-pf))/sum(abs(pref.REF_P)); L2(v) = sqrt(sum((pref.REF_P-pf).^2))/sqrt(sum((pref.REF_P).^2));
 
end

    tempo = toc(tinic);
    pd = pf;

end
tempo = toc; v=1;

%% Calculates the flow on the Edges of the Coarse Boundary
%flowPd = flowrateMsMPFAD(edgesOnCoarseBoundary,pd,w,s,Kde,Ded,Kn,Kt,Hesq,nflagno,auxflag);
[flowPd, flowresultPd,velocityPd]=calflowrateMPFADn(pd,w,s,Kde,Ded,Kn,Kt,Hesq,nflag,auxflag,mobility);
flowPd2 = flowPd( edgesOnCoarseBoundary + size(bedge,1));
%[flowPd3, flowresultPd3,velocityPd3]=flowrateMPFAD(p,w,s,Kde,Ded,Kn,Kt,Hesq,nflagno,auxflag);
poq = pd;
iterativeRoutine
%% Neuman
%recalculating weights
%tests replacing flowPd by velocityPd
%alterar velocityPd


[wsdynamic] = Pre_LPEW_2MS(kmap, wsdynamic,velocityPd,mobRegion,S_old,nw,no);    


%excluding influence of edges and nodes that connect different coarse regions
[TransFn, Fn] = minusMPFAD(TransF,F, edgesOnCoarseBoundary, w,s, Kde, Ded, Kn, Kt, nflag, Hesq,mobility);
%debugUncoupling %tests TransFn to check if the uncoupling is done alright
%adding the influence back with weights that consider only the coarse
%volumes inside
%alterar flowPd2
[TransFn, Fn] = addMPFAD(TransFn,Fn, edgesOnCoarseBoundary, oneNodeEdges,flowPd2,wsdynamic,Kde, Ded, Kn, Kt, nflag, Hesq ,mobRegion ); % VERIFICAR DEPOIS!!!!
%debugUncoupling

% flowPd(abs(flowPd) < 0.00000001) = 0;
pp =  neumanmMPFAD(TransFn,Fn, coarseelem , edgesOnCoarseBoundary, flowPd,pd );
[flowPp, flowresult,velocity]=flowratePPMPFAD(pp,w,s,wsdynamic, Kde,Ded,Kn,Kt,Hesq,nflag,auxflag,mobility,mobRegion);
% erro = max(abs(pd-pp)./max(pd))
% pause(1.5)

%superFolder = 'C:\Users\admin\Google Drive\Programa��o\FV-MsRB\';
%postprocessorName(full(pd),full(pp),superFolder, 'PP-Teste');

flowPms = compoundFlow( flowPp,flowPd2, size(bedge,1) );
%flowPms(abs(flowPms) < 0.00000001) = 0;


%postMPFA
flowrate = flowPms;
pressure = pd;

% p = TransF\F;
% [flowPn, flowresultPn,velocityPn]=calflowrateMPFAD(p,w,s,Kde,Ded,Kn,Kt,Hesq,nflag,auxflag,mobility);
%flowrate = flowPn;
%pressure = p;
% flowresult = flowresultPn;
% ooo = find(abs(flowresultPn) > 0.0000001);
flowresult = fluxSummation(flowPms);
consTestMpfa
% 1+1;
%pause
%%

% % incializando variaveis
% % 
% % flowrate=0;
% % flowresult=0;
% 
% pressure=TransF\F;
% 
% [flowrate,flowresult]=calflowrateMPFAD(pressure,w,s,Kde,Ded,Kn,Kt,Hesq,nflag,auxflag,mobility);
% 
% 
% residuo=0;
% niteracoes=0;

%apenas para metodos iterativos
% switch metodoP
%     
%     case {'nlfvLPEW', 'nlfvDMPSY','nlfvDMPV1'}
%         
%         if strcmp(iteration,'iterpicard')
%             
%             [pressure,step,errorelativo,flowrate,flowresult]=iterpicard(M_old,RHS_old,nit,tol,kmap,...
%                 parameter,metodoP,auxflag,w,s,nflagface,fonte,p_old,gamma,...
%                 nflagno,benchmark,weightDMP,auxface,wells,mobility,Hesq, Kde, Kn, Kt, Ded);
%             
%             
%         elseif strcmp(iteration,'iterbroyden')
%             
%             p_old1=M_old\RHS_old;
%             
%             % interpola��o nas faces
%             [pinterp1]=pressureinterp(p_old1,nflagface,w,s,auxflag,metodoP,parameter,weightDMP,mobility);
%             
%             % calculo da matriz globlal inicial
%             [M_old1,RHS_old1]=globalmatrix(p_old1,pinterp1,gamma,nflagface,nflagno,...
%                 parameter,kmap,fonte,metodoP,w,s,benchmark,weightDMP,auxface,wells,mobility,Hesq, Kde, Kn, Kt, Ded);
%             
%             % residuo inicial
%             R0_old=M_old1*p_old1-RHS_old1;
%             
%             % solver de press�o pelo m�todo Broyden
%             [pressure,step,errorelativo,flowrate,flowresult]=iterbroyden(M_old,RHS_old,p_old,tol,kmap,parameter,...
%                 metodoP,auxflag,w,s,nflagface,fonte,gamma,nflagno,benchmark,R0_old,p_old1,...
%                 weightDMP,auxface,wells,mobility,Hesq, Kde, Kn, Kt, Ded);
%             
%             
%         elseif strcmp(iteration, 'iterdiscretnewton')
%             
%             p_old1=M_old\RHS_old;
%             % interpola��o nos n�s ou faces
%             [pinterp1]=pressureinterp(p_old1,nflagface,w,s,auxflag,metodoP,parameter,weightDMP,mobility);
%             
%             % calculo da matriz globlal inicial
%             [M_old1,RHS_old1]=globalmatrix(p_old1,pinterp1,gamma,nflagface,nflagno,...
%                 parameter,kmap,fonte,metodoP,w,s,benchmark,weightDMP,auxface,wells,mobility,Hesq, Kde, Kn, Kt, Ded);
%             
%             % resolvedor de press�o pelo m�todo de Newton-Discreto
%             [pressure,step,errorelativo,flowrate,flowresult]=iterdiscretnewton(M_old,RHS_old,tol,kmap,...
%                 parameter,metodoP,auxflag,w,s,nflagface,fonte,p_old,gamma,...
%                 nflagno,benchmark,M_old1,RHS_old1,p_old1,weightDMP,auxface,wells,mobility,Hesq, Kde, Kn, Kt, Ded);
%             
%             
%         elseif strcmp(iteration, 'iterhybrid')
%             
%             p_old1=M_old\RHS_old;
%             
%             % interpola��o nos n�s ou faces
%             [pinterp1]=pressureinterp(p_old1,nflagface,w,s,auxflag,metodoP,parameter,weightDMP,mobility);
%             
%             % calculo da matriz globlal inicial
%             [M_old1,RHS_old1]=globalmatrix(p_old1,pinterp1,gamma,nflagface,nflagno,...
%                 parameter,kmap,fonte,metodoP,w,s,benchmark,weightDMP,auxface,wells,mobility,Hesq, Kde, Kn, Kt, Ded);
%             
%             % solver pressure pelo m�todo hybrido
%             [pressure,step,errorelativo,flowrate,flowresult]=iterhybrid(M_old1,RHS_old1,tol,kmap,...
%                 parameter,metodoP,auxflag,w,s,nflagface,fonte,p_old,gamma,...
%                 nflagno,benchmark,p_old1,weightDMP,auxface,wells,mobility,Hesq, Kde, Kn, Kt, Ded);
%             
%         elseif strcmp(iteration, 'JFNK')
%             
%             
%             p_old1=M_old\RHS_old;
%             % calculo do residuo
%             R0=M_old*p_old-RHS_old;
%             
%             % interpola��o nos n�s ou faces
%             [pinterp1]=pressureinterp(p_old1,nflagface,nflagno,w,s,auxflag,metodoP,parameter,weightDMP,mobility);
%             
%             % calculo da matriz globlal inicial
%             [M_old1,RHS_old1]=globalmatrix(p_old1,pinterp1,gamma,nflagface,nflagno,...
%                 parameter,kmap,fonte,metodoP,w,s,benchmark,weightDMP,auxface,wells,mobility,Hesq, Kde, Kn, Kt, Ded);
%             
%             % calculo da press�o
%             [pressure,step,errorelativo,flowrate,flowresult]= JFNK1(tol,kmap,parameter,metodoP,auxflag,w,s,nflagface,fonte,gamma,...
%                 nflagno,benchmark,M_old1,RHS_old1,p_old1,R0,weightDMP,auxface,wells,mobility,Hesq, Kde, Kn, Kt, Ded);
%             
%         end
%         
%     case {'lfvHP','lfvLPEW','mpfad','tpfa'}
%         
%         pressure=M_old\RHS_old;
%         if strcmp(metodoP, 'lfvHP')
%             % interpola��o nos n�s ou faces
%             [pinterp]=pressureinterp(pressure,nflagface,nflagno,w,s,auxflag,metodoP,parameter,weightDMP,mobility);
%             % calculo das vaz�es
%             [flowrate,flowresult]=flowratelfvHP(parameter,weightDMP,mobility,pinterp,pressure);
%         elseif strcmp(metodoP, 'lfvLPEW')
%             [pinterp]=pressureinterp(pressure,nflagface,nflagno,w,s,auxflag,metodoP,parameter,weightDMP,mobility);
%             % calculo das vaz�es
%             [flowrate,flowresult]=flowratelfvLPEW(parameter,weightDMP,mobility,pinterp,pressure);
%         elseif  strcmp(metodoP, 'tpfa')
%             [flowrate, flowresult]=flowrateTPFA(pressure,Kde,Kn,Hesq,nflag,mobility);
%         else
%             % calculo das vaz�es
%             [flowrate,flowresult]=calflowrateMPFAD(pressure,w,s,Kde,Ded,Kn,Kt,Hesq,nflag,auxflag,mobility);
%         end
%         residuo=0;
%         niteracoes=0;
%         
%         name = metodoP;
%         X = sprintf('Calculo da press�o pelo m�todo: %s ',name);
%         disp(X)
%         
%         x=['Residuo:',num2str(residuo)];
%         disp(x);
%         y=['N�mero de itera��es:',num2str(niteracoes)];
%         disp(y);
%         
% end

end