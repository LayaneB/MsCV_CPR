figHandle = figure;
figure(figHandle);
%set(figHandle,'Color',[1 1 1]);
set(figHandle, 'Position', [0 0 700 700],'Color',[1 1 1])
%debugTestP
hold on
whitebg('white')
ylim([-0.05 1.05])
xlim([-0.05 1.05])
set(gca,'XTick',[0])
set(gca,'YTick',[0])
set(figHandle,'Color',[1 1 1]);
set(gca,...
'XTickLabel','')
set(gca,...
'YTickLabel','')
axis off
grid off

%all edgges
for ii = 1:size(inedge,1)
    tmp = inedge(ii,1:2);
    drawLineCE(tmp(1),tmp(2),coord,[0.5 0.5 0.5],1.2);   
end


for ii = 1:size(edgesOnCoarseBoundary,1)
    
    tmp = inedge(edgesOnCoarseBoundary(ii),1:2);
    drawLineCE(tmp(1),tmp(2),coord,[1 0 0],2.5);   
end

% 
%  for num = 1: size(listas,1)
%     %ploting mesh
%      
%     for i=1:size( listas{num}{1},1)
%         
%         if i == size( listas{num}{1},1)
%             x1 = listas{num}{1}(i,1);
%             y1 = listas{num}{1}(i,2);
%             x2 = listas{num}{1}(1,1);
%             y2 = listas{num}{1}(1,2); 
%         else
%             x1 = listas{num}{1}(i,1);
%             y1 = listas{num}{1}(i,2);
%             x2 = listas{num}{1}(i+1,1);
%             y2 = listas{num}{1}(i+1,2);            
% 
%         end
%         %graf = drawLineC(tmp(1),tmp(2),coord,[0 0 0]);
%         plot([x1,x2],[y1,y2],'color',[0 0.35 1],'LineWidth',3.5);
%     end 
%     
%  end
% %contorno

set(figHandle, 'name', [''],'NumberTitle','off');
 title([],'FontSize', 14)

plot([0,0],[0,1],'color',[0 0 0],'LineWidth',2.3);
plot([0,1],[1,1],'color',[0 0 0],'LineWidth',2.3);
plot([1,1],[1,0],'color',[0 0 0],'LineWidth',2.3);
plot([0,1],[0,0],'color',[0 0 0],'LineWidth',2.3);
 
   