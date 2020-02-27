cl__1 = 0.22;
Point(1) = {0, 0, 0, cl__1};
Point(2) = {1, 0, 0, cl__1};
Point(3) = {1, 1, 0, cl__1};
Point(4) = {0, 1, 0, cl__1};
Line(1) = {2, 3};
Line(2) = {3, 4};
Line(3) = {4, 1};
Line(4) = {1, 2};
Physical Point(101) = {1, 4};
Physical Point(102) = {2, 3};
Physical Line(101) = {3};
Physical Line(102) = {1};
Physical Line(201) = {2, 4};
Line Loop(6) = {2, 3, 4, 1};
Plane Surface(1) = {6};

