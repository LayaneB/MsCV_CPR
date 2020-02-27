%%creates a matrix with all edges

disp('rodando')

%color = ['yellow','magenta','yellow','red','green','white'];
color = ['y', 'm', 'r', 'g', 'w'];
for index = 1:npar
    tmp = cedgeneigh{:,index};
    stmp = size(tmp);
    for j = 1 : stmp(1)
        drawLineC(tmp(j,1) , tmp(j,2), coord, 'white');
    
    end
    whitebg('black');
    


end

% for num = 1: npar
%     %ploting mesh
%     p = cedgeneigh{num,:};
%     q=size(p);
%    ['num eh igual agora a: ', int2str(num)]
%     for i=1:q(1)
%         tc = circshift(color,[0,num]);
%         drawLineC(p(i,1),p(i,2),coord,tc(1));
%         %a = input('i');
%     end
%     whitebg('black')
%     xlim([0 10])
%     ylim([0 10])
% end