cl = 0;
Point(1) = {0, 0, 0, cl};
Point(2) = {1, 0, 0, cl};
Point(3) = {1, 1, 0, cl};
Point(4) = {0, 1, 0, cl};
Line(1) = {1, 2};
Line(2) = {2, 3};
Line(3) = {3, 4};
Line(4) = {4, 1};
Line Loop(1) = {3, 4, 1, 2};
Plane Surface(1) = {1};
Physical Point(101) = {2, 3};
Physical Point(102) = {1, 4};
Physical Line(101) = {2};
Physical Line(102) = {4};
Physical Line(201) = {1, 3};
Physical Surface(1) = {1};


Transfinite Surface {1};