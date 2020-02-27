function [J,F1,F2,F3]=jacobiana(X,h1,h2,h3)
[F1,F2,F3] = funcao(X);
[F1h,F2h,F3h] = funcao([X(1)+h1;X(2);X(3)]);                                                                                          
[F1hi,F2hi,F3hi] = funcao([X(1);X(2)+h2;X(3)]);
[F1hj,F2hj,F3hj] = funcao([X(1);X(2);X(3)+h3]);
J=[(F1h-F1)/h1 (F1hi-F1)/h2 (F1hj-F1)/h3 ; ...
   (F2h-F2)/h1 (F2hi-F2)/h2 (F2hj-F2)/h3;...
   (F3h-F3)/h1 (F3hi-F3)/h2 (F3hj-F3)/h3 ];
end