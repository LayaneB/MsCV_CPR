function u = MLPv3(uc,ATj)
% Arrange input data
Globals2D_CPR; tol = eps;
u=zeros(nN,nE); u(:,:)=uc;
%% ut: modal coefficients
ut=Vnd\u;
%%  step 1 - cell averages
ut_00=ut; ut_00(2:end,:)=0; uavg=Vnd*ut_00; s_avg=uavg(1,:);
% total elements
n = (P+1)*(P+1);
if P==3
    %% P3 Projection
    ver_pos=[1 13 16 4];
    % Projection on the vertex
    ut2=ut; ut2(P+1:P+1:n,:)=0; ut2((P+1)*P+1:n-1,:)=0; P2_proj=Vnd*ut2;
    % P3j mode
    P3j = u - P2_proj;
    % Projection on the vertex
    ut1=ut;
    ut1(P+1:P+1:n,:)=0; ut1((P+1)*P+1:n-1,:)=0;
    ut1([3 7 11 10 9],:)=0;
    P1_proj=Vnd*ut1;
    % P2j mode
    P2j=P2_proj-P1_proj;
    % Projection on the vertex
    ut0=ut; ut0((P-1):n,:)=0; P0_proj=Vnd*ut0;
    % P1j mode
    P1j=P1_proj-P0_proj;
elseif P==2
    ver_pos=[1 7 9 3];
    %% P2 Projection
    P3j = zeros(nN,nE);
    % Projection on the vertex
    ut1=ut; ut1(P+1:P+1:n,:)=0; ut1((P+1)*P+1:n-1,:)=0; P1_proj=Vnd*ut1;
    % P2j mode
    P2j=u-P1_proj;
    % Projection on the vertex
    ut0=ut; ut0(P:n,:)=0; P0_proj=Vnd*ut0;
    % P1j mode
    P1j=P1_proj-P0_proj;
elseif P==1
    ver_pos=[1 3 4 2];
    %% P1 Projection
    P3j = zeros(nN,nE);
    % P2j mode
    P2j = zeros(nN,nE);
    % Projection on the vertex
    ut0=ut; ut0(P+1:P+1:n,:)=0; ut0((P+1)*P+1:n-1,:)=0;  P0_proj=Vnd*ut0;
    % P1j mode
    P1j = u-P0_proj;
end
%global bedge; nod_bound = unique(bedge(:,1:2));
%% Principal loop
for e=1:nE% n Cells
    viTj = EToV(e,:);
    ind_v=1; umin=[]; umax=[];
    for j=viTj%Vertex
        %ind_Svi_bound=find(nod_bound==j);
        %if size(ind_Svi_bound,1)==0%IF node boundary
        Svi = getsurnode(j);
        umin(ind_v) = min(s_avg(Svi)); umax(ind_v) = max(s_avg(Svi));
               
        qhk = [];
        for ind_Svi = 1:length(Svi)%Cell that belongs to Svi
            ind_ver_Tk  = find(EToV(Svi(ind_Svi),:)==j);%Vertex on cell Tk
            qhk(ind_Svi)=u(ver_pos(ind_ver_Tk),Svi(ind_Svi));%Value at vertex vi via a Pn approx. on Tk   
        end
        qhk_min (ind_v) = min(qhk);   qhk_max (ind_v) = max(qhk);
        ind_v = ind_v + 1;
        %end %END node boundary
    end
    
    if P==1
        phi_mlpu= limiter(e,P1j,umax,umin,s_avg, ver_pos,tol);
        u(:,e) = s_avg(e) + phi_mlpu*P1j(:,e) + P2j(:,e) + P3j(:,e);
    elseif P==2
        fi = trb_cell(e, P1_proj, umax, umin, ver_pos, qhk_min, qhk_max,tol);
        v_phi = min(fi);
        v_phi2 = v_phi;
if v_phi2 == 1, phi_mlpu=1; else phi_mlpu= limiter(e,P1j,umax,umin,s_avg,ver_pos,tol); end        
%         if v_phi2 == 1,
%             phi_mlpu=1;
%         else
%             fi2 = Smooth_extrema(e, P1_proj, umax, umin,ver_pos, s_avg, u, ATj);
%             v_phi = min(fi2);
%             v_phi2 = v_phi;
%             if v_phi2 == 1, phi_mlpu=1; else phi_mlpu= limiter(e,P1j,umax,umin,s_avg,ver_pos);  end
%         end
        u(:,e) = s_avg(e) + phi_mlpu*P1j(:,e) + v_phi2*P2j(:,e) + P3j(:,e);
    elseif P==3
        fi = trb_cell(e, P1_proj, umax, umin, ver_pos,qhk_min, qhk_max,tol);
        v_phi = min(fi);
        v_phi3 = v_phi;
        if v_phi3 == 1
            phi_mlpu=1; v_phi2 = 1;
        else
            
