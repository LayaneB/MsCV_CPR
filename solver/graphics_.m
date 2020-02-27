function graphics_(benchmark,centelem,elem,coord,VPI,oilrecovery,S_old,...
                   smetodo,ordem,t_old,pvi,oil_recovery,step,vx,vy,Time)
Globals2D_CPR;              
            
    if strcmp(benchmark,'barreiras') || strcmp(benchmark,'buckleyl')
        
        x_c=centelem(:,1); y_c=centelem(:,2); z_s=S_old;
        xlin=linspace(min(x_c),max(x_c),100); ylin=linspace(min(y_c),max(y_c),100);
        [X,Y]=meshgrid(xlin,ylin); Z=griddata(x_c,y_c,z_s,X,Y,'natural');
        contourf(X,Y,Z,'LineWidth',1,'ShowText','on'); axis square; axis('off')
        %patch('Faces',elem(:,1:4),'Vertices',[coord(:,1),coord(:,2)],'FaceColor',...
        %    'none','EdgeColor',[1,1,1]*0.75); 
        c=colorbar('horiz','Direction','reverse'); c.Label.String = 'Water Saturation [-]';
        caxis([min(S_old) max(S_old)]);
        title(sprintf([smetodo,' p=',num2str(ordem-1),'   PVI = ',num2str(t_old)]));
        
    elseif strcmp(benchmark,'BenchTwophase4') || strcmp(benchmark,'durlofsky')...
           || strcmp(benchmark,'BenchTwophase3') ||  strcmp(benchmark,'nikitin')           
        subplot('position' ,[0.05 .1 .5 .8]);
        
        if strcmp(test,'five_spot_quad')
        plot([0.25 0.25], [0.75 0.25],'k','LineWidth',3);hold on
        plot([0.75 0.25], [0.75 0.75],'k','LineWidth',3);
        plot([0.75 0.75], [0.25 0.75],'k','LineWidth',3);
        plot([0.25 0.75], [0.25 0.25],'k','LineWidth',3);
        end
        
        x_c=centelem(:,1); y_c=centelem(:,2); z_s=S_old;
        xlin=linspace(min(x_c),max(x_c),100); ylin=linspace(min(y_c),max(y_c),100);
        [X,Y]=meshgrid(xlin,ylin); Z=griddata(x_c,y_c,z_s,X,Y,'natural');
        contour(X,Y,Z,'LineWidth',1,'ShowText','on'); axis('off')
        patch('Faces',elem(:,1:4),'Vertices',[coord(:,1),coord(:,2)],'FaceColor',...
            'none','EdgeColor',[1,1,1]*0.75);
        c=colorbar('horiz','Direction','reverse'); c.Label.String = 'Water Saturation [-]';
        caxis([min(S_old) max(S_old)]);
        title(sprintf([smetodo,' p=',num2str(ordem-1)])); axis square;
        
        subplot('position' ,[0.65 .1 .3 .8]);
        
        plot(VPI,oilrecovery,VPI,1-oilrecovery,pvi,oil_recovery,'--','LineWidth',1.5);
        axis ([0, 1,-0.05,1.05]); grid on; grid minor;
        legend('Water cut','Oil cut','Ref.','Location','Best');
        title(sprintf('PVI = %3.4f ',t_old));
        
    elseif strcmp(benchmark,'shuec2')|| strcmp(benchmark,'spe')
        
        subplot(2,1,1);
        
        x_c=centelem(:,1); y_c=centelem(:,2); z_s=S_old;
        xlin=linspace(min(x_c),max(x_c),100); ylin=linspace(min(y_c),max(y_c),100);
        [X,Y]=meshgrid(xlin,ylin); Z=griddata(x_c,y_c,z_s,X,Y,'natural');
        %contourf(X,Y,Z,'LineWidth',1,'ShowText','on'); axis('off')
        %contourf(X,Y,Z,'LineWidth',1); %axis('off')
        pcolor(reshape(S_old,sqrt(size(centelem,1)),sqrt(size(centelem,1)),1)); %shading flat; axis('off')
        title(sprintf([smetodo,' p=',num2str(ordem-1),'  DOF = ' num2str(size(elem,1)*ordem^2),...
                '   PVI = ',num2str(VPI(end)),'  CPU(min) = ' num2str(Time)]));
        c=colorbar; c.Label.String = 'Water Saturation [-]';
        caxis([min(S_old) max(S_old)]);
        
        subplot(2,1,2);
        
        %-----------------------------------------------------------------
        if step==1
            if strcmp(benchmark,'shuec2')
            trifcontour_plot2D(elem,coord,normk); 
            c=colorbar; c.Label.String = 'Norm Permeability [-]';axis('off')
            else
            pcolor(log10(perm_)); shading flat; 
            c=colorbar; c.Label.String = 'Log10 Permeability [-]';axis('off')
            end
            %if strcmp(smetodo,'cpr'),hold on; str_lines(nE,dx,dy,Vnd,vx,vy);end
        end
        %----------------------------------------------------------------- 
    end
    drawnow;
