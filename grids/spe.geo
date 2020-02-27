cl__1 = 0;
//H = 2200;
//L = 1200;
H = 1200;
L = 2200;

H = 1;
L = 1;
//1200 x 2200 x 170
Mesh.Algorithm = 1;
Point(1) = {0, 0, 0, cl__1};
Point(2) = {L, 0, 0, cl__1};
Point(3) = {L, H, 0, cl__1};
Point(4) = {0, H, 0, cl__1};
//Point(5) = {L/2, H/2, 0, cl__1};

Line(1) = {1, 2};
Line(2) = {2, 3};
Line(3) = {3, 4};
Line(4) = {4, 1};

//61 221
// Tell Gmsh how many cells you want per edge somar:	 Somar mais 1
Transfinite Line{1,3} = 61Using Progression 1;
Transfinite Line{2,4} = 221Using Progression 1;

Line Loop(1) = {1, 2, 3, 4};
Plane Surface(1) = {1};

// Recombine the triangles into quads:
Transfinite Surface{1} = {1,2,3,4};
Recombine Surface{1};
//Mesh.Smoothing = 100;
//Point{5} In Surface {1};
Physical Line(201) = {3, 4, 1, 2};
Physical Surface(1) = {1};
//Physical Point(301) = {5};
Physical Point(501) = {1};
Physical Point(502) = {2};
Physical Point(503) = {3};
Physical Point(504) = {4};


// Tell Gmsh what the corner points are(going clockwise or counter-clockwise):

Coherence;
Coherence;
