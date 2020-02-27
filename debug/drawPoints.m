function drawPoints( pointList,cor,nup )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

global coord
for ii = pointList'
    point = coord(ii,1:2)
    %plot(point(1),point(2),'Marker','o');.%,'MarkerSize',20);
    if nup == 1
        map = '-o';
    else
        map = '-s';
    end
    plot(point(1),point(2),map,'MarkerSize',10,...
    'MarkerEdgeColor','black',...
    'MarkerFaceColor',cor)
    
end

end

