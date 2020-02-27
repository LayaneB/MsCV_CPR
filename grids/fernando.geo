H = 1;
L = 1;

Point(1) = {0, 0, 0, 1e+22};
Point(2) = {L, 0, 0, 1e+22};
Point(3) = {L, H, 0, 1e+22};
Point(4) = {0, H, 0, 1e+22};
Line(1) = {1, 2};

Line(2) = {2, 3};

Line(3) = {3, 4};

Line(4) = {4, 1};

Transfinite Line {1,3} = 221Using Progression 1;
Transfinite Line {2,4} = 61Using Progression 1;



Line Loop(1) = {1, 2, 3, 4};
Plane Surface(1) = {1};
Transfinite Surface {1} = {1,2,3,4};
Recombine Surface {1};
Physical Point(101) = {1, 2, 3, 4};
Physical Line(101) = {1, 2, 3, 4};
Physical Surface(1) = {1};
Coherence;
