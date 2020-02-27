function [ output_args ] = macroFlow( flowTr)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
    global inedge bedge coord intinterface exinterfaceaxes exinterface elemloc npar
    fluxMatrix = zeros(size(intinterface));
        for ii = 1:size(fluxMatrix,1)
            for jj = 1:size(fluxMatrix,2)        
                if ~isempty( intinterface{ii,jj})

                       auxvec = intinterface{ii,jj} + size(bedge,1);            
                       left = inedge(intinterface{ii,jj},3);
                       right = inedge(intinterface{ii,jj},4);
                       sig = double(ismember([elemloc(left) elemloc(right)], [ii jj],'rows'));
                       sig(sig == 0) = -1;
                       fluxMatrix(ii,jj) = sum( sig.*flowTr(auxvec)');
                end
        end
    end

%     boundaryFlux = zeros(npar,1);
%     for ii = 1 : size( exinterfaceaxes,1) 
%         if ~isempty(exinterface{ii})
%            auxvec = exinterface{ii};
%            boundaryFlux(ii) = sum(flowTr(auxvec));  
%         end   
%     end
% 
% 
%     totalFlux = sum(fluxMatrix,2) +  boundaryFlux;
    %output_args = totalFlux;
    output_args = fluxMatrix;
end

