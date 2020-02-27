cl__1 = 1e+22;
xi = 0.25;
yi = 0.25;
xS = 0.5;
yS = 0.5;

Point(1) = {0, 0, 0, 1e+22};
Point(2) = {1, 0, 0, 1e+22};
Point(3) = {1, 1, 0, 1e+22};
Point(4) = {0, 1, 0, 1e+22};
Point(5) = {xi, yi, 0, 1e+22};
Point(6) = {xi + xS, yi, 0, 1e+22};
Point(7) = {xi + xS, yi +yS, 0, 1e+22};
Point(8) = {xi , yi +yS, 0, 1e+22};

Line(1) = {1, 2};

Line(2) = {2, 3};

Line(3) = {3, 4};

Line(4) = {4, 1};

Line Loop(1) = {1, 2, 3, 4};

Line(5) = {5, 6};
Line(6) = {6, 7};
Line(7) = {7, 8};
Line(8) = {8, 5};
Line Loop(2) = {5, 6, 7, 8};

Plane Surface(1) = {1};
Plane Surface(2) = {2};

Physical Surface(1) = {1};
Physical Surface(2) = {2};


Physical Point(201) = {1, 2, 3, 4};
Physical Line(201) = {1, 2, 3, 4};



