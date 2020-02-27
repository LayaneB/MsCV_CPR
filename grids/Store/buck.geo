cl__1 = 1;
Point(1) = {0, 0, 0, cl__1};
Point(2) = {1, 0, 0, cl__1};
Point(3) = {1, 1, 0, cl__1};
Point(4) = {0, 1, 0, cl__1};
Line(1) = {1, 2};
Line(2) = {2, 3};
Line(3) = {3, 4};
Line(4) = {4, 1};
Line Loop(6) = {3, 4, 1, 2};
Plane Surface(6) = {6};

Transfinite Surface {6};
Recombine Surface {6};


Physical Line(7) = {1, 3};
Physical Line(8) = {4, 2};
Physical Point(9) = {4, 1, 2, 3};


surfaceVector[] = Extrude {0, 0, 0} {
 Surface{6};
 Layers{1};
 Recombine;
};