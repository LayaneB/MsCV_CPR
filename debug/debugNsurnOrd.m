point = 1280;
region = 1;
%testar 82 10 e11
% 31 16
% 3 16


ip = nsurnOrd(point,region);
 for ii = 1: size(ip,1)
     ooo = ip(ii);
     drawLineC(point, ooo,coord,[1 0 1]);
 end