cl__1 = 0.123456789;
Point(1) = {0, 0, 0, cl__1};
Point(2) = {1, 0, 0, cl__1};
Point(3) = {1, 1, 0, cl__1};
Point(4) = {0, 1, 0, cl__1};
Line(1) = {1, 2};
Line(2) = {2, 3};
Line(3) = {3, 4};
Line(4) = {4, 1};

Line Loop(6) = {3, 4, 1, 2};

Physical Point(101) = {2, 3};
Physical Point(102) = {1, 4};

Physical Line(201) = {1, 3};
Physical Line(101) = {2};
Physical Line(102) = {4};

Plane Surface(1) = {6};
Physical Surface(1) = {6};
