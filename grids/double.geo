Point(1) = {0, 0, 0, 1.0};
Point(2) = {1, 0, 0, 1.0};
Point(3) = {1, 1, 0, 1.0};
Point(4) = {0, 1, 0, 1.0};
Point(5) = {0.25, 0.5, 0, 1.0};
Point(6) = {0.75, 0.5, 0, 1.0};
Point(7) = {0.5, 0.5, 0, 1.0};
Point(8) = {0.5, 0.25, 0, 1.0};
Point(9) = {0.5, 0.75, 0, 1.0};
Line(1) = {1, 2};
Line(2) = {2, 3};
Line(3) = {3, 4};
Line(4) = {4, 1};
Circle(5) = {9, 7, 5};
Circle(6) = {5, 7, 8};
Circle(7) = {8, 7, 6};
Circle(8) = {6, 7, 9};
//Line Loop(9) = {3, 4, 1, 2};
//Line Loop(10) = {5, 6, 7, 8};
//Plane Surface(11) = {9, 10};

//Transfinite Line {5, 8, 7, 6} = 5 Using Progression 0.5;
//Transfinite Line {3, 2, 1, 4} = 10 Using Progression 0.1;

//Transfinite Surface {11};
//Recombine Surface {11};