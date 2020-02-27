// Gmsh project created on Thu Jul 21 13:51:56 2016
lado = 1;
Point(1) = {0, 0, 0, lado};
Point(2) = {0, lado, 0, lado};
Point(3) = {lado, lado, 0, lado};
Point(4) = {lado, 0, 0, lado};
Line(1) = {1, 4};
Line(2) = {4, 3};
Line(3) = {3, 2};
Line(4) = {2, 1};
Line Loop(5) = {3, 4, 1, 2};
Plane Surface(6) = {5};
Physical Line(201) = {3,1};
Physical Line(101) = {4};
Physical Line(102) = {2};
Physical Point(201) = {4, 3, 2, 1};
Physical Surface(1) = {6};
