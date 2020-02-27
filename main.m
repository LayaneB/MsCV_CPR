%FV-MsRB - MultiScale Restriction smoothed Basis method
%Two Phase Flow
%2d -Impl�cita na Press�o Expl�cita na Satura��o (IMPES)
% 21/09/2016 por Artur Castiel Reis de Souza

%% Main File Start Up
%  Clear all variables previously intializied
%  Declare all global variables to be used in the code

nameFile = 'start_fernando.dat';
prepareStart




clear all
clc

global osMode 
osMode = 'linux'


global tol_c coord centelem elem esurn1 esurn2 nsurn1 nsurn2 bedge inedge ...
    normals esureface1 esureface2 esurefull1 esurefull2 elemarea dens visc...
    satlimit pormap bcflag courant totaltime numcase oneNodeEdges keypath2 foldername...
    elemloc npar coarseelem  exinterface exinterfaceaxes ghostelem pointWeight bedgeNode ...
    numinterface interfacecenter  coarseblockcenter coarseneigh intCoord ...
    intRegion   boundRegion GlobalBoundary H outSupport coarseElemCenter ...
    coarseningRatio wells mshfile edgesOnCoarseBoundary refCenterInCoaseElem ...
    dictionary edgesCoarseDict coarseDiricht intinterface pointloc regularEdges semiEdges ...
    coarseedge
%% Tolerance Settings
tol_c = 0.00001;

%% Adds Preprocessor folder to the path
% Including other folders to the path
path(path,'preprocessor');

%% Including the folder of the preprocessor of the method MsRB
path (path,'preMsRSB');

%% Including the folder of the postprocessor of the method MsRB
path (path,'postprocessor');


%% Including the folder of the multiscale library
path (path,'MsRB');

path (path,'preMsMPFAD');

%% Including the folder of the solver and it subfolders
path (path,'solver');

if strcmp(osMode,'windows')
    path (path,'solver\TPFA');
    path (path,'solver\MPFAD\onephase');    
    path (path,'solver\MPFAD\onephase\preMPFAD');
elseif strcmp(osMode,'linux')
    path (path,'solver/TPFA');
    path (path,'solver/MPFAD/onephase');    
    path (path,'solver/MPFAD/onephase/preMPFAD');
end    
    %preMsMPFAD




%% Adds the path of the fuctions used for debbuging
path(path,'debug');


%% Adds the path of the fuctions used for creating complex permeability fields
path(path,'permeability');
path(path,'permfield');

%% Adds the path of class 
path(path,'class');

%% Adds the path of config options
path(path,'config');
colormat = load('color.dat');

%% Adds the path of SPE options
path(path,'SPE');



%% Adds the path Post Multiscale treatments
path(path,'postMs');

%% Adds the path of the Iterative Treatment
path(path,'iterative');


%% Preprocesador Global
    [coord,centelem,elem,esurn1,esurn2,nsurn1,nsurn2,bedge,inedge,...
    normals,esureface1,esureface2,esurefull1,esurefull2,elemarea,dens,visc,...
    satlimit,pormap,bcflag,courant,totaltime,numcase,phasekey,kmap,...
    wells, elemloc,npar,coarseelem ,ghostelem, coarseedge,intinterface,exinterface,exinterfaceaxes,...
    numinterface,interfacecenter, coarseblockcenter, coarseneigh, intCoord, multiCC,coarseningRatio, semiEdges,bedgeNode,...
     pmethod,mshfile,edgesOnCoarseBoundary,oneNodeEdges, pointloc,pointWeight,regularEdges ,keymsfv,interptype,keypath1 ] = preprocessor;

%debugTest3;
%debugPoint;
%% Multiscale Preprocessador for MsRSB
 [ intRegion ,  boundRegion, GlobalBoundary, H, outSupport, ...
    coarseElemCenter,refCenterInCoaseElem, dictionary,edgesCoarseDict,coarseDiricht]   = preMsRB(npar,coarseneigh, centelem,coarseelem, ...
    coarseblockcenter,exinterface,multiCC);
%% superfolder maker
itOn = 0;
superFolderMK

%% adequacao de flag
adeSPE
%verficar a alteracao em wells no preprocessador
%wells = [6490, 1,  301,  1,  0, 1;wells]
%adeqPerm
%% Multiscale Solver

meshAnalysis
%permChannel
%changepermeability 
%datageneration
%solver;