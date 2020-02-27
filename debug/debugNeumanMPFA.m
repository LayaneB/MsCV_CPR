%flow = flowrateTPFA(tEq, Kbedge, p,HL);
%flow = flow( (size(bedge,1)+1):end);


%flowNoEdge = flow(edgesOnCoarseBoundary);

%flowNoEdge2 = flowrateMsTPFA( edgesOnCoarseBoundary,tEq(edgesOnCoarseBoundary), p);

%sum(flowNoEdge == flowNoEdge2')



%%

[flowPd2, flowresultPd,velocityPd]=flowrateMPFAD(pd,w,s,Kde,Ded,Kn,Kt,Hesq,nflagno,auxflag);

flowPd = flowPd2( edgesOnCoarseBoundary + size(bedge,1));
pp =  neumanm(TransFn,Fn, coarseelem , edgesOnCoarseBoundary, flowPd,pc );
[flowPp, flowresult,velocity]=flowrateMPFAD(pp,w,s,Kde,Ded,Kn,Kt,Hesq,nflagno,auxflag);

flowPms = compoundFlow( flowPp,flowPd,size(bedge,1) );


saveImages('Neumann', '00-TesteNovos',lastMethod, meshAnal,p,pp)

%   for ii = 1:size(verelem,1)
%      meshplot(elem(verelem(ii),1:4), coord(:,1), coord(:,2),'color',colormat(2,:), 'LineWidth' , 2.1);
%   end