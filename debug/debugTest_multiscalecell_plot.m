%%creates a matrix with all edges
%%plot multiscale cell
disp('rodando')

%color = ['yellow','magenta','yellow','red','green','white'];
color = ['y', 'm', 'r', 'g', 'w'];
for num = 1: npar
    %ploting mesh
    size(coarseedge{num});
    for i=1:ans(1)
        tc = circshift(color,[0,num]);
        drawLineC(coarseedge{num}(i,1),coarseedge{num}(i,2),coord,tc(1));
    end
    whitebg('black')
    xlim([0 10])
    ylim([0 10])
end