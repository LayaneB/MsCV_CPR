grupo = [];

for index = 1: npar
    
   grupo = [grupo ; intersect(boundRegion{index},find(GlobalBoundary))]; 
end