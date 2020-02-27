%flow = flowrateTPFA(tEq, Kbedge, p,HL);
%flow = flow( (size(bedge,1)+1):end);


%flowNoEdge = flow(edgesOnCoarseBoundary);

%flowNoEdge2 = flowrateMsTPFA( edgesOnCoarseBoundary,tEq(edgesOnCoarseBoundary), p);

%sum(flowNoEdge == flowNoEdge2')


p = TransF\ F;

%%
[TransFn,Fn] = minusTPFA(edgesOnCoarseBoundary,pc,TransF,F,tEq(edgesOnCoarseBoundary));
pp =  neumanm(TransFn,Fn, coarseelem , edgesOnCoarseBoundary, flowPd,pc );

flowMs = flowrateMsTPFA( edgesOnCoarseBoundary,tEq(edgesOnCoarseBoundary), pd);
flowMs2 = flowrateMsTPFA( edgesOnCoarseBoundary,tEq(edgesOnCoarseBoundary), p);
flowMs3 = flowrateMsTPFA( edgesOnCoarseBoundary,tEq(edgesOnCoarseBoundary), pp);

pp =  neumanm(TransFn,Fn, coarseelem , edgesOnCoarseBoundary, flowMs2,pc );

saveImages('Neumann', '0000-Testes',lastMethod, meshAnal,p,pp)


%   for ii = 1:size(verelem,1)
%      meshplot(elem(verelem(ii),1:4), coord(:,1), coord(:,2),'color',colormat(2,:), 'LineWidth' , 2.1);
%   end