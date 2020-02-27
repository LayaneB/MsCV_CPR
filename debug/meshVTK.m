
intR = 20;
caseType = '5Spot';
folder = '\Results';
caseTypeT = strcat('\',caseType,'-',num2str(npar),'cv');
superFolder = strcat(pwd,folder,caseTypeT);
mkdir(superFolder);

coarseVTK

coarseCenter = zeros(size(elem,1),1);
coarseCenter(coarseElemCenter) = 10;
coarseCenter(boundRegion{intR}) = 7.5;
coarseCenter(intRegion{intR}) = 4;

postprocessorTM(elemloc,coarseCenter,superFolder)

