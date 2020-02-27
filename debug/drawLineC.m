function [out] = drawLineC(p1, p2,coord,cor)
%[p1,p2];
x1 = coord(p1,1);
y1 = coord(p1,2);
x2 = coord(p2,1);
y2 = coord(p2,2);


out  = plot([x1,x2],[y1,y2],'color',cor,'LineWidth',2.5);
%set(h, 'Position', [0 0 500 500])
hold on
end