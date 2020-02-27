function [ KnL, KnR , Kbedge] = projecPerm( kmap )
%projecPerm Project the permeability on the edge
%   Detailed explanation goes here
% INPUT:
% kmap
% OUTPUT:
% KnL = Permeability tensor projected , normal to the edge on the Left
% KnR = Permeability tensor projected , normal to the edge on the Right
% Kbedge = Permeability tensor projected, on the edges of the boundary
global inedge elem coord bedge

KnL = zeros(size(inedge,1),1);
KnR = zeros(size(inedge,1),1);
Kbedge = zeros(size(bedge,1),1);

for index = 1 :size(inedge,1)
    krefL = elem(inedge(index,3),5);
    krefR = elem(inedge(index,4),5);
    
    vecor = (coord(inedge(index,2),1:2) - coord(inedge(index,1),1:2));
    
    kL = reshape(kmap(krefL,2:end),2,2);
    kR = reshape(kmap(krefR,2:end),2,2);
       
    %RotHtpfa(vecor)' * kL
    
    
   % KtL(index) =(RotHtpfa(vecor)'*kL*(vecor)')      /norm(vecor)^2;
    
    KnL(index)=(RotHtpfa(vecor)'*kL*RotHtpfa(vecor))/norm(vecor)^2;
    %KtR(index) =(RotHtpfa(vecor)'*kR*(vecor)')/norm(vecor)^2;
    KnR(index)=(RotHtpfa(vecor)'*kR*RotHtpfa(vecor))/norm(vecor)^2;
    
    
    
    %disp([KtL, KtR])
    
    
end



for index = 1: size(bedge,1)
    kref = elem(bedge(index,3),5);
    kbe = reshape(kmap(kref,2:end),2,2);
    
    vecor = (coord(bedge(index,2),1:2) - coord(bedge(index,1),1:2));
    Kbedge(index) = (RotHtpfa(vecor)'*kbe*RotHtpfa(vecor))/norm(vecor)^2;
    
    
end
%kEdge =   (face) .* ((kL .* kR) ./ ((kL .* hR) + (kR.*hL))) ; 


end

