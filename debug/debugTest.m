%%creates a matrix with all edges
%%plot multiscale cell
disp('rodando')

%color = ['yellow','magenta','yellow','red','green','white'];
color = ['y', 'm', 'r', 'g', 'w'];
num = 1

%ploting mesh
tmp = cedgeneigh{num,:}
stmp = size(tmp)

for i=1:stmp(1)
    tc = circshift(color,[0,num]);
    drawLineC(tmp(i,1),tmp(i,2),coord,'green');
end
whitebg('black')
xlim([0 10])
ylim([0 10])
clear tmp stmp