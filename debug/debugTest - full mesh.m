%%creates a matrix with all edges

size(elem);
disp('rodando')
ed = zeros(0,2);
for i=1:ans(1)
    if elem(i,4) == 0
        for ix = 1:5
            %ed(end+1,:) = circshift(elem(i,1:3),[ix,0]);
            f = circshift(elem(i,1:3),[0,ix]);
            ed(end+1,:) = f(1:2);
            %ed = union(ed , f(1:2),'rows');
        end
    else
        for ix = 1:5
            %ed(end+1,:) = circshift(elem(i,1:3),[ix,0]);
            f = circshift(elem(i,1:4),[0,ix]);
            ed(end+1,:) = f(1:2);
            %ed = union(ed , f(1:2),'rows');
        end
    end
end

novo =  unique(ed,'rows');
%ploting
size(ed);
for i=1:ans(1)
    drawLine(ed(i,1),ed(i,2),coord);
end