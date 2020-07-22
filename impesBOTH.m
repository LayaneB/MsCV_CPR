clear; close all; clc;
%% 
global test ordem smetodo sml mov_ benchmark2 plotfc multiscale CFL suavizador flagSuavizador ...
       MetodoSuavizador Wc Wf  
Globals2D_CPR;
%% =========================== Selicionar caso ============================
% criar novos
test = 'five_spot';

switch test
   
        case 'five_spot'  

    CFL=0.5; ordem=2; tordem=1; smetodo='cpr'; sml='off'; mov_='off'; plotfc = 'off';
    nw=2; no=2;  benchmark2= 'durlofsky'; load('-mat','oil_rec_ref.mat');
    nameFile = 'start_fivespot.dat'; multiscale = 'off'; flagSuavizador = 'off'; 
    suavizador = 'ILU'; MetodoSuavizador = 'S_Multiescala'; Wc = 1; Wf = 2/3;
    
        case 'barreira'  

    CFL=0.5; ordem=2; tordem=1; smetodo='cpr'; sml='off'; mov_='off'; plotfc = 'off';
    nw=2; no=2;  benchmark2= 'BenchTwophase4'; load('-mat','oil_rec_ref.mat');
    nameFile = 'start_fivespot_barreira.dat'; multiscale = 'on';flagSuavizador = 'on'; 
    suavizador = 'SOR'; MetodoSuavizador = 'S_Multiescala'; Wc = 1; Wf = 1;
    
        case 'SPE10'  

    CFL=0.5; ordem=1; tordem=1; smetodo='FOU'; sml='off'; mov_='off'; plotfc = 'off';
    nw=2; no=2;  benchmark2= 'durlofsky'; load('-mat','oil_rec_ref.mat');
    nameFile = 'start_spe.dat'; multiscale = 'on'; flagSuavizador = 'on'; 
    suavizador = 'GS'; MetodoSuavizador = 'S_R'; Wc = 1; Wf = 5/3;
    
end
% =========================================================================
%% =========================== preprocessamento ===========================

main2

% =========================================================================
%% ...
vpi_vecF = [0.1 :0.1:1];
% %plot perm
% postprocessorPerm(elem(:,end),0,superFolder)
%Write header
header
%Info on the mesh
meshProp

%Write Info on Coarse Mesh
coarseVTK %comentario linha 23

%% copying start.dat and msh to the result folder
copyfile('start.dat',superFolder)
strr = strcat(keypath1{1},'/',mshfile{1});
copyfile(strr,superFolder)
%% copying iterativeRoutine and msh to the result folder
copyfile('iterative/iterativeRoutine.m',superFolder)

%% starting simulation
% % % regular MPFAD
%   vpi_vec = vpi_vecF;
%  impes

 
%% ms MPFAD
  switch test
    
    case 'five_spot' 
        adeqPerm
        vpi_vec = vpi_vecF;
        impesMPFAD
        
    case 'SPE10'
        
        global layer CPUfinal
        CPUfinal = 0;
        
        for layer = 1:85
           vpi_vec = vpi_vecF; 
           triangular = 2; Rotacionado = 2; meshX = 60; meshY = 220;
           SPEField
           impesMPFAD
           disp(layer)
        end 
        
end


%% 
readHeader
%% 
