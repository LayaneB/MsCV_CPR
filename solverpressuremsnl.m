function [pressure,errorelativo,flowrate,flowresult]=solverpressuremsnl(kmap,nflagno,fonte,...
    tol, nit,p_old,mobility,N,parameter,metodoP,...
    interptype)
global edgesOnCoarseBoundary bedge
%% ==============================
[w,s]=Pre_LPEW_2(kmap,N);
%% ===========================================================

% interpola��o nos n�s ou faces
[pinterp]=pressureinterp(p_old,nflagno,w,s);
[M_old,RHS_old]=assemblematrixGYZS(pinterp,parameter,fonte,mobility);

%processo iterativo
[pressure,step,errorelativo,flowrate,flowresult,M_old,RHS_old]=iterpicardmsnl2(M_old,RHS_old,nit,tol,...
    parameter,metodoP,w,s,fonte,p_old,nflagno,mobility);
flowPd = flowrate( edgesOnCoarseBoundary + size(bedge,1));
%debugFluxMPFA

end