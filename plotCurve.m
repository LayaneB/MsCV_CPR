superFolder = strcat(pwd,'/Results/');
FOLD = dir(superFolder);
LEN = size(FOLD,1);
%     fprintf(fid3,'%13.3e %13.3e %13.3e %13.3e \n',VPI(cont), ...
%         oilrecovery(cont),cumulateoil(cont),watercut(cont));
grafCases = {'VPI', 'Oil Recovery', 'Cumulative Oil', 'Water Cut'};
disp('Select the Case to Plot the Productions Curves')
for ii = 3:LEN
    if FOLD(ii).isdir
        text = sprintf('(%d): %s | on %s ',ii-2,FOLD(ii).name,FOLD(ii).date);
        disp(text);
    end
end
flag = input('Enter the Case Number: ') + 2;
typeCase = FOLD(flag).name;
pointMs = strcat(superFolder,typeCase, '/CurveMs.dat');
pointOr = strcat(superFolder,typeCase, '/CurveOriginal.dat');
matMs = load(pointMs);
matOr = load(pointOr);

%%ploting all curves together
figHandle = figure;
figure(figHandle);
set(figHandle, 'Position', [0 0 500 1000])
set(figHandle, 'name', ['Production Curves'],'NumberTitle','off');
%title(['\fontsize{16}black {\color{magenta}magenta '...
whitebg('white')

subplot(3,1,1)

plot(matMs(:,1),matMs(:,2),'.-','DisplayName','MsCV','color',[0 0.2969 0.5977],'LineWidth',2.5)
hold on
plot(matOr(:,1),matOr(:,2),'--','DisplayName','Reference Solution','color',[0.782 0 0.3],'LineWidth',2.5)
legend('show')
xlim([0 min([max(matMs(:,1)); max(matOr(:,1)) ]) ])
title(grafCases{2},'FontSize', 15)
%xlabel(grafCases{1})
xlabel('PVI - Porous Volume Injected','FontSize',10,'FontWeight','normal','Color',[0 0 0])

grid on
subplot(3,1,2)
%plot(matMs(:,1),matMs(:,3))

plot(matMs(:,1),matMs(:,3),'.-','DisplayName','MsCV','color',[0 0.2969 0.5977],'LineWidth',2.5)
hold on
plot(matOr(:,1),matOr(:,3),'--','DisplayName','Reference Solution','color',[0.782 0 0.3],'LineWidth',2.5)
grid on
legend('show','Location','southeast')
title(grafCases{3},'FontSize', 15)
xlabel('PVI - Porous Volume Injected','FontSize',10,'FontWeight','normal','Color',[0 0 0])
xlim([0 min([max(matMs(:,1)); max(matOr(:,1)) ]) ])
subplot(3,1,3)
%plot(matMs(:,1),matMs(:,4))
plot(matMs(:,1),matMs(:,4),'.-','DisplayName','MsCV','color',[0 0.2969 0.5977],'LineWidth',2.5)
hold on
plot(matOr(:,1),matOr(:,4),'--','DisplayName','Reference Solution','color',[0.782 0 0.3],'LineWidth',2.5)
grid on
title(grafCases{4},'FontSize', 15)
xlabel('PVI - Porous Volume Injected','FontSize',10,'FontWeight','normal','Color',[0 0 0])
xlim([0 min([max(matMs(:,1)); max(matOr(:,1)) ]) ])
legend('show','Location','southeast')
