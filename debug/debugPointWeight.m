region = 25;


for ii = 1 :size(pointWeight{region},1)
    ip = pointWeight{region}(ii);
    plot(coord(ip,1),coord(ip,2),'yo')
    
    
end

