point = 171;
region = 11;
%10 e 11
ooo = noZero(Nregion(point,:,region));


%ooo = noZero(N(82,:));

ordEdges(point,ooo',11)
ppp = [171 170 192 194 173 172];
store = ppp;
for ii = 1 : size(store,2)
    
   p = coord(ppp(ii),1:2);
   plot(p(1),p(2),'rX');    
end