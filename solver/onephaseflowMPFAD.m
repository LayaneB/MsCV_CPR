
disp('MPFA-D Solver for Single Phase Flow')
refGlobal2Local
%structure to store W and S dynammically 

fluxEdgesOnCoarseBoundary = zeros(size(edgesOnCoarseBoundary,1),1);


lastMethod = 2;

%%Assembly MPFA-D Matrix
[Hesq, Kde, Kn, Kt, Ded] = Kde_Ded_Kt_Kn(kmap);
[Fo,V,N]=elementface;

nflagno= contflagnoN(bedge);
[w,s]=Pre_LPEW_2(kmap,N);


wsdynamic = dynamic(pointWeight);
[ TransF, F ] = assemblyOnePhaseMPFAD( w,s, Kde, Ded, Kn, Kt, nflagno, Hesq);


auxflag = 0;

%%



%%MultiScale
%pre condition matrix

TransFc = TransF;
n = size(TransFc,2);
TransFc(1:size(TransFc,2)+1:end) = diag(TransFc) - sum(TransFc,2);

tic
OR  = genRestrictionOperator(size(elem,1), npar);
OP =  genProlongationOperator(OR', TransFc, 2/3,1800);



%% wells treatment
if size(wells,2) > 1
    ref = wells(:,5) > 400;
end
%%
ac = OR * TransF * OP;
bc = OR * F;
pc = ac\bc;
pd = OP*pc;

%%
if size(wells,2) > 1
  pd(wells(ref,1)) = wells(ref,end);
end
%% solving the system for comparison purpose
p = TransF\ F;

%% Calculates the flow on the Edges of the Coarse Boundary
%flowPd = flowrateMsMPFAD(edgesOnCoarseBoundary,pd,w,s,Kde,Ded,Kn,Kt,Hesq,nflagno,auxflag);
[flowPd, flowresultPd,velocityPd]=flowrateMPFAD(pd,w,s,Kde,Ded,Kn,Kt,Hesq,nflagno,auxflag);
flowPd2 = flowPd( edgesOnCoarseBoundary + size(bedge,1));
%[flowPd3, flowresultPd3,velocityPd3]=flowrateMPFAD(p,w,s,Kde,Ded,Kn,Kt,Hesq,nflagno,auxflag);



%flowPd3 = flowPd3( edgesOnCoarseBoundary + size(bedge,1));

%% Neuman
%recalculating weights
%tests replacing flowPd by velocityPd
[wsdynamic] = Pre_LPEW_2MS(kmap, wsdynamic,velocityPd);

%excluding influence of edges and nodes that connect different coarse
%regions
[TransFn, Fn] = minusMPFAD(TransF,F, edgesOnCoarseBoundary, w,s, Kde, Ded, Kn, Kt, nflagno, Hesq);
debugUncoupling %tests TransFn to check if the uncoupling is done alright
%adding the influence back with weights that consider only the coarse
%volumes inside
[TransFn, Fn] = addMPFAD(TransFn,Fn, edgesOnCoarseBoundary, oneNodeEdges,flowPd2,wsdynamic,Kde, Ded, Kn, Kt, nflagno, Hesq );
debugUncoupling
pp =  neumanmMPFAD(TransFn,Fn, coarseelem , edgesOnCoarseBoundary, flowPd,pc );


%%
%  pp =  neumanmMPFA(TransFn,Fn, coarseelem , edgesOnCoarseBoundary, flowPd,pc );



%REFAZER A FUNCAO PARA CALCULAR OS FLUXOS USANDO OS PESOS LOCAIS
%ERRO AQUI -> USAR OUTRA MANEIRA PRA CALUALR OS FLUXOS
[flowPp, flowresult,velocity]=flowratePPMPFAD(pp,w,s,wsdynamic, Kde,Ded,Kn,Kt,Hesq,nflagno,auxflag);

flowPms = compoundFlow( flowPp,flowPd2, size(bedge,1) );



consTestMpfa

%pgc = solvLinearDec(TransF,F, find(~GlobalBoundary), pms(~GlobalBoundary));

%pms2 = solvLinearDec(TransF,F, find(GlobalBoundary), pgc(GlobalBoundary));
tic



auxflag = 0;



toc
%%