%             fi2 = Smooth_extrema(e, P1_proj, umax, umin,ver_pos, s_avg, u, ATj);
%             v_phi = min(fi2); v_phi3 = v_phi;
%             if v_phi3 == 1
%                 phi_mlpu=1; v_phi2 = 1;
            %else
                u_h=ut; u_h(P+1:P+1:n,:)=0; u_h((P+1)*P+1:n-1,:)=0; u_h1=Vnd*u_h;
                fi_h = trb_cell(e, u_h1, umax, umin, ver_pos, qhk_min, qhk_max,tol);
                v_phi2 = min(fi_h);
                if v_phi2 == 1, phi_mlpu=1; else phi_mlpu= limiter(e,P1j,umax,umin,s_avg,ver_pos,tol); end
            %end
        end
        u(:,e) = s_avg(e) + phi_mlpu*P1j(:,e) + v_phi2*P2j(:,e) + v_phi3*P3j(:,e);
    end
end
end

function phi_mlpu= limiter(e,P1j,umax,umin,s_avg,ver_pos,tol)
%% MLPu limiter
mlpu = zeros(1,4);
for p=1:size(umax,2)
    rate=max((umin(p)-s_avg(e))/(P1j(ver_pos(p),e)+tol),(umax(p)-s_avg(e))/(P1j(ver_pos(p),e))+tol);
    C1 = (abs(P1j(ver_pos(p),e))>tol) || (abs(P1j(ver_pos(p),e)-tol)<tol);
    C2 = abs(P1j(ver_pos(p),e))<tol;
    if C1==1, mlpu(p)= min(1,rate)*C1; else mlpu(p)= C2; end
end
phi_mlpu = min(mlpu);
end

function fi = trb_cell(e, P1_proj, umax, umin,ver_pos,qhk_min,qhk_max,tol)
%% apply the P1-projected MLP condition
fi = zeros(1,4);
for j=1:size(umax,2)
    marker='aug';
    switch marker
        case 'P1'
            mlp_cond=((P1_proj(ver_pos(j),e)<umax(j)) || (P1_proj(ver_pos(j),e)-umax(j))<tol)...
                && ((P1_proj(ver_pos(j),e)> umin(j)) || (P1_proj(ver_pos(j),e)- umin(j))<tol);
            if mlp_cond == 1,  fi(j) = 1; else fi(j) = 0; end
        case 'aug'
            
            if(umin(j)<qhk_min(j)||abs(umin(j)-qhk_min(j))<tol) && (qhk_max(j)<umax(j) || abs(qhk_max(j)-umax(j))<tol)
                fi(j)=1; else fi(j)=0; end
    end
end
end

function phi2 = Smooth_extrema(i, P1_proj, qvi_max, qvi_min,ver_pos, sj_ave, u, ATj,tol)
qj_ave = sj_ave(i); phi2 = zeros(1,4);
for j=1:size(umax,2)% SSD vertex
    % Smooth extrema detector
    qj_ext = qj_ave + (P1_proj(ver_pos(j),i)-qj_ave)+(u(ver_pos(j),i)-P1_proj(ver_pos(j),i));
    
    C1 = ((P1_proj(ver_pos(j),i)-qj_ave)>tol && (qj_ext-P1_proj(ver_pos(j),i))<tol) || qj_ext > qvi_min(j);
    
    C2 = ((P1_proj(ver_pos(j),i)-qj_ave)<tol && (qj_ext-P1_proj(ver_pos(j),i))>tol) || qj_ext < qvi_max(j);
    
    C3 = abs(qj_ext-qj_ave)<max(1E-3*abs(qj_ave),ATj(i))||abs(abs(qj_ext-qj_ave)-max(1E-3*abs(qj_ave),ATj(i)))<tol;
    
    if (C1==1 && C2==1) || C3 == 1, phi2(j)=1; else phi2(j)=0; end
end%END SSD vertex
end

