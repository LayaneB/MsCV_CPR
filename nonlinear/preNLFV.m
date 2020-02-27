function [parameter,p_old,tol,nit,nflagno]=preNLFV(kmap,benchmark,bedge)
global elem

%% calculo dos parametros ou constantes (ksi)
[parameter]=coefficientLPSangle(kmap);
% adequação dos flags de contorno
nflagno= contflagno(benchmark,bedge);
%% dados inicialização métodos dos volumes finitos não linear
p_old=1e1*ones(size(elem,1),1); % inicializando a pressão
tol=1e-14;                        % tolerancia
nit=10000;                       % # iterações de Picard
end