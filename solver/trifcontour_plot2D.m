function [X,Y,F]=trifcontour_plot2D(elem,coord,f)

% X, Y = coordinates of vertices in mesh
% elem = connectivity array
% f = scalar concentration for each element

nele=size(elem,1);
for i=1:nele
    if elem(i,end-1)==0
        geo = 3;%trian
    else
        geo = 4;%Quad
    end
    for j=1:geo,
        X(j,i)=coord(elem(i,j),1);
        Y(j,i)=coord(elem(i,j),2);
        F(j,i)=f(i);
    end
end
patch(X,Y,f');
%hold on
%contour(X,Y,F)
return
