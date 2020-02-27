%% digite segundo o benchmark
benchmark='gaowu9';
%% adequa��o das permeabilidades, otros entes fisico-geometricos segundo o bechmark
%[elem,kmap,normKmap,solanali,bedge,fonte,velanali]=adequapermeab(benchmark, kmap,elem,bedge);

%%  adequa��o das faces por elemento e por n� em sentido anti-horario
% F: faces ordenados ao redor de um elemento
% V: faces ordenados "convenientemente" ao rededor de um n�
% N: faces ordenados ao rededor de um no em sentido anti-horario

% preprocessamento local

%adeqPerm
[F,V,N]=elementface;

%% pre-processador local
[parameter,p_old,tol,nit,nflagno]=preNLFV(kmap,bedge);

% substitua a fun��o mobilidade pela sua fun��o
S_old=ones(size(elem,1),1);
auxflag=201;
S_cont=1;
nw=1;
no=1;
[mobility] = mobilityface(S_old,nw,no,auxflag,S_cont,simu);
fonte = zeros(size(elem,1),1);
fonte(1) = 1;
[p,errorelativo,flowrate,flowresult]=solverpressure(kmap,nflagno,fonte,tol,...
    nit,p_old,mobility,N,parameter,pmetodo,interptype);

postprocessorTMS(full(p),full(p),0,superFolder,'tpfa-nl');