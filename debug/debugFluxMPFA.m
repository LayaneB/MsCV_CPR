% [flowMs, flowresultMs,velocityMs] = flowrateMPFAD(p,w,s,Kde,Ded,Kn,Kt,Hesq,nflagno,auxflag);
% flowMs = flowMs(size(bedge,1)+1:end);
global npar
coarseConsv1 = zeros(npar,1);
coarseConsv2 = zeros(npar,1);
global intinterface inedge elemloc

%flowMs = flowPms;
%flowMs = flowPd;
%flowMs = flowrate;

flowMs = flowrate((size(bedge,1) +1):end) ;
flowMs = flowrate;

acum = [];
for index = 1:npar
    cElem = index;
    [eii , ejj] = size(intinterface);
    fluxcElem = [];
    for jj = 1:ejj
        if ~isempty( intinterface{cElem,jj})
           fluxcElem =  unique([fluxcElem;intinterface{cElem,jj}]);        
        end
    end

    acum = unique([acum;fluxcElem]);

    fluxcElem1 = fluxcElem;
    
    flowcElem = flowMs(fluxcElem1);

    coarseConsv1(index) = sum(flowcElem);
    if index == 11
        1+1;
    end
    for ii = 1:size(flowcElem,2)
        leftElem = inedge(fluxcElem(ii),3);
        rightElem = inedge(fluxcElem(ii),4);

        if elemloc(leftElem) ~= cElem
            flowcElem(ii) = -flowcElem(ii); 
        end

    end

    coarseConsv2(index) = sum(flowcElem);

end