//--------------------------------------------------------------------
//---------------- UNIVERSIDADE FEDERAL DE PERNAMBUCO ----------------
//---------------- CENTRO DE TECNOLOGIA E GEOCIENCIAS ----------------
//---------- PROGRAMA DE POS GRADUACAO EM ENGENHARIA CIVIL -----------
//--------------------------------------------------------------------

//Work developed by: Marcio Souza and Luiz E. Queiroz
//Advisor Professors: Paulo Lyra & Darlan Carvalho
//Create date: 2017/7/23;	hour: 14:44h

//--------------------------------------------------------------------
//This file has CAD parameters. It is related to building of domain

//"cl1" corresponds to element size attributed in "Start.dat";
cl1 = 0.500000;
//"cl2" corresponds to element size surrounding the well center 1;
cl2 = 0.025000;
//"cl3" corresponds to element size surrounding the well center 2;
cl3 = 0.025000;

Point(1) = {0, 0, 0, cl2};
Point(2) = {1, 0, 0, cl1};
Point(3) = {1, 1, 0, cl2};
Point(4) = {0, 1, 0, cl1};
Point(5) = {0.5, 0, 0, cl1};
Point(6) = {0.5, 1, 0, cl1};
Line(1) = {1, 5};
Line(2) = {5, 2};
Line(3) = {2, 3};
Line(4) = {3, 6};
Line(5) = {6, 4};
Line(6) = {4, 1};
Line(7) = {5, 6};
Line Loop(9) = {1, 7, 5, 6};
Plane Surface(9) = {9};
Line Loop(11) = {2, 3, 4, -7};
Plane Surface(11) = {11};
Physical Point(0) = {1, 6};
Physical Point(2) = {3, 4};
Physical Point(202) = {2, 5};
Physical Line(201) = {1, 2, 4, 5};
Physical Line(101) = {6};
Physical Line(202) = {3};
Physical Line(15) = {7};



Physical Surface(1) = {9};
Physical Surface(2) = {11};



Transfinite Line {1,5} = 5 Using Progression 1.000000;
Transfinite Line {2,4} = 5 Using Progression 1.000000;
Transfinite Line {3,7} = 5 Using Progression 1.000000;
Transfinite Line {7,6} = 5 Using Progression 1.000000;
Transfinite Surface {9} = {1,5,6,4};
Transfinite Surface {11} = {5,2,3,6};

Recombine Surface {9};
Recombine Surface {11};
