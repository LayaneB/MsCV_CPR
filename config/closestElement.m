function [ out] = closestElement( xm,ym)
%closestElement Calcula o Elemento mais perto do ponto xm,ym
%   INPUT : xm,ym
%   OUTPUT: Elemento mais proximo

global centelem
xp = centelem(:,1);
yp = centelem(:,2);
groupDist = @(x,y)( sqrt((xp - x).^2 + (y-yp).^2));
out = find(min(groupDist(xm,ym)) == groupDist(xm,ym));

end

