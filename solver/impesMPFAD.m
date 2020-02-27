%% IMPES
% Implicit Pressure , Explicit Saturation
%vpi_vec = [ 0.1 0.4 0.5 0.9 1];
global elem coord inedge pormap elemarea bedge centelem smetodo CFL ordem; Globals2D_CPR; 

%% Saturation Preprocessor 
[N,Fo,V,S_old,S_cont]=presaturation(wells);
%%Calculating Fixed Parameters
[Hesq, Kde, Kn, Kt, Ded] = Kde_Ded_Kt_Kn(kmap);
fonte=0;
nflagno= contflagnoN(bedge);
%[w,s]=Pre_LPEW_2(kmap,N);
%Initializing IMPES variables
cont = 1;
vpi_old = 0;
clear VPI
VPI(1) = 0;
cumulateoil(1) = 0;
oilrecovery(1) = 1;
watercut(1) = 0;
vpi = totaltime(2);
t_old = 0;
step=0;
time2=0;
S = ones(nN,nE)*1e-6;
%% exponente das permeabilidades relativas cuidado...! 
nw=2;
no=2;
%% fractional flow function
% f = @(w) w.^2./(w.^2 + 0.25*(1 - w).^2);
% df = @(w) (2.*w)./((w - 1).^2./4 + w.^2) - (w.^2.*((5.*w)./2 - 1./2))./((w - 1).^2./4 + w.^2).^2;
%==========================================================================
syms w 
krw = ((w - satlimit(1))/(1-satlimit(1)-satlimit(2)))^nw; 
kro= ((1 - w - satlimit(1))/(1-satlimit(1)-satlimit(2)))^no;
Ff= (krw/visc(1))/(krw/visc(1) + kro/visc(2));  Fdf= diff(Ff,1);
if strcmp(test,'five_spot_goe')||strcmp(test,'five_spot_Nikit_'), Ff = w^2; Fdf = 2*w; end
f = inline(vectorize(simplify(Ff))); df= inline(vectorize(simplify(Fdf))); 
%==========================================================================
%% Select Solution Method
switch smetodo
    case 'NDG'
        % Build Lift Operator
        [LIFT] = DGtoolsQuad.lift(NDG);
    case {'fr','cpr'}
        dg = CorrectionPolynomial('DGRight',P,pre_CPR.solutionPoints);
        % Build Lift Operator
        LIFT = DGtoolsQuad.liftFR(pre_CPR,dg);
end
%% este flag só use quando o problema ï¿½ Buckley-Leverett com fluxo imposto
% na face com flag 202, porï¿½m a saturaï¿½ï¿½o serï¿½ imposto na face
auxflag=[0];
OP_old = -1;
%debugTest3
count = 0;  iplotfc=0; tic; z = 1;
while vpi_old < vpi %true
    step = step +1;
%   pause
%     if mod(cont,40) == 0
%        1+1
%        %debugTest3
%     end
    [mobility] = mobilityface(S_old,nw,no,auxflag,S_cont);
%     mobility = ones(size(mobility));
%% ============================== Escolha do solver de pressão ====================================
   if strcmp(multiscale, 'off')
       % Solver de pressão sem Multiescala
       [p,errorelativo,flowrate,flowresult]=solverpressure(kmap,fonte,...
           mobility,wells,S_old,V,nw,no,N,auxflag,Hesq, Kde, Kn, Kt, Ded,nflagno);
   else
       % Solver de pressão Multiescala
       [p,errorelativo,flowrate,flowresult,OP_old,b2,b3,tempo,v]=solverpressureMsMPFAD_Smoother(kmap,fonte,...
           mobility,wells,S_old,V,nw,no,N,auxflag,Hesq, Kde, Kn, Kt, Ded,nflagno,OP_old,S_cont);
%        pref = load('REF_P');
%        Linf(z,1) = max(abs(pref.REF_P-p))/max(abs(pref.REF_P)); L1(z,1) = sum(abs(pref.REF_P-p))/sum(abs(pref.REF_P)); L2(z,1) = sqrt(sum((pref.REF_P-p).^2))/sqrt(sum((pref.REF_P).^2));
       tsuav(z) = tempo; iter(z) = v;  
       z = z+1;
   end
%==================================================================================================
    %% calculo do fluxo fracional em cada elemento da malha
    f_elem = fractionalflow(S_old,nw,no);
    %% vazões
     bflux = flowrate(1:size(bedge,1));
     influx = flowrate(size(bedge,1)+1:end);
    % Balanço de fluxo (verifica conservação)
     q = totalflow(influx,bflux); 
    
    %% caculo do passo de tempo
    % order sempre = 1
    if strcmp(smetodo,'FOU')
        ordem = 1;
    end
    d_t=steptime(f_elem,S_old,flowrate,CFL,S_cont,auxflag,nw,no,ordem); %,order);
   %d_t=timestep2(S_old,influx,bflux,CFL,nw,no,inedge,bedge);
    %% calculo da saturação explicito
    %nao usar - isso
    %esuel1 weightLS,bound,upsilon,kappa, smetodo,tordem,
