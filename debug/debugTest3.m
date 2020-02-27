%%creates a matrix with all edges coarseedge
global inedge bedge coord
colormat = load('color.dat');

disp('Plotando Coarse Mesh')
figHandle = figure;
figure(figHandle);
set(figHandle, 'Position', [0 0 700 700])
text = num2str(npar);
set(figHandle, 'name', ['Coarse Mesh: ', text ,' coarse cells'],'NumberTitle','off');
%title(['\fontsize{16}black {\color{magenta}magenta '...
%'\color[rgb]{0 .5 .5}teal \color{red}red} black again'])

for num = 1: npar
    %ploting mesh
    pq=size(coarseedge{num});
    for i=1:pq(1)
        tc = colormat(num,:);
        if coarseedge{num}(i,2) == 1
            tmp = bedge(coarseedge{num}(i,1),1:2);
        else
            tmp = inedge(coarseedge{num}(i,1),1:2);
        end
        graf = drawLineC(tmp(1),tmp(2),coord,tc);
        

    end 
    
end

xSize = max(coord(:,1));
ySize = max(coord(:,2));
    title(['Coarse Mesh: ', text ,' coarse cells'],'FontSize', 14)
    whitebg('black')
    xlim([0 xSize])
    ylim([0 ySize])