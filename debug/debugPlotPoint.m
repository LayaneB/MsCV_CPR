
%8 e 11
list = nsurn(88,2,11);

for ii=1:size(list,1)
    item = list(ii);
    plot(coord(item,1),coord(item,2),'yo');
end
