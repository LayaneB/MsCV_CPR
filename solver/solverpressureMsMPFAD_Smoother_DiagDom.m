 function [pressure,errorelativo,flowrate,flowresult,OP_old,b2,b3]=solverpressureMsMPFAD_Smoother_DiagDom(kmap,fonte,...
    mobility,wells,S_old,V,nw,no,N,auxflag,Hesq, Kde, Kn, Kt, Ded,nflag,OP_old,S_cont)
global w s
% function [pressure,errorelativo,flowrate,flowresult]=solverpressure(kmap,nflagface,nflagno,fonte,...
%     tol, nit,p_old,mobility,gamma,wells,S_old,V,nw,no,N,parameter,metodoP,...
%     auxflag,interptype,Heseyh v, Kde, Kn, Kt, Ded,weightDMP,auxface,benchmark,iteration,nflag)

% TO DO
% adaptar calculo PRE_LPEW_2M para contar com mobilidade
% adaptar calculo dos fluxos globais e fluxos do inside coarse mesh para
% contar com mobilidade
global pointWeight elem coarseelem  edgesOnCoarseBoundary npar bedge oneNodeEdges
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
%% Teste
e = ones(size(TransF,2),1);
r = TransF\e;
P = ones(size(TransF));
P(2:end,1) = r(2:end);
Q = diag(r);
A = P*TransF*Q; b = P*F;

%Testando pra TransF
L = tril(A, -1) ;%+ diag(diag(TransF));
U = triu(A,  1) ;%+ diag(diag(TransF));
D = diag(diag(A)); W=1;
% M = L*U;
% A = (D+W*L)/W + (W*U+(W-1)*D)/W;
M = W*(D+W*L); % I = eye(size(TransF));
% M = inv(L*U);
% M = inv(TransF);
% M = ilu(TransF);


% % % pra ac
% ac1 = OR * A * OP;
% L1 = tril(ac1, -1) ;%+ diag(diag(TransF));
% U1 = triu(ac1,  1) ;%+ diag(diag(TransF));
% D1 = diag(diag(ac1)); W=2/3;
% A1 = (D1+W*L1)/W + (W*U1+(W-1)*D1)/W;
% S1 = W*(D1+W*L1);
%%

% A = M\TransF; b = M\F; % precondicionador
% ac = OR * A * OP; 
% bc = OR * b;
% pc = ac\bc;
% pd = OP*pc; % solução da malha grossa
 %% Precondicionador para resolver o sistema A*x=b
A = M\A; b =M\b;
%  A = M*TransF; b =M*F;
% A = TransF; b = F;



ac = OR * A * OP; 
qc = OR * Q * OP;
% L = OR * L * OP;
% U = OR * U * OP; 
% S1 = OR * S * OP;
bc = OR * b;  

% % Multigrid de 2 nives 
% ac1 = OR * A * OP;
% L1 = tril(ac1, -1) ;%+ diag(diag(TransF));
% U1 = triu(ac1,  1) ;%+ diag(diag(TransF));
% D1 = diag(diag(ac1)); W=2/3;
% A1 = (D1+W*L1)/W + (W*U1+(W-1)*D1)/W;
% S = W*(D1+W*L1);

% L2 = tril(A, -1) ;%+ diag(diag(TransF));
% U2 = triu(A,  1) ;%+ diag(diag(TransF));
% D2 = diag(diag(TransF)); W=1;
% % A = (D+W*L)/W + (W*U+(W-1)*D)/W;
% M2 = W*(D2+W*L2); % I = eye(size(TransF));


% [pc,fl1,rr1,it1,rv1]=bicgstab(ac,bc,1e-10,1000,S); % função do próprio Matlab
% [pc,fl1,rr1,it1,rv1]=gmres(ac,bc,10,1e-9,50,S1); % função do próprio matlab
% pd = OP*pc;

% % pra ac
% 
%   ac = OR * TransF * OP; 
%   bc = OR * F;
yc = ac\bc;
pc = qc*yc;
pd = OP*pc;
%%
if size(wells,2) > 1
  pd(wells(ref,1)) = wells(ref,end);
end


