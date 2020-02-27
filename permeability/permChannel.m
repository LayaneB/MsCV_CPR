%% Kmap 
material1 = [1 0 0 1];
%material2 = [1000 0 0 1000];
material2 = [1/1000 0 0 1/1000];
material3 = [1000 0 0 1000];



kmap = [1 material1 ; 2 material2; 3 material3];

%Reference of the Square
% 1 - Bottom Left Corner 
% 2 - Centroid of the Figure

%%
%Number of Barrier/Channels
Num = 3;
%%
%Coord of the First Barr
Xm1 = 0.3;
Ym1 = 0.5;
L1 = 0.4;
H1 = 0.6;
PHI1 = 0;

%Type of The First Mat
MatType1 = 2;
refCent1 = 2;

%%
%Coord of the Second Barr
Xm2 = 0.7;
Ym2 = 0.5;
L2 = 0.4;
H2 = 0.6;
PHI2 = 0;
%Type of The First Mat
MatType2 = 2;
refCent2 = 2;
%%
%Coord of the Third Barr
Xm3 = 0.5;
Ym3 = 0.5;
L3 = 0.8;
H3 = 0.35;
PHI3 = 0;
%Type of The First Mat
MatType3 = 1;
refCent3 = 2;


%%
%Coord of the 4 Barr
Xm4 = 0.5;
Ym4 = 0.5;
L4 = 0.1;
H4 = 1;
PHI4 = 0;
%Type of The First MatH4 = 1;

MatType4 = 1;
refCent4 = 2;


%%
%Coord of the 5 Barr
Xm5 = 0.5;
Ym5 = 0.5;
L5 = 0.05;
H5 = 0.5;
PHI5 = 45;
%Type of The First Mat
MatType5 = 3;
refCent5 = 2;



%%
%Coord of the 6 Barr
Xm6 = 0.5;
Ym6 = 0.5;
L6 = 0.5;
H6 = 0.05;
PHI6 = 45;
%Type of The First Mat
MatType6 = 3;
refCent6 = 2;



%% initializing barrels
%[ list ] = drawHexagon(0.5,0.5,0.45,0,2);

[ list1 ] = drawSquare( Xm1,Ym1,L1,H1,PHI1,MatType1,refCent1);
[ list2 ] = drawSquare( Xm2,Ym2,L2,H2,PHI2,MatType2,refCent2);
[ list3 ] = drawSquare( Xm3,Ym3,L3,H3,PHI3,MatType3,refCent3);
[ list4 ] = drawSquare( Xm4,Ym4,L4,H4,PHI4,MatType4,refCent4);
[ list5 ] = drawSquare( Xm5,Ym5,L5,H5,PHI5,MatType5,refCent5);
[ list6 ] = drawSquare( Xm6,Ym6,L6,H6,PHI6,MatType6,refCent6);
%% projecting onto the mesh
Kmat = isBar(centelem(:,1),centelem(:,2),list1,list2,list3); %,list2,list3,list4,list5,list6); %,list2);%, list2);
Kmat(Kmat == 0) = 1;

%% add Kmat to the elements
%elem(Kmat == 0,5) = 1;
elem(Kmat == 1,5) = 1;
elem(Kmat == 2,5) = 2;
elem(Kmat == 3,5) = 3;
%elem(Kmat,5) = 2; 
