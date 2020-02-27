function [Xn] = N_R(X,tol,imax)
h1=0.1; h2=0.1; h3=0.1;
[J,F1,F2,F3]=jacobiana(X,h1,h2,h3); 
F=[F1;F2;F3];
for i=1:imax
     Xn = X - J\F; %cálculo da nova solução
     E=abs(Xn-X);
     if E<tol %Tolerância do erro pra cada iteração
       break
     end
    h1=X(1)-Xn(1); h2=X(2)-Xn(2); h3= X(3)-Xn(3); X=Xn;
    [J,F1,F2,F3]=jacobiana(X,h1,h2,h3); 
    F=[F1;F2;F3];
end