pf = pd; 
% M = ilu(TransF); % usada no ILU(0)
rf = b - A * pf;
tol = 10^-7;
v=0;
while max(abs(rf)) > tol
%--------Etapa multiescala------------
    rc = OR * rf;
%     disp('corse resíduo')
%     max(abs(rc))
    dpc = ac\rc;
    dpf = OP * dpc; 
    pff = pf + dpf;
    rff = b - A * pff;

    % suavizador
%------------ sor ---------------------
%       dn = 0.1*sor(TransF,pf, zeros(size(rf)), 0 ,3000, 10^-8);
%       pf = pf + dn;
%     dd = F - TransF*pn;
%     pf = pn + M*dd;
%     pf = pn - dd;
%------------ ILU(0)-----------------
    pf = pff + M\rff*W;
%     pf = pff + A\rff; %sugestão de Paulo
%     pf = sor(TransF,pf, F, 2/3,100, 10^-8); %testar pra tensor cheio e hetero
%----------------Jacobi---------------
%     DiagT=diag(diag(TransF));
%     RT=TransF-DiagT;
%     pf = DiagT\(rff-RT*pff);
%--------Não considera a etapa multiescala --------
%     
%     pf = pf + A\rf;
%     pf = pff + M\rff;
   
% %--------------Olav--------------    
%     yrf = TransF\rf;
%     pf = pf + (OP*(ac\OR))*(rf-TransF*yrf)+yrf;
%-------------Maliska---------------

%     pf = (I-M*A)*pf + (I-(I-M*A))\(A*F);

%    pf3 = pf + M2\(b - A*pf);
%    pf2 = pf3 + OP*(S\OR)*(b - A*pf3); 
%    pf = pf2 + M2\(b - A*pf2);

    rf = b - A * pf;
%    
    max(abs(rf))
    v=v+1;
    if v == 70
       break 
    end
end
pd = pf;
TransF = A;
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
[TransFn, Fn] = addMPFAD(TransFn,Fn, edgesOnCoarseBoundary, oneNodeEdges,flowPd2,wsdynamic,Kde, Ded, Kn, Kt, nflag, Hesq ,mobRegion );
%debugUncoupling

% flowPd(abs(flowPd) < 0.00000001) = 0;
pp =  neumanmMPFAD(TransFn,Fn, coarseelem , edgesOnCoarseBoundary, flowPd,pc );
[flowPp, flowresult,velocity]=flowratePPMPFAD(pp,w,s,wsdynamic, Kde,Ded,Kn,Kt,Hesq,nflag,auxflag,mobility,mobRegion);

