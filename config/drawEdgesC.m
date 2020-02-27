function [out] = drawEdgesC(edges,cor)
%[p1,p2];
global coord inedge

for edge = edges

p1 = inedge(edge,1);
p2 = inedge(edge,2);

x1 = coord(p1,1);
y1 = coord(p1,2);
x2 = coord(p2,1);
y2 = coord(p2,2);


out  = plot([x1,x2],[y1,y2],'color',cor,'LineWidth',2.5);
end
%set(h, 'Position', [0 0 500 500])
hold on
end