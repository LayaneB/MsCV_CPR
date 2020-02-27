Mesh.Algorithm = 6;
cl__1 = 2.14;
xm = 0.25;
ym = 0.3;
L = 0.07;
h = 0.6;

xm1 = 0.75;
ym1 = 0.7;
L1 = 0.07;
h1 = 0.6;
Point(1) = {0, 0, 0, 1e+22};
Point(2) = {1, 0, 0, 1e+22};
Point(3) = {1, 1, 0, 1e+22};
Point(4) = {0, 1, 0, 1e+22};
Point(5) = {xm - (L/2), ym - (h/2), 0, 1e+22};
Point(6) = {xm + (L/2), ym - (h/2), 0, 1e+22};
Point(7) = {xm + (L/2), ym + (h/2), 0, 1e+22};
Point(8) = {xm - (L/2), ym + (h/2), 0, 1e+22};

Point(9) = {xm1 - (L1/2), ym1 - (h1/2), 0, 1e+22};
Point(10) = {xm1 + (L1/2), ym1 - (h1/2), 0, 1e+22};
Point(11) = {xm1 + (L1/2), ym1 + (h1/2), 0, 1e+22};
Point(12) = {xm1 - (L1/2), ym1 + (h1/2), 0, 1e+22};

Line(1) = {1, 5};

Line(2) = {5, 6};
Line(3) = {6, 2};
Line(4) = {2, 3};
Line(5) = {3, 11};
Line(6) = {11, 12};
Line(7) = {12, 4};
Line(8) = {4, 1};

Line(9) = {6, 7};
Line(10) = {7,8};
Line(11) = {8,5};


Line(12) = {12, 9};
Line(13) = {9,10};
Line(14) = {10,11};


Line Loop(1) = {1, 2, 3, 4,5,6,7,8}; 
Line Loop(2) = {2, 9, 10, 11};
Line Loop(3) = {12, 13, 14, 6};


Plane Surface(2) = {2};
Plane Surface(3) = {3};

Plane Surface(1) = {1,2,3};



Physical Point(201) = {1, 2, 3, 4};
Physical Line(201) = {1, 2, 3, 4,5,6,7,8};
Physical Surface(1) = {1};
Physical Surface(2) = {2};
Physical Surface(3) = {3};
Coherence;
Coherence;
Coherence;
