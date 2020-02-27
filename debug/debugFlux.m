

coarseConsv2 = zeros(npar,1);

cElem = 16;

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

flowcElem = flowrateMsTPFA( fluxcElem,tEq(edgesOnCoarseBoundary), pd);

coarseConsv1(index) = sum(flowcElem);

for ii = 1:size(flowcElem,2)
    leftElem = inedge(fluxcElem(ii),3);
    rightElem = inedge(fluxcElem(ii),4);
    
    if elemloc(rightElem) ~= cElem
        flowcElem(ii) = -flowcElem(ii); 
    end
    
end

coarseConsv2(index) = sum(flowcElem);

end