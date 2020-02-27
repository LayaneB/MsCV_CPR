tmp1  = zeros(size(elem,1),1);
tmp2  =  tmp1;
tmp3 = tmp1;
index = 28;

HH = intersect(intRegion{index}, find(GlobalBoundary));

tmp1(intRegion{index}) = 9.5;
tmp1(boundRegion{index}) = 22.5;
tmp1(coarseElemCenter) = 30;
%calewhite
tmp2(intRegion{index}) =  9.5;
tmp2(HH) = 20;
tmp2(boundRegion{index}) = 22.5;
tmp2(coarseElemCenter) = 30;



tmp3(coarseElemCenter) = 30;
tmp3(find(GlobalBoundary)) = 15;

superFolder = 'C:\Users\admin\Google Drive\Programação\FV-MsRB\';


postprocessorName(tmp1,tmp3,superFolder, 'intRegion1')
postprocessorName(tmp2,tmp3,superFolder, 'intRegion2')
