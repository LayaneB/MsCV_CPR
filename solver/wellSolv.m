%Script that Reads Info on Wells
%OUTPUT:
%Saturation
% flagsSat - list  all unique saturation flags read
% flagsSatValue - list flagsSat flux value
% flagsSatTotalArea - list the total area which flagSatValue is being
% spread
% flagSatElem - list all elements that recieve the flux
%Injection Well (Pressure)
% flagsInj - list of all injection flags read - ;
% flagsInjValue - list of all pressure values for injection);
% flagsInjElem  - list all elements that have this value;
%Produce Well (Pressure)
% flagsProd - list of all production flags read - ;
% flagsProdValue - list of all pressure values for production);
% flagsProdElem  - list all elements that have this value;

if ~isempty(wells)
    %checking cases
    satWell = wells(:,3) > 300;
    injWell = (wells(:,5) > 400) & (wells(:,5) < 501);
    prodWell = (wells(:,5) > 500);
    
    %injected flow
    flagsSat = unique(wells(satWell,3));
    
    flagsSatValue = zeros(size(flagsSat));
    flagsSatTotalArea = zeros(size(flagsSat));
    flagsSatElem = cell(size(flagsSat));
    
    for index = 1: size(flagsSat,1)
        %flagSatTotalArea(index) =   
        %sum(elemarea(
        tmp = wells(wells(:,3) == flagsSat(index),4);
        flagsSatValue(index) = tmp(1);
        flagsSatTotalArea(index) = sum(elemarea(wells(find(wells(:,3) ==  flagsSat(index)),1))) ;
        flagsSatElem{index,1} =  wells(find(wells(:,3) == flagsSat(index))',1)';
        %)
    end
  
   flagsInj = unique(wells(injWell,5));
   flagsInjValue = zeros(size(flagsInj));
   flagsInjElem = cell(size(flagsInj));
   for index = 1: size(flagsInj,1)
        tmp = wells(wells(:,5) == flagsInj(index),6);
        flagsInjValue(index) = tmp(1);
        flagsInjElem{index,1} =  wells(find(wells(:,5) == flagsInj(index))',1)';
   end
    
   flagsProd = unique(wells(prodWell,5));
   flagsProdValue = zeros(size(flagsProd));
   flagsProdElem = cell(size(flagsProd));

   for index = 1: size(flagsProd,1)
        tmp = wells(wells(:,5) == flagsProd(index),6);
        flagsProdValue(index) = tmp(1);
        flagsProdElem{index,1} =  wells(find(wells(:,5) == flagsProd(index))',1)';
   end 
    
end