cl__1 = 0.15;
Point(1) = {0, 0, 0, cl__1};
Point(2) = {1, 0, 0, cl__1};
Point(3) = {1, 1, 0, cl__1};
Point(4) = {0, 1, 0, cl__1};
Line(1) = {1, 2};
Line(2) = {2, 3};
Line(3) = {3, 4};
Line(4) = {4, 1};
Line Loop(1) = {1, 2,3,4};
Plane Surface(1) = {1};
Recombine Surface{1};
Physical Point(101) = {1, 4};
Physical Point(102) = {2, 3};
Physical Line(101) = {4};
Physical Line(102) = {2};
Physical Line(201) = {3};
Physical Line(202) = {1};
Physical Surface(1) = {1};


