function str_lines(nE,dx,dy,Vnd,vx,vy)
global centelem
Nx = sqrt(nE); Ny=sqrt(nE);
%vx=(2*y-1); vy=(-2*x+1);
%vx=sin(pi*x); vy=-pi*y.*cos(pi*x);
%vx=1*x; vy=0*y;
ut=Vnd\vx; ut(2:end,:)=0; avg=Vnd*ut; u_avg=avg(1,:); 
u=reshape(u_avg,[Nx Ny]);%x-vel average cell
vt=Vnd\vy; vt(2:end,:)=0; avg=Vnd*vt; v_avg=avg(1,:);
v=reshape(v_avg,[Nx Ny]);%y-vel average cell
% Vx=Vnd\vx; u=reshape(0.5*Vx(1,:),[Nx Ny]);%x-vel average cell
% Vy=Vnd\vy; v=reshape(0.5*Vy(1,:),[Nx Ny]);%y-vel average cell
%Make grid and sampling points along diagonal
%[X,Y]=meshgrid((1:Ny)*dy-0.5*dy,(1:Nx)*dx-0.5*dx);
X=reshape(centelem(:,1),[Nx Ny]);
Y=reshape(centelem(:,2),[Nx Ny]);
%meshQuad.plotVertices(pre_CPR.EtoV,pre_CPR.VX,pre_CPR.VY);hold on
quiver(X,Y,u,v,0.9,'Color','m'); axis([0 1 0 1]);%axis square; 
met = 'aut';
switch met
    case 'aut'
sy = linspace(0.5*dy, (Ny-0.5)*dy,20);
sx = (Nx-0.5)*dx/((Ny-0.5)*dy)*((Ny-0.5)*dy - sy);
hp=streamline(X,Y,u,v,sx,sy); hn=streamline(X,Y,-u,-v,sx,sy);
set([hp,hn],'Color',[1,1,1]*0.9,'LineWidth',1);
    case 'man'
p0=ginput(10); 
x0=p0(:,1); y0=p0(:,2); 
hp=streamline(X,Y,u,v,x0,y0); 
hn=streamline(X,Y,-u,-v,x0,y0);
set([hp,hn],'Color',[1,1,1]*0.9,'LineWidth',1); %plot(x0,y0,'w.','markersize',14);
end
title('Vel. field and streamlines')