return
%=========================================================================
%=========================================================================
% if strcmp(sml,'on')
%     if strcmp(benchmark,'shuec2') || strcmp(benchmark,'buckleyl')
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% cll = size(elem,1); dx=1/sqrt(cll); dy=1/sqrt(cll);
% contourf(linspace(dx/2,1-dx/2,sqrt(cll)),...
%    linspace(dy/2,1-dy/2,sqrt(cll)),...
% reshape(S_old,sqrt(cll),sqrt(cll)),'ShowText','on');
% colorbar('location','eastoutside');
% title(sprintf([smetodo,' p=',num2str(ordem-1),'   PVI = ',num2str(t_old),'   Sat. Contours']));
% axis square; 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%     elseif strcmp(benchmark,'barreiras')|| strcmp(benchmark,'durlofsky')... 
%             || strcmp(benchmark,'BenchTwophase4')
% %============================================== 
% x_c=centelem(:,1); y_c=centelem(:,2); z_s=S_old;
% %
% xlin=linspace(min(x_c),max(x_c),100); ylin=linspace(min(y_c),max(y_c),100);
% [X,Y]=meshgrid(xlin,ylin); Z=griddata(x_c,y_c,z_s,X,Y,'natural');
% contour(X,Y,Z,'LineWidth',1,'ShowText','on');
% %--------------------------------------------------------------------------
% % [C, ~] = contour(X,Y,Z,'LineWidth',1);
% % tl = clabel(C, 'FontSize', 10);
% % itvec = 2:2:length(tl);
% % NewCoutours = zeros(size(itvec));
% % for i= itvec
% %     textstr = get(tl(i), 'String');
% %     NewCoutours(i) = round(str2double(textstr), 2);
% % end
% % contour(X,Y,Z, NewCoutours, 'ShowText','on');
% %contour(X,Y,Z,'LineWidth',1); colorbar('location','eastoutside');
% %--------------------------------------------------------------------------
% patch('Faces',elem(:,1:4),'Vertices',[coord(:,1),coord(:,2)],'FaceColor',...
%       'none','EdgeColor',[1,1,1]*0.75); axis square;
% title(sprintf([smetodo,' p=',num2str(ordem-1),'   PVI = ',num2str(t_old)]));
% %==============================================        
%     else
% subplot('position' ,[0.05 .1 .5 .8]); % Make left subplot
% %pcolor(reshape(S_old,sqrt(size(elem,1)),sqrt(size(elem,1)))'); % Plot saturation
% % [cc, hh]=contourf(linspace(dx/2,1-dx/2,sqrt(size(elem,1))),...
% %    linspace(dy/2,1-dy/2,sqrt(size(elem,1))),...
% % reshape(S_old,sqrt(size(elem,1)),sqrt(size(elem,1))),'ShowText','on');
% %[X,Y,Func]=trifcontour_plot2D(elem,coord,S_old); contourf(X,Y,Func')
% % c=colorbar('location','southoutside');
% %============================================== 
% x_c=centelem(:,1); y_c=centelem(:,2); z_s=S_old;
% %
% xlin=linspace(min(x_c),max(x_c),50); ylin=linspace(min(y_c),max(y_c),50);
% [X,Y]=meshgrid(xlin,ylin); Z=griddata(x_c,y_c,z_s,X,Y,'natural');
% contour(X,Y,Z,'LineWidth',1,'ShowText','on');
% patch('Faces',elem(:,1:4),'Vertices',[coord(:,1),coord(:,2)],'FaceColor',...
%       'none','EdgeColor',[1,1,1]*0.75);
% title(sprintf([smetodo,' p=',num2str(ordem-1),' - Sat. Contours']));
% axis square;
% %==============================================
% %c=colorbar('horiz','Direction','reverse');
% %c.Label.String = 'Water Saturation [-]';
% title(sprintf([smetodo,' p=',num2str(ordem-1),' - Sat. Contours']));
% axis square; %shading flat; %caxis([0 1-0 ]); 
% %Mw = Mw(end); Mo = Mo(end); Mt=Mw+Mo; % Mobilities in well?block
% %Tt=[Tt,VPI(end)]; % Compute simulation time
% %Pc=[Pc,[Mw/Mt; Mo/Mt]]; % Append production data
% %Pc=[Pc,[oilrecovery(end); Mo/Mt]];
% %hold on
% subplot('position' ,[0.65 .1 .3 .8]); % Make right subplot
% %plot(Tt,Pc (1,:),Tt,Pc (2,:),pvi,oil_recovery,'--','LineWidth',1.5); % Plot production data
% %plot(Tt,Pc (1,:),Tt,Pc (2,:),'LineWidth',1.5);
% plot(VPI,oilrecovery,VPI,1-oilrecovery,pvi,oil_recovery,'--','LineWidth',1.5);
% axis ([0, 1,-0.05,1.05]); grid on; grid minor;% Set correct axis
% legend('Water cut','Oil cut','Ref.','Location','Best'); % Set legend [0.6, 0.5, 0.1, 0.05]
% title(sprintf('PVI = %3.4f ',t_old));
% %legend('Water cut','Oil cut','Location','Best');
% %title('Production curves');xlabel('PVI');
%     end
% drawnow; % Force update of plot    
% if strcmp(sml,'on')&& strcmp(mov_,'on'), M(:,Bmovie) = getframe(gcf,rect);  Bmovie=Bmovie+1; end
% end