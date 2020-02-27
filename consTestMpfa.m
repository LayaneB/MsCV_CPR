nflagno = nflag;
% disp('Problema Original MPFA');
% [flow, flowresult,velocity] = calflowrateMPFAD(p,w,s,Kde,Ded,Kn,Kt,Hesq,nflagno,auxflag,mobility);
% save2 = fluxSummation(flow);
% a1 = sum(save2 < 0.00000001) / size(save2,1);
% b1 = abs(save2) > 0.00000001;


% % disp('Pd')
% [flow3, flowresult3,velocity3] = calflowrateMPFAD(pd,w,s,Kde,Ded,Kn,Kt,Hesq,nflagno,auxflag,mobility);
% save3 = fluxSummation(flow3);
% sum(abs(save3) < 0.00000001) / size(save3,1);
% b2 = abs(save3) > 0.00000001;
% % disp('Pp')
% [flow4, flowresult4,velocity4] = flowrateMPFAD(pp,w,s,Kde,Ded,Kn,Kt,Hesq,nflagno,auxflag,mobility);
% save4 = fluxSummation(flow4);
% %sum(abs(save4) < 0.000000000001) / size(save4,1)
% a3 = sum(abs(save4) < 0.000000000001) / size(save4,1);
% b3 = abs(save4) > 0.00000001;

% disp('Pms')
save5 = fluxSummation(flowPms);
% 
disp('flux conservation')
a2 = sum(abs(save5) < 0.00000001) / size(save5,1)
b2 = abs(save5) > 0.00000001;


% % disp('-- FlowPP -- ')
% 
save6 = fluxSummation(flowPp);
a3 = sum(abs(save6) < 0.000000000001) / size(save6,1);
b3 = abs(save6) > 0.00000001;



%sprintf('Problema Original: %f \nProblema MultiEscala: %f \nFluxo dentro do coarse: %f',a1,a2,a3)

%sprintf('Problema MultiEscala: %f \nFluxo dentro do coarse: %f',a2,a3)

% b
% [influx,vel,bflux]=flow_velocity(p,coord,bedge,inedge,centelem,bcflag,elem,kmap);
% flow2 = [bflux ; influx];
% 
% save3 = fluxSummation(flow2);
% sum(save3 < 0.00000001) / size(save3,1)