%     S_old=solversaturation(S_old,flowrate,d_t,esuel1,wells,flowresult,...
%         f_elem,S_cont,weightLS,bound,smetodo,tordem,...
%         upsilon,kappa,nw,no,auxflag);

%% ==============================================================================================
%          As mudanças foram feitas a partir daqui (inclusão do solver de saturação CPR)
        if strcmp(smetodo, 'cpr')
       [vx,vy]=vel_field_Piola(bflux,influx); press=full(p); 
        end
        
%===================== plot do campo de pressão e de velocidades =====================
        if step == 1
            figure;trifcontour_plot2D(elem,coord,press); hold on;
            c=colorbar('horiz','Direction','reverse'); c.Label.String = 'Pressão';
            ut=Vnd\vx; ut(2:end,:)=0; avg=Vnd*ut; u_avg=avg(1,:);
            vt=Vnd\vy; vt(2:end,:)=0; avg=Vnd*vt; v_avg=avg(1,:);
            quiver(centelem(:,1)',centelem(:,2)',u_avg,v_avg,0.9,'Color',[1,1,1]*0.1);
%             axis([coord(1,1) coord(2,1) coord(4,1) coord(4,2)])
            axis([0 1 0 1])
            title('Campos de velocidade e pressão')           
            hold off; %pause;
            
        end
%figure;trifcontour_plot2D(elem,coord,press); hold on; quiver(x,y,vx,vy,'r'), hold off, axis image
%figure;trifcontour_plot2D(elem,coord,press); hold on; str_lines(nE,dx,dy,Vnd,vx,vy);
%=====================================================================================
if strcmp(smetodo,'FOU')
    
    [S_old]= firstorderstandard(S_old,flowrate,flowresult,f_elem,d_t,wells,S_cont,auxflag,nw,no);
    
elseif strcmp(smetodo,'cpr')
    
            [S]=Sat_CPR(S,d_t,vx,vy,q,influx,bflux,t_old); 
            % Saturação média da célula 
            St = Vnd\S; St(2:end,:) = 0; avg = Vnd*St; S_old = avg(1,:);   
end


%        firstorderstandard2(S_old,influx,q,f_elem,dt,wells,S_cont,nw,no,auxflag,bflux)
       
% =========================== Mudanças acabam aqui =======================
%%
%        [S_old]= firstorderstandard2(S_old,influx,q,f_elem,d_t,wells,S_cont,nw,no,auxflag,bflux);
%        [S_old]= firstorderstandard2(S_old,influx,flowresult,f_elem,d_t,wells,S_cont,nw,no,auxflag,bflux);
%        bflux = flowrate(1:size(bedge,1));
%        influx = flowrate(size(bedge,1)+1:end);
%        [S_old,d_t] = firstorderstdseqimp(S_old,influx,bflux,d_t,wells,flowresult,nw,no);
%        [S_old] = firstorderstdseqimpT(S_old,influx,bflux,d_t,wells,flowresult,nw,no,elem,bedge,inedge,elemarea,pormap);

X = sprintf('Calculo do campo de saturação pelo método: %s\nPasso de tempo: %d\n ---------------------------------',smetodo,cont);
disp(X)
        
    
%% ==================== reporte de produção =====================================
    [VPI,oilrecovery,cumulateoil,watercut]=reportproduction(S_old,...
        wells,f_elem,cont,VPI,oilrecovery,cumulateoil,watercut,flowresult,d_t);
    
%% ========= Cálculo do passo de vpi ou passo de tempo =======
    t_old = VPI(cont);
    vpi_old = VPI(cont);
    % ================= Do twophase ======================
% %     if max(wells==0)
% %         Correction for final time step
% %         if t_old+d_t>totaltime(2)
% %             d_t=totaltime(2)-t_old; t_old = totaltime(2);
% %         end
% %         
% %         vpi_old=(1*t_old)/sum(elemarea);
% %     else
% %         if oilrecovery(cont)< 0.985
% %             break;
% %         end
% %         vpi_old=VPI(cont);
% %     end
    % ======================================================
% ============================ Visualização - Artur ================================= 

    dlmwrite(strcat(superFolder,'/msTimestep.dat'),vpi_old,'delimiter', ' ','-append');
    
    if vpi_old >= time2
        dlmwrite(strcat(superFolder,'/msVPIsnap.dat'),vpi_old,'delimiter', ' ','-append');
        step = 1000*time2;
