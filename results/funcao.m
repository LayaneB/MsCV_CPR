function [F1,F2,F3] = funcao(X)
F1 = X(1)^2 +X(2)^2 + X(3)^2 - 9;
F2 = X(1)*X(2)*X(3) - 1;
F3 = X(1) + X(2) - X(3)^2;
end