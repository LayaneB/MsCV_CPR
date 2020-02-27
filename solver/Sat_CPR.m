%--------------------------------------------------------------------------
%UNIVERSIDADE FEDERAL DE PERNAMBUCO
%CENTRO DE TECNOLOGIA E GEOCIENCIAS
%PROGRAMA DE POS GRADUACAO EM ENGENHARIA MECANICA
%--------------------------------------------------------------------------
%Subject: numerical routine to solve " NDG or FR/CPR" 2D
%Type of file: MAIN
%Criate date: 27/07/2016
%Modify data: 08/08/2016
%Programer: Gustavo Galindez Ramirez
%with contributions from Manuel Diaz
%--------------------------------------------------------------------------
%Goals:
%Determinate a saturation field to 2D transient problem do flow two phase
%using " NDG or FR/CPR".
%==========================================================================
function [S] = Sat_CPR(S,dt,vx,vy,q,influx,bflux,t_old)
global wells bedge benchmark pormap
Globals2D_CPR; 
%% Solver Loop
res_S = zeros(size(S)); % Runge-Kutta residual storage
t_app = 'RK';
switch t_app
case 'RK'
%% RK45 scheme
for RKs = 1:5    
[RHS] = RHSnon(S,vx,vy,influx,q,bflux);
%==========================================================================
if max(wells)~=0, 
    inj = wells(find(wells(:,2)==1),1); S(:,inj) =  (1+tanh(100*t_old))/2; 
else
in_elm = bedge(find(bedge(:,end)==202),3); %S(1:Nfp,in_elm)=(1+tanh(100*t_old))/2;
end
%==========================================================================
%% five_spot wells
if max(wells)~=0
    for iw=1:size(wells,1)
        well=wells(iw,2);
        if well==1, inj(iw)=wells(iw,1); end
        if well==2
            St=Vnd\S(:,wells(iw,1)); avg=Vnd*St; S_sink=avg(1,1);
            sink= f(S_sink)*q(wells(iw,1));
            RHS(:,wells(iw,1)) = RHS(:,wells(iw,1)) + sink/nN;
        end
    end  
else
    
    fin_elm = find(bedge(:,end)==202)'; idx = 1;
    for i_fin = fin_elm 
    RHS(1:Nfp,in_elm(idx)) = (RHS(1:Nfp,in_elm(idx)) + bflux(i_fin)*ones(Nfp,1)/Nfp);
    idx = idx + 1;
    end
end
%==========================================================================
res_S = rk4a(RKs)*res_S - dt*(RHS)/pormap; %<------- ######### MUDEI AQUI:ACRESCENTEI O "/pormap" ##########
S = S + rk4b(RKs)*res_S; S = MLPv3(S,1); S(S<=1e-16)=0; 
end
case 'Euler'
    [RHS] = RHSnon(S,vx,vy,influx,q,bflux,G);
%==========================================================================
if max(wells)~=0, 
    inj = wells(find(wells(:,2)==1),1); S(:,inj) =  (1+tanh(100*t_old))/2; 
else
in_elm = bedge(find(bedge(:,end)==202),3); %S(1:Nfp,in_elm)=(1+tanh(100*t_old))/2;
end
%==========================================================================
%% five_spot wells
if max(wells)~=0
    for iw=1:size(wells,1)
        well=wells(iw,2);
        if well==1, inj(iw)=wells(iw,1); end
        if well==2
            St=Vnd\S(:,wells(iw,1)); avg=Vnd*St; S_sink=avg(1,1);
            sink= f(S_sink)*q(wells(iw,1));
            RHS(:,wells(iw,1)) = RHS(:,wells(iw,1)) + sink/nN;
        end
    end  
else
    
    fin_elm = find(bedge(:,end)==202)'; idx = 1;
    for i_fin = fin_elm 
    RHS(1:Nfp,in_elm(idx)) = (RHS(1:Nfp,in_elm(idx)) + bflux(i_fin)*ones(Nfp,1)/Nfp);
    idx = idx + 1;
    end
end
%==========================================================================
    S = S - dt*RHS; S = MLPv3(S,1); S(S<=1e-16)=0; 
end 
return
%S = PPlimiter(S);  S = S - dt*RHS; 