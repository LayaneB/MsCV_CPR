function [ newFlux ] =fluxCorrection(matFluxCons, matFluxPi, flowTr )
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here
    global intinterface inedge elemloc bedge
    errorFlux = matFluxCons - matFluxPi;
       
        for ii = 1:size(matFluxCons,1)
            for jj = (ii+1):size(matFluxCons,2)        
                if ~isempty( intinterface{ii,jj})
                       auxvec = intinterface{ii,jj} + size(bedge,1);            
                       left = inedge(intinterface{ii,jj},3);
                       right = inedge(intinterface{ii,jj},4);
                       sig = double(ismember([elemloc(left) elemloc(right)], [ii jj],'rows'));
                       sig(sig == 0) = -1;                       
                       %weight = sig.*abs(flowTr(auxvec))'/sum(sig.*abs(flowTr(auxvec))');
                       
                       weight = abs(flowTr(auxvec))'/sum(abs(flowTr(auxvec))');
                       
                       flowTr(auxvec) = flowTr(auxvec)' +  sig.* weight.*errorFlux(ii,jj);
                end
            end
       end
        
    newFlux = flowTr;
end

