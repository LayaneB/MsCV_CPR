cl__1 = 1.125;
Point(1) = {0, 0, 0, cl__1};
Point(2) = {1, 0, 0, cl__1};
Point(3) = {1, 1, 0, cl__1};
Point(4) = {0, 1, 0, cl__1};
Point(5) = {0.25, 0.25, 0, cl__1};
Point(6) = {0.75, 0.25, 0, cl__1};
Point(7) = {0.75, 0.75, 0, cl__1};
Point(8) = {0.25, 0.75, 0, cl__1};
Line(1) = {1, 2};

Line(2) = {2, 3};

Line(3) = {3, 4};

Line(4) = {4, 1};

Line(5) = {5, 6};
Line(6) = {6, 7};
Line(7) = {7, 8};
Line(8) = {8, 5};
Line Loop(1) = {1, 2, 3, 4};
Line Loop(2) = {5, 6, 7, 8};
Plane Surface(1) = {1, 2};

Plane Surface(2) = {2};
//Line {5} In Surface {2};
//Line {6} In Surface {2};
//Line {7} In Surface {2};
//Line {8} In Surface {2};
Recombine Surface {1};
Recombine Surface {2};

Physical Point(102) = {2, 3};



Physical Line(201) = {1,3};
Physical Line(202) = {4};
Physical Line(102) = {2};

Physical Surface(1) = {1};
Physical Surface(2) = {2};

