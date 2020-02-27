% 
% folder = '\Results';
% caseTypeT = strcat('\',caseType,'-',num2str(npar),'cv');

meshname = '/CoarseMesh';
fileName = strcat(meshname,'.vtk');

fName = strcat(superFolder,fileName);


fileID = fopen(fName,'w');

fprintf(fileID,'# vtk DataFile Version 2.0\nCube example\nASCII\nDATASET UNSTRUCTURED_GRID\n');
fprintf(fileID,'POINTS %d float\n',size(coord,1));

for ii = 1: size(coord,1)
fprintf(fileID,'%.16E %.16E %.16E\n',coord(ii,1),coord(ii,2),coord(ii,3));    
    
end



fprintf(fileID,'CELLS %d %d\n',(size(edgesOnCoarseBoundary,1) + size(bedge,1)),3*(size(edgesOnCoarseBoundary,1)+ size(bedge,1) ))

for ii = 1: size(edgesOnCoarseBoundary,1)
    fprintf(fileID,'2 %d %d\n',inedge(edgesOnCoarseBoundary(ii),1)-1,inedge(edgesOnCoarseBoundary(ii),2) -1);
end

for ii = 1: size(bedge,1)
    fprintf(fileID,'2 %d %d\n',bedge(ii,1)-1,bedge(ii,2)-1);
end

fprintf(fileID,'CELL_TYPES %d\n',(size(edgesOnCoarseBoundary,1) + size(bedge,1)));
for ii = 1:( size(edgesOnCoarseBoundary,1) + size(bedge,1))
    fprintf(fileID,'3\n');
end

fclose(fileID);

% fprintf(fileID,'LINES 2 %d \n',2*size(edgesOnCoarseBoundary,1))
% 
% 
% 
% for ii = 1: size(edgesOnCoarseBoundary,1)
%     fprintf(fileID,'2 %d %d\n',inedge(edgesOnCoarseBoundary(ii),1)-1,inedge(edgesOnCoarseBoundary(ii),2) -1);
% end