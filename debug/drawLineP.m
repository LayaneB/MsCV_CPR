function [] = drawLineP(p1, p2)

x1 = p1(1);
y1 = p1(2);

x2 = p2(1);
y2 = p2(2);

plot([x1,x2],[y1,y2])


%plot([x1,x2],[y1,y2],'LineWidth' , 1.3)
hold on
end