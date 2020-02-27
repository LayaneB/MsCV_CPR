
permFuncFlag = 1

kmap = zeros(size(elem,1),5);
elem(:,5) = 1:size(elem,1); 
kmap(:,1) = 1:size(elem,1);


if permFuncFlag == 1
    
    a = permPotier(centelem(:,1),centelem(:,2));
elseif permFuncFlag == 2
    1+2
else 
    1+3
end


kmap(:,1) =  1:size(elem,1)';
kmap(:,2) = a;
kmap(:,5) = a;

Kmat = kmap(:,2);
