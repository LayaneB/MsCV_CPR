//--------------------------------------------------------------------
//---------------- UNIVERSIDADE FEDERAL DE PERNAMBUCO ----------------
//---------------- CENTRO DE TECNOLOGIA E GEOCIENCIAS ----------------
//---------- PROGRAMA DE POS GRADUACAO EM ENGENHARIA CIVIL -----------
//--------------------------------------------------------------------

//Work developed by: Marcio Souza , Luiz E. Queiroz e Artur Castiel
//Advisor Professors: Paulo Lyra & Darlan Carvalho
//Create date: 2019/8/12;	hour: 20:50h

//--------------------------------------------------------------------
//This file has CAD parameters. It is related to building of domain

cl1 = 1;
Point(1) = {0, 0, 0, cl1};
Point(2) = {1, 0, 0, cl1};
Point(3) = {1, 1, 0, cl1};
Point(4) = {0, 1, 0, cl1};
Line(1) = {1, 2};
Line(2) = {2, 3};
Line(3) = {3, 4};
Line(4) = {4, 1};
Line Loop(6) = {2, 3, 4, 1};
Plane Surface(6) = {6};
Physical Point(201) = {1, 2, 3, 4};
Physical Line(201) = {1, 2, 3, 4};
Physical Surface(1) = {6};


Transfinite Line {1,3} = 11 Using Progression 1.000000;
Transfinite Line {2,4} = 11 Using Progression 1.000000;
Transfinite Surface {6} = {1,2,3,4};

Recombine Surface {6};
