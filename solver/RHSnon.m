function [RHS] = RHSnon(u,vx,vy,influx,q,bflux)
Globals2D_CPR; global inedge coord wells bedge auxflag;
%% Jumps at elements faces
uI = zeros(npf,nE); uI(:) = u(map.vM); 
uO = zeros(npf,nE); uO(:) = u(map.vP); 
du = zeros(npf,nE); du(:) = uI-uO;
%% Apply BCs
%map_W = find(bnodes==201);
%uI(map_W) = uO(map_W);  
% map_In = find(bnodes==202);
% uI(map_In) = 1;
%% Jumps at elements faces by Lax-Friedrichs flux
dvx = zeros(npf,nE); dvx(:) = vx(map.vM);
dvy = zeros(npf,nE); dvy(:) = vy(map.vM);
%nm = kron(sign(G(1:end,:)), ones(Nfp,1));
% Jumps at elements faces by Lax-Friedrichs flux
% method = 'LF';
% switch method
%     case 'NDG' % by Hestaven and Warburton ref.[1]
%         alpha = 0.5; % alpha = 0; upwind,  alpha = 1; central flux.
%         flux = (dvx.*nx-(1-alpha)*abs(dvx.*nx)).*du/2 + ...
%                (dvy.*ny-(1-alpha)*abs(dvy.*ny)).*du/2;
%     case 'LF' % by Lax Friedrichs flux splitting
%         flux = nx.*(dvx.*du)/2-abs(dvx.*nx).*du/2 +...
%                ny.*(dvy.*du)/2-abs(dvy.*ny).*du/2;
% end
int_avg = (min(uI(:),uO(:)) + max(uI(:),uO(:)))/2;
beta = zeros(npf,nE); beta(:) = df(int_avg);
flux = nx.*(f(uI).*dvx - f(uO).*dvx)/2-abs(beta.*dvx.*nx).*du/2 + ...
       ny.*(f(uI).*dvy - f(uO).*dvy)/2-abs(beta.*dvy.*ny).*du/2;

%% Compute Divergence of q
Divq = rx.*(Dr*f(u)).*vx + sx.*(Ds*f(u)).*vx + ...
                                    ry.*(Dr*f(u)).*vy + sy.*(Ds*f(u)).*vy;
%% Compute RHS for the semi-discrete PDE
RHS = Divq + LIFT*(Fscale.*flux);
return