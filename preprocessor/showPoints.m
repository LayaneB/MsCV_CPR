function showPoints( counter, points )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

text = ' Point(%d) = {%f, %f, 0, cl1};';
for index = 1: size(points,1)
    
    num = index + counter;
    f1 = points(index,1);
    f2 = points(index,2);
    disp(sprintf(text,num,f1,f2))
    
    
end


end

