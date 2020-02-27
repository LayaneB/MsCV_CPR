function [vx,vy]=vel_field_Piola(bflux,in_flux)
global inedge elem coord bedge
Globals2D_CPR;
%influx = [bflux;in_flux];
%Flux per cell
F = zeros(nN,size(elem,1)); G = zeros(size(elem,2)-1,size(elem,1));
for iface_int = 1:size(inedge,1)       
    left = inedge(iface_int,3);   
    right = inedge(iface_int,4);
    %edge_size=norm(coord(inedge(iface_int,1),:)-coord(inedge(iface_int,2),:));
    pos_r=EToF(left,find(EToE(left,:)==right));%pos edge right cell
    pos_l=EToF(right,find(EToE(right,:)==left));%pos edge left cell
    q_p=in_flux(iface_int);
    F(pos_l,left) = q_p; G(pos_l,left) = in_flux(iface_int);
    q_m = -in_flux(iface_int);
    F(pos_r,right) = q_m; G(pos_r,right) = in_flux(iface_int);  
end
%==========================================================================
%% Out (COMENTEI ESSA FUNÇÃO AQUI)
% out_= bflux(find(bedge(:,end)==101));
% out_elm = bedge(find(bedge(:,end)==101),3);
% for i_out = 1:size(out_,1)   
%     F(2,out_elm(i_out)) = out_(i_out);
% end
%% In (COMENTEI ESSA FUNÇÃO AQUI)
% in_= bflux(find(bedge(:,end)==202));
% in_elm = bedge(find(bedge(:,end)==202),3);
% for i_in = 1:size(in_,1)   
%     F(4,in_elm(i_in)) = in_(i_in);
% end
%==========================================================================
% for m=1:size(elem,1)% Element of primal mesh
%     n=1; path_cell=[EToV(m,:) EToV(m,1)];
%     for k = EToE(m,:)%neighbor element
%         if k==m% face on boundary
%             %ind_1=[EToV(m,:) EToV(m,1)];%nodes on cell
%             ind_2=path_cell(n:n+1);%nodes on face
%             ind_3=find(bedge(:,3)==m);%ind edgeflux on domain boundary
%             for ii=1:size(ind_3,1)
%                 ind_4 = sum(bedge(ind_3(ii),1:2)==ind_2);
%                 if ind_4 == 2
%                     F(n,m)= influx(ind_3(ii));
%                     n=n+1;
%                 end
%             end
%             
%         else
%             
%             ind2=[path_cell(n) path_cell(n+1)];
%             loc=inedge(:,1:2);
%             loc1=kron(ind2, ones(size(inedge,1),1));
%             loc2=(loc == loc1);loc3=loc2(:,1).*loc2(:,2); loc4=find(loc3==1);
%             sigma=1;
%             if size(loc4,1) == 0
%                 loc1_inv=kron(fliplr(ind2), ones(size(inedge,1),1));
%                 loc2=(loc == loc1_inv);loc3=loc2(:,1).*loc2(:,2); loc4=find(loc3==1);
%                 sigma=-1;
%             end
%             F(n,m)= in_flux(loc4)*sigma;
%             n=n+1;
%         end
%     end
% end
%Set velocity total functions on Reference space
vx=zeros(size(x));vy=zeros(size(y));
%kxi_g = [-1 1 1 -1]'; eta_g = [-1 -1 1 1]';
for i = 1: size(elem,1)
%% Nodes on P
x1=coord(elem(i,1),1); x2=coord(elem(i,2),1); x3=coord(elem(i,3),1); x4=coord(elem(i,4),1);
y1=coord(elem(i,1),2); y2=coord(elem(i,2),2); y3=coord(elem(i,3),2); y4=coord(elem(i,4),2);
for j=1:size(kxi,1)
%% Jacobi matrix
D=[0.25*(x2-x1)*(1-eta(j))+0.25*(x3-x4)*(1+eta(j)) 0.25*(x4-x1)*(1-kxi(j))+0.25*(x3-x2)*(1+kxi(j));
   0.25*(y2-y1)*(1-eta(j))+0.25*(y3-y4)*(1+eta(j)) 0.25*(y4-y1)*(1-kxi(j))+0.25*(y3-y2)*(1+kxi(j))];
%% Jacobi determinant
J=det(D);
%end
    %for k=1: size(kxi,1)
        %% x-flux
        Fx0 = F(4,i); Fx1 = F(2,i);
        %% x-velocity field on R
        vkxi= -0.25*Fx0*(1-kxi(j))+0.25*Fx1*(1+kxi(j));
        %% y-flux
        Fy0 = F(1,i); Fy1 = F(3,i);
        %% y-velocity field on R
        veta= -0.25*Fy0*(1-eta(j))+0.25*Fy1*(1+eta(j));
        %% velocity field on P
        v=(1/J)*D*[vkxi;veta];
%         k = [1 3 4 2];
%         vx(k(j),i) = v(1); vy(k(j),i) = v(2);
        vx(j,i) = v(1); vy(j,i) = v(2);
end
end
return
