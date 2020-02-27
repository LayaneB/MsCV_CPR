
cl__1 = 2.14;
xm = 0.32;
ym = 0.4;
L = 0.07;
h = 0.8;

xm1 = 0.72;
ym1 = 0.6;
L1 = 0.07;
h1 = 0.8;
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

Line(1) = {1, 2};

Line(2) = {2, 3};
Line(3) = {3, 4};
Line(4) = {4, 1};


Line(5) = {5, 6};
Line(6) = {6, 7};
Line(7) = {7, 8};
Line(8) = {8, 5};

Line(9) = {9, 10};
Line(10) = {10,11};
Line(11) = {11,12};
Line(12) = {12,9};



Line Loop(1) = {1, 2, 3, 4}; 


Plane Surface(1) = {1};



Line {5} In Surface {1};
Line {6} In Surface {1};
Line {7} In Surface {1};
Line {8} In Surface {1};
Line {9} In Surface {1};
Line {10} In Surface {1};
Line {11} In Surface {1};
Line {12} In Surface {1};


Physical Point(201) = {1, 2, 3, 4};
Physical Line(201) = {1, 2, 3, 4};
Physical Surface(1) = {1};

Coherence;
Coherence;
Coherence;