%superFolder = 'C:\Users\admin\Google Drive\Programaï¿½ï¿½o\FV-MsRB\';
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
%             % interpolaï¿½ï¿½o nas faces
%             [pinterp1]=pressureinterp(p_old1,nflagface,w,s,auxflag,metodoP,parameter,weightDMP,mobility);
%             
%             % calculo da matriz globlal inicial
%             [M_old1,RHS_old1]=globalmatrix(p_old1,pinterp1,gamma,nflagface,nflagno,...
%                 parameter,kmap,fonte,metodoP,w,s,benchmark,weightDMP,auxface,wells,mobility,Hesq, Kde, Kn, Kt, Ded);
%             
%             % residuo inicial
%             R0_old=M_old1*p_old1-RHS_old1;
%             
%             % solver de pressï¿½o pelo mï¿½todo Broyden
%             [pressure,step,errorelativo,flowrate,flowresult]=iterbroyden(M_old,RHS_old,p_old,tol,kmap,parameter,...
%                 metodoP,auxflag,w,s,nflagface,fonte,gamma,nflagno,benchmark,R0_old,p_old1,...
%                 weightDMP,auxface,wells,mobility,Hesq, Kde, Kn, Kt, Ded);
%             
%             
%         elseif strcmp(iteration, 'iterdiscretnewton')
%             
%             p_old1=M_old\RHS_old;
%             % interpolaï¿½ï¿½o nos nï¿½s ou faces
%             [pinterp1]=pressureinterp(p_old1,nflagface,w,s,auxflag,metodoP,parameter,weightDMP,mobility);
%             
%             % calculo da matriz globlal inicial
%             [M_old1,RHS_old1]=globalmatrix(p_old1,pinterp1,gamma,nflagface,nflagno,...
%                 parameter,kmap,fonte,metodoP,w,s,benchmark,weightDMP,auxface,wells,mobility,Hesq, Kde, Kn, Kt, Ded);
%             
%             % resolvedor de pressï¿½o pelo mï¿½todo de Newton-Discreto
%             [pressure,step,errorelativo,flowrate,flowresult]=iterdiscretnewton(M_old,RHS_old,tol,kmap,...
%                 parameter,metodoP,auxflag,w,s,nflagface,fonte,p_old,gamma,...
%                 nflagno,benchmark,M_old1,RHS_old1,p_old1,weightDMP,auxface,wells,mobility,Hesq, Kde, Kn, Kt, Ded);
%             
%             
%         elseif strcmp(iteration, 'iterhybrid')
%             
%             p_old1=M_old\RHS_old;
%             
%             % interpolaï¿½ï¿½o nos nï¿½s ou faces
%             [pinterp1]=pressureinterp(p_old1,nflagface,w,s,auxflag,metodoP,parameter,weightDMP,mobility);
%             
%             % calculo da matriz globlal inicial
%             [M_old1,RHS_old1]=globalmatrix(p_old1,pinterp1,gamma,nflagface,nflagno,...
%                 parameter,kmap,fonte,metodoP,w,s,benchmark,weightDMP,auxface,wells,mobility,Hesq, Kde, Kn, Kt, Ded);
%             
%             % solver pressure pelo mï¿½todo hybrido
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
%             % interpolaï¿½ï¿½o nos nï¿½s ou faces
%             [pinterp1]=pressureinterp(p_old1,nflagface,nflagno,w,s,auxflag,metodoP,parameter,weightDMP,mobility);
%             
%             % calculo da matriz globlal inicial
%             [M_old1,RHS_old1]=globalmatrix(p_old1,pinterp1,gamma,nflagface,nflagno,...
%                 parameter,kmap,fonte,metodoP,w,s,benchmark,weightDMP,auxface,wells,mobility,Hesq, Kde, Kn, Kt, Ded);
%             
%             % calculo da pressï¿½o
%             [pressure,step,errorelativo,flowrate,flowresult]= JFNK1(tol,kmap,parameter,metodoP,auxflag,w,s,nflagface,fonte,gamma,...
%                 nflagno,benchmark,M_old1,RHS_old1,p_old1,R0,weightDMP,auxface,wells,mobility,Hesq, Kde, Kn, Kt, Ded);
%             
%         end
%         
%     case {'lfvHP','lfvLPEW','mpfad','tpfa'}
%         
%         pressure=M_old\RHS_old;
%         if strcmp(metodoP, 'lfvHP')
%             % interpolaï¿½ï¿½o nos nï¿½s ou faces
%             [pinterp]=pressureinterp(pressure,nflagface,nflagno,w,s,auxflag,metodoP,parameter,weightDMP,mobility);
%             % calculo das vazï¿½es
%             [flowrate,flowresult]=flowratelfvHP(parameter,weightDMP,mobility,pinterp,pressure);
%         elseif strcmp(metodoP, 'lfvLPEW')
%             [pinterp]=pressureinterp(pressure,nflagface,nflagno,w,s,auxflag,metodoP,parameter,weightDMP,mobility);
%             % calculo das vazï¿½es
%             [flowrate,flowresult]=flowratelfvLPEW(parameter,weightDMP,mobility,pinterp,pressure);
%         elseif  strcmp(metodoP, 'tpfa')
%             [flowrate, flowresult]=flowrateTPFA(pressure,Kde,Kn,Hesq,nflag,mobility);
%         else
%             % calculo das vazï¿½es
%             [flowrate,flowresult]=calflowrateMPFAD(pressure,w,s,Kde,Ded,Kn,Kt,Hesq,nflag,auxflag,mobility);
%         end
%         residuo=0;
%         niteracoes=0;
%         
%         name = metodoP;
%         X = sprintf('Calculo da pressï¿½o pelo mï¿½todo: %s ',name);
%         disp(X)
%         
%         x=['Residuo:',num2str(residuo)];
%         disp(x);
%         y=['Nï¿½mero de iteraï¿½ï¿½es:',num2str(niteracoes)];
%         disp(y);
%         
% end

end