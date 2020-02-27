%ploting interaction region generated
 ii = 1;
 jj = ii;
 
%      1
%      7
%     43
%     49
global boundRegion coarseElemCenter
 %ver caso 15 16 do sp
 %ver caso 11 18 do 18p
big = [ 5.2 , 2.7 , 5.1];
small = [ 2.2 1.7 2.1];
 
 
colormat = load('color.dat');
%triangulation
%triplot(intDel{ii,1}, intDel{ii,2}(:,1) ,intDel{ii,2}(:,2), 'color', colormat(9,:), 'LineWidth' , 1.9)

%meshplot(elem(intRegion{ii},1:4),coord(:,1),coord(:,2),'color', colormat(8,:), 'LineWidth' , 2.2);
%meshplot(elem(GlobalBoundary,1:4), coord(:,1), coord(:,2),'color',colormat(88,:), 'LineWidth' , 1.7);
%meshplot(elem(H{ii},1:4), coord(:,1), coord(:,2),'color',colormat(14,:), 'LineWidth' , 1.7);

meshplot(elem(boundRegion{ii},1:4), coord(:,1), coord(:,2),'color',colormat(6,:), 'LineWidth' , 1.7);

%meshplot(elem(coarseElemCenter(ii),1:4), coord(:,1), coord(:,2),'color',colormat(2,:), 'LineWidth' , 4.1);

%quadmesh(elem(intRegion{ii},1:4),coord(:,1),coord(:,2),'color', colormat(8,:), 'LineWidth' , 1.2)

    % meshplot(elem([3075 3078 3087 3901 3007 2726 2728 2729 1347],1:4), coord(:,1), coord(:,2),'color',colormat(9,:), 'LineWidth' , 2.1);

%   for ii = 1:size(coarseelem{jj},2)
%      meshplot(elem(coarseelem{jj}(ii),1:4), coord(:,1), coord(:,2),'color',colormat(9,:), 'LineWidth' , 2.1);
%   end
%   
  for ii = 1:npar
     meshplot(elem(coarseElemCenter(ii),1:4), coord(:,1), coord(:,2),'color',colormat(2,:), 'LineWidth' , 2.1);
  end