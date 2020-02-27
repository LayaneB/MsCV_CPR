%% IMPES
% Implicit Pressure , Explicit Saturation


%vpi_vec = [ 0.1 0.4 0.5 0.9 1];


%% Saturation Preprocessor 
[N,Fo,V,S_old,S_cont]=presaturation(wells);

%%Calculating Fixed Parameters
[Hesq, Kde, Kn, Kt, Ded] = Kde_Ded_Kt_Kn(kmap);
fonte=0;
nflagno= contflagnoN(bedge);
%[w,s]=Pre_LPEW_2(kmap,N);





%Initializing IMPES variables
CFL = courant;
cont = 1;
vpi_old = 0;
VPI(1) = 0;
cumulateoil(1) = 0;
oilrecovery(1) = 1;
watercut(1) = 0;
vpi = totaltime(2);
t_old = 0;
step=0;
time2=0;

%% exponente das permeabilidades relativas cuidado...! 
nw=2;
no=2;

%% este flag s� use quando o problema � Buckley-Leverett com fluxo imposto
% na face com flag 202, por�m a satura��o ser� imposto na face
auxflag=[1];

OP_old = -1;    
%debugTest3
while vpi_old < vpi %true
 %   pause
    if mod(cont,40) == 0
       1+1
       %debugTest3
    end
    %simu = 'bifasico'
    [mobility] = mobilityface(S_old,nw,no,auxflag,S_cont);
%    [p,errorelativo,flowrate,flowresult]=solverpressure(kmap,fonte,...
%        mobility,wells,S_old,V,nw,no,N,auxflag,Hesq, Kde, Kn, Kt, Ded,nflagno);
   
    [p,errorelativo,flowrate,flowresult,q]=solverpressure(kmap,fonte,...
        mobility,wells,S_old,V,nw,no,N,auxflag,Hesq, Kde, Kn, Kt, Ded,nflagno);    

    
    
    %     
    
    %% calculo do fluxo fracional em cada elemento da malha
    f_elem = fractionalflow(S_old,nw,no);
    
    %% caculo do passo de tempo
    % order sempre = 1
    d_t=steptime(f_elem,S_old,flowrate,CFL,S_cont,auxflag,nw,no); %,order);
    
    %% calculo da satura��o explicito
    %nao usar - isso
    %esuel1 weightLS,bound,upsilon,kappa, smetodo,tordem,
%     S_old=solversaturation(S_old,flowrate,d_t,esuel1,wells,flowresult,...
%         f_elem,S_cont,weightLS,bound,smetodo,tordem,...
%         upsilon,kappa,nw,no,auxflag);
    
        [S_old]= firstorderstandard(S_old,flowrate,flowresult,f_elem,d_t,wells,S_cont,auxflag,nw,no);
        
%         bflux = flowrate(1:size(bedge,1));
%         influx = flowrate(size(bedge,1)+1:end);
%         
%         %[S_old] = firstorderstdseqimp(S_old,influx,bflux,d_t,wells,q,nw,no);
%         [S_old,d_t] = firstorderstdseqimp(S_old,influx,bflux,d_t,wells,flowresult,nw,no);
        X = sprintf('Calculo do campo de satura��o pelo m�todo: %s\nPasso de tempo: %d\n ---------------------------------','FOU',cont);
        disp(X)
        
    %% reporte de produ��o
    [VPI,oilrecovery,cumulateoil,watercut]=reportproduction(S_old,...
        wells,f_elem,cont,VPI,oilrecovery,cumulateoil,watercut,flowresult,d_t);
    
    %% calculo o passo de vpi ou passo de tempo
    %t_old=VPI
    
    %vpi_old= VPI(cont);
    vpi_old = VPI(end);
    dlmwrite(strcat(superFolder,'/orgTimestep.dat'),vpi_old,'delimiter', ' ','-append');

    
    %visualiza��o
    if vpi_old >= time2
        step = 1000*time2;
        dlmwrite(strcat(superFolder,'/orgVPIsnap.dat'),vpi_old,'delimiter', ' ','-append');

        postprocessorTO(full(p),full(S_old),step,superFolder);
        time2 = time2 + 0.01;
    end
    
    %visualiza��o
    if ~isempty(vpi_vec)
        if isEqualTol(vpi_old, vpi_vec(1),0.005)
            dlmwrite(strcat(superFolder,'/orgVPI.dat'),vpi_old,'delimiter', ' ','-append');
            vpi_vec = vpi_vec(2:end);
            saveOriginal;
        end
    end
%     % armezena a produ��o em arquivo .dat
    fprintf(fid3,'%13.3e %13.3e %13.3e %13.3e \n',VPI(cont), ...
        oilrecovery(cont),cumulateoil(cont),watercut(cont));
%% mudei aqui  
%  vpi_old=1e+40;
    %postprocessor(p,S_old,cont+1)
%     postprocessorT(full(p),full(S_old),cont);
%     postprocessorT1(full(b2),full(~b2),cont);
    cont=cont+1;
    S_cont;
end
