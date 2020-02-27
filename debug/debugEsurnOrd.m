point = 1280 ;

%testar 82 10 e11
% 31 16
% 3 16
region = 1;

ip = esurnOrd(point,region)
for ii = 1: size(ip,1)
    ooo = ip(ii);
    %ooo
    meshplot(elem(ooo,1:4), coord(:,1), coord(:,2),'color',colormat(13,:), 'LineWidth' , 2.1);
end