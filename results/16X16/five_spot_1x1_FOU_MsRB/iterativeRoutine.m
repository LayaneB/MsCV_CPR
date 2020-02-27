%% Iterative Smoother for the Solution
%  Smoother Type - stype 
%  0 - None
%  1 - Jacobi
%  2 - Gauss Seidel
%  3 - SOR
%      SOR Relaxation Parameter  - wrelax
% Number of Iterations - itnum
% 4 - Dirichlet Lorena
% 5 - Dirichlet + SOR
% 6 - Olav Duplo + SOR
stype = 0;
wreal = 1.85;
itnum = 400;
itnumDirch = 5;
if stype == 3
    
    [ pi, err, iter, flag ] = sor(TransF, pd, F, wreal, itnum, 0.0001);
     [flowPi, flowresultPi,velocityPi]=calflowrateMPFAD(pi,w,s,Kde,Ded,Kn,Kt,Hesq,nflag,auxflag,mobility);
     matFluxCons = macroFlow(flowPd);
     matFluxPi = macroFlow(flowPi);
     [ newFlux ] = fluxCorrection(matFluxCons, matFluxPi, flowPi);
      velocityPi = newVelocity(newFlux);

elseif stype == 4
    
    pi = dirichIteration(TransF,F,pd,itnumDirch);
    [flowPi, flowresultPi,velocityPi]=calflowrateMPFAD(pi,w,s,Kde,Ded,Kn,Kt,Hesq,nflag,auxflag,mobility);
    matFluxCons = macroFlow(flowPd);
    matFluxPi = macroFlow(flowPi);
    [ newFlux ] = fluxCorrection(matFluxCons, matFluxPi, flowPi);
     velocityPi = newVelocity(newFlux);
      

%      save7 = fluxSummation(flowPi);
%      a4 = sum(abs(save7) < 0.000000000001) / size(save7,1);
%      b4 = abs(save7) > 0.00000001;
elseif stype == 5
    
    pi = sorDirichIteration(TransF,F,pd,itnumDirch,  wreal, itnum, 0.0001);
    [flowPi, flowresultPi,velocityPi]=calflowrateMPFAD(pi,w,s,Kde,Ded,Kn,Kt,Hesq,nflag,auxflag,mobility);
    matFluxCons = macroFlow(flowPd);
    matFluxPi = macroFlow(flowPi);
    [ newFlux ] = fluxCorrection(matFluxCons, matFluxPi, flowPi);
    velocityPi = newVelocity(newFlux);
elseif stype == 6
    ePart = F - TransF*pd;
    [ yp, err, iter, flag ] = sor(TransF, ePart, F, wreal, itnum, 0.0001);
    
    pi = yp + pd + OP*((1\ac))*OR*( (ePart - TransF*yp));
    
    
end
%stype = 0;
if stype > 0 & stype < 6
      global coarseElemCenter 
      pc =  pi(coarseElemCenter);   
      pd = pi;
      velocityPd = velocityPi;
      flowPd = newFlux;
      flowPd2 = flowPd( edgesOnCoarseBoundary + size(bedge,1));
elseif stype >= 6
      global coarseElemCenter 
      pc =  pi(coarseElemCenter);   
      pd = pi;
      [flowPd, flowresultPd,velocityPd]=calflowrateMPFAD(pi,w,s,Kde,Ded,Kn,Kt,Hesq,nflag,auxflag,mobility);  
end