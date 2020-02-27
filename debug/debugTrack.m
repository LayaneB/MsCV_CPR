el = 220;

flowType = flowPd;
edges = findallEdges(el);

tt = size(bedge,1);

values = [ edges, flowType(edges+tt)]

disp('ordem de cores antihorario, branco, rosa, amarelo');
drawEdgesC(edges(1),[1 1 1]);
drawEdgesC(edges(2),[1 0 1]);
drawEdgesC(edges(3),[1 1 0]);