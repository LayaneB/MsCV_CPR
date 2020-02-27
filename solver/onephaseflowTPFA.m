disp('TPFA Solver for Single Phase Flow')
%find local references
refGlobal2Local
lastMethod = 1;
tic
ii = 1: size(inedge,1);
[HL, HR,faceDist] = heightCalc(inedge, coord, centelem);

%%function that projects K onto the edges
 [ KtL, KtR, Kbedge ] = projecPerm( kmap );

 %tEq - Equi Transmissbility Projected on the face multiplied by the EDGE
 
tEq = transEdge(KtL,KtR,HL,HR,faceDist);
[TransF, F] = assemblyOnePhaseTPFA( coord, elem,bedge,inedge,bcflag,tEq ,Kbedge);


toc
%pre condition matrix
TransFc = (TransF+TransF')*0.5;
n = size(TransFc,2);

TransFc(1:size(TransFc,2)+1:end) = diag(TransFc) - sum(TransFc,2);
tic
OR  = genRestrictionOperator(size(elem,1), npar);
OP =  genProlongationOperator(OR', TransFc, 2/3,800);


%% wells treatment
if size(wells,2) > 1
    ref = wells(:,5) > 400;
end
%OP(wells(ref,1),:) = 0;
%%



ac = OR * TransF * OP;
bc = OR * F;
pc = ac\bc;
pd = OP*pc;

[TransFn,Fn] = minusTPFA(edgesOnCoarseBoundary,pc,TransF,F,tEq(edgesOnCoarseBoundary));
%%
if size(wells,2) > 1
  pd(wells(ref,1)) = wells(ref,end);
end
%% Calculates the flow on the Edges of the Coarse Boundary
flowPd = flowrateMsTPFA( edgesOnCoarseBoundary,tEq(edgesOnCoarseBoundary), pd);

%%
pp =  neumanm(TransFn,Fn, coarseelem , edgesOnCoarseBoundary, flowPd,pc );
flowPp = flowrateTPFA(tEq, Kbedge, pp,HL);
flowPms = compoundFlow( flowPp,flowPd,size(bedge,1) );

toc

tic
p = TransF\ F;
toc
%
%postprocessor(pressure,flowrate,watersaturation,oilsaturation,...
%    step,overedgecoord,orderintimestep,keywrite,invh,normk)
%postprocessor(p,0,0,0,0,0,0,0,0,0) 

