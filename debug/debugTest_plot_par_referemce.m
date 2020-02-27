%%creates a matrix with all edges

disp('rodando')

%color = ['yellow','magenta','yellow','red','green','white'];
color = ['y', 'm', 'r', 'g', 'w'];
for num = 1: npar
    %ploting mesh
    pq=size(coarseedge{num});
    for i=1:pq(1)
        tc = circshift(color,[0,num]);
        if coarseedge{num}(i,2) == 1
            tmp = bedge(coarseedge{num}(i,1),1:2)
        else
            tmp = inedge(coarseedge{num}(i,1),1:2);
        end
        drawLineC(tmp(1),tmp(2),coord,tc(1));

    end
    whitebg('black')
    xlim([0 10])
    ylim([0 10])
end