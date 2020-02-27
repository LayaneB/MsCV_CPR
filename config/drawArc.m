function [ out ] = drawArc( Xm1,Ym1,Rad,arc,PHI,num1,num2)
%returns coordinates of a square polygon
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
 arc = arc*pi/180;
 PHI = PHI*pi/180;
 rotMat = [ cos(PHI) -sin(PHI); sin(PHI) cos(PHI)];

 p1x = Rad * cos(arc);
 p1y = Rad * sin(arc);
 p2x = Rad * cos(arc);
 p2y = -Rad * sin(arc);
 
 vec1 = rotMat*[p1x ; p1y];
 vec2 = rotMat*[p2x ; p2y];
 
 
plot(Xm1,Ym1,'ro');
plot(vec1(1)+Xm1,vec1(2)+Ym1,'o');
plot(vec2(1)+Xm1,vec2(2)+Ym1,'o');

out = [vec1(1)+Xm1,vec1(2)+Ym1; Xm1,Ym1;vec2(1)+Xm1,vec2(2)+Ym1];

text1 = sprintf('Point(%d) = {%f,%f,cl__1};',num1, out(1,1),out(1,2));
text2 = sprintf('Point(%d) = {%f,%f,cl__1};',num1+1, out(2,1),out(2,2));
text3 = sprintf('Point(%d) = {%f,%f,cl__1};',num1+2, out(3,1),out(3,2));


text4 = sprintf('Circle(%d) = {%d,%d,%d}',num2,num1,num1+1,num1+2);
disp(text1)
disp(text2)
disp(text3)
disp(text4)
 
end

