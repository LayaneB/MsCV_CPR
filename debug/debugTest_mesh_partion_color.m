%%creates a matrix with all edges

disp('rodando')

%color = ['black','yellow','magenta','cyan','red','green','blue','white','black'];
color = ['y', 'm', 'r', 'g', 'b', 'w'];
for num = 1: npar
    ed = zeros(0,2);
    t = size(coarseelem {num});
    for i=1:t(2)
        avec =  elem(coarseelem {num}(i),:);
        if elem(i,4) == 0
            for ix = 1:5
                %ed(end+1,:) = circshift(elem(i,1:3),[ix,0]);
                f = circshift(avec(1:3),[0,ix]);
                ed(end+1,:) = f(1:2);
                %ed = union(ed , f(1:2),'rows');
            end
        else
            for ix = 1:5
                %ed(end+1,:) = circshift(elem(i,1:3),[ix,0]);
                f = circshift(avec(1:4),[0,ix]);
                ed(end+1,:) = f(1:2);
                %ed = union(ed , f(1:2),'rows');
            end
        end
    end

    novo =  unique(ed,'rows');
    %ploting mesh
    size(ed);
    for i=1:ans(1)
        tc = circshift(color,[0,num]);
        drawLineC(ed(i,1),ed(i,2),coord,tc(1));
    end
    whitebg('black')
    xlim([0 10])
    ylim([0 10])
end