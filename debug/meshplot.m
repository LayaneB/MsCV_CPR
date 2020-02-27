function [out] = meshplot( mat, c1, c2, varargin )
%meshPlot Plot quad and tri meshes
%  


op = mat(:,4) == 0;
tri = find(op);
quad = find(~op);

%case 
edT = [mat(tri,1)  mat(tri,2);  mat(tri,2)  mat(tri,3); mat(tri,3)  mat(tri,1)];
edQ = [mat(quad,1)  mat(quad,2);  mat(quad,2)  mat(quad,3); ...
    mat(quad,3)  mat(quad,4);mat(quad,4)  mat(quad,1) ];
edg = unique([edT; edQ],'rows');

if nargin > 3
    out = plot(c1(edg)', c2(edg)',varargin{1},varargin{2:end});
   
else
    out = plot(c1(edg)', c2(edg)');
end




end

