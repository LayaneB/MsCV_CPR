function saveImages(Caso, refNum , refType, meshAnal,p,pms )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
%saveImages('5spot', '01',lastMethod, meshAnal,p,pms)
if refType == 1
   methType = 'TPFA';
else
   methType = 'MPFA-D';
end


if meshAnal == 1
    typeMMesh = 'Structured-Mesh';
else
    typeMMesh = 'Unstructured-Mesh';
end
num1 = [ num2str(refNum) '-' Caso  '-' typeMMesh '-Reference-Solution-' methType];
num2 = [ num2str(refNum) '-' Caso  '-' typeMMesh '-Multiscale-Solution-' methType];
postprocessorDebugN(full(p),0,0,0,1,0,0,0,0,0,num1);
postprocessorDebugN(full(pms),0,0,0,1,0,0,0,0,0,num2);


end

