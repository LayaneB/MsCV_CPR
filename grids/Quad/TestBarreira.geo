//--------------------------------------------------------------------
//---------------- UNIVERSIDADE FEDERAL DE PERNAMBUCO ----------------
//---------------- CENTRO DE TECNOLOGIA E GEOCIENCIAS ----------------
//---------- PROGRAMA DE POS GRADUACAO EM ENGENHARIA CIVIL -----------
//--------------------------------------------------------------------

//Work developed by: Marcio Souza and Luiz E. Queiroz
//Advisor Professors: Paulo Lyra & Darlan Carvalho
//Create date: 2018/10/18;	hour: 16:24h

//--------------------------------------------------------------------
//This file has CAD parameters. It is related to building of domain

//"cl1" corresponds to element size attributed in "Start.dat";
cl1 = 0.500000;
//"cl2" corresponds to element size surrounding the well center 1;
cl2 = 0.025000;
//"cl3" corresponds to element size surrounding the well center 2;
cl3 = 0.025000;

Point(1) = {0.000000, 0.000000, 0.000000, cl2};
Point(2) = {1.000000, 0.000000, 0.000000, cl1};
Point(3) = {1.000000, 1.000000, 0.000000, cl2};
Point(4) = {0.000000, 1.000000, 0.000000, cl1};
Point(5) = {0.250000, 0.250000, 0.000000, cl1};
Point(6) = {0.750000, 0.250000, 0.000000, cl1};
Point(7) = {0.750000, 0.750000, 0.000000, cl1};
Point(8) = {0.250000, 0.750000, 0.000000, cl1};
Line(1) = {1, 2};
Line(2) = {2, 3};
Line(3) = {3, 4};
Line(4) = {4, 1};
Line(5) = {5, 6};
Line(6) = {6, 7};
Line(7) = {7, 8};
Line(8) = {8, 5};
Line Loop(15) = {1, 2, 3, 4, -5, -8, -7, -6};
Plane Surface(15) = {15};
Line Loop(16) = {6, 7, 8, 5};
Plane Surface(16) = {16};
Physical Point(201) = {1, 2, 3, 4};
Physical Point(10) = {5, 6, 7, 8};
Physical Line(201) = {1, 2, 3, 4};
Physical Line(12) = {5, 6, 7, 8};
Physical Surface(1) = {15};
Physical Surface(2) = {16};

Transfinite Line {1,3} = 5 Using Progression 1.000000;
Transfinite Line {2,4} = 5 Using Progression 1.000000;
Transfinite Line {5,6,7,8} = 5 Using Progression 1.000000;
Transfinite Surface {15} = {1, 2, 3, 4, -5, -8, -7, -6};
Transfinite Surface {16} = {6, 7, 8, 5};

Recombine Surface {15};
Recombine Surface {16};