%         postprocessorTMS_2(u_avg,v_avg,full(p),full(S_old),step,superFolder, 'MultiescalaHexagonal');
        postprocessorTMS(full(p),full(S_old),step,superFolder, 'MultiescalaHexagonal');
        time2 = time2 + 0.01;
    end

    if ~isempty(vpi_vec)
        if isEqualTol(vpi_old, vpi_vec(1),0.005)
            dlmwrite(strcat(superFolder,'/msVPI.dat'),vpi_old,'delimiter', ' ','-append');
            vpi_vec = vpi_vec(2:end);
            %saveMs;
        end
    end
    
%=============== armezena a prodção em arquivo .dat =======================
   fprintf(fid4,'%13.3e %13.3e %13.3e %13.3e \n',VPI(cont), ...
   oilrecovery(cont),cumulateoil(cont),watercut(cont));
%% mudei aqui  (foi Artur)
   % vpi_old = 1e+40;
   % postprocessor(p,S_old,cont+1)
   % postprocessorT(full(p),full(S_old),cont);
   % postprocessorT1(full(b3),full(b2),cont);
    cont=cont+1;
    S_cont;
    %% visualization (Layane)
%=============================== Campo de saturação com o tempo ===================================    
    time3=0;
    if strcmp(sml,'on')&& strcmp(mov_,'on'),Bmovie=1; rect = get(gcf,'Position'); rect(1:2) = [0 0]; end
    if strcmp(sml,'on')
        n_frames = 100; normk=0;
        if vpi_old > time3 || abs(vpi_old - time3)<1e-12
            %--------------------------------------------------------------------------

            CPUtime=toc; Time= CPUtime/60;
            graphics_(benchmark2,centelem,elem,coord,VPI,oilrecovery,S_old,...
                smetodo,ordem,t_old,pvi,oil_recovery,step,vx,vy,Time);
            if strcmp(mov_,'on'), M(:,Bmovie) = getframe(gcf,rect);  Bmovie=Bmovie+1; end
           % --------------------------------------------------------------------------
            time3 = time3 + 1/n_frames;
        end
    end
    
% ======================== Apresenta os valores de min e max da Saturação ======================    
    if strcmp(smetodo,'cpr')
        S_max = max(max(S)); S_min = min(min(S));
        dispstat(sprintf('S_max = %f \nS_min = %0.5e \nPVI = %3.4f',S_max, S_min,t_old));
    else
        S_max = max(S_old); S_min = min(S_old);
        dispstat(sprintf('S_max = %f \nS_min = %0.5e \nPVI = %3.4f',S_max, S_min,t_old));
    end
%     if step>1,fprintf(1,repmat('\b',1,count));count = fprintf('\nElapsed time = %3.4f',t_old);end

% ================== plot filled contours at the midpoints of the grid cells =====================
        if strcmp(plotfc,'on')
            if abs((t_old-0.15))<10^-2 | abs((t_old-0.3))<10^-2 | abs((t_old-0.44))<10^-2
                 iplotfc = iplotfc+1; CPUtime = toc; Time = CPUtime/60;
                dx = 1/sqrt(size(elem,1)); dy = 1/sqrt(size(elem,1));
                figure(iplotfc); [cc, hh]=contourf(linspace(dx/2,1-dx/2,sqrt(size(elem,1))),...
                    linspace(dy/2,1-dy/2,sqrt(size(elem,1))),...
                    reshape(S_old,sqrt(size(elem,1)),sqrt(size(elem,1))),'ShowText','on');
                title(sprintf(['  DOF = ' num2str(size(elem,1)*ordem^2),...
                    '   PVI = ',num2str(VPI(end),2),'  CPU(min) = ' num2str(Time,4)]));
                c=colorbar; %c.Label.String = 'Water Saturation [-]';
                caxis([min(S_old) max(S_old)]);axis off; axis square
                %title(sprintf([smetodo,'-Method'])); axis square
                title(sprintf(['  DOF = ' num2str(size(elem,1)*ordem^2),'   /   PVI = ',num2str(VPI(end))]));
            end
        end
% ==================================================================================================         
 if VPI(cont-1)>=1
    break
end
end
CPUt=toc/60; disp(['CPU time = ' num2str(CPUt)]);
%% --------------------- Production curves ----------------------------------
figure;
plot(VPI,cumulateoil,'-','LineWidth',1.0); hold on
plot(VPI,watercut,'k-','LineWidth',1);%axis square
plot(VPI,oilrecovery,'m-','LineWidth',1); hold on
axis ([0, 1,-0.05,1.05]); grid on; grid minor;
legend('Cumulative Oil' ,'Water Cut','Oil Recovery');
title(sprintf('PVI = %3.4f ',t_old));
% --,-,-. ,:, *, +
%--------------------------------------------------------------------------  


