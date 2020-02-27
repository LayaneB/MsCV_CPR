%FV-MsRB - MultiScale Restriction smoothed Basis method
%2d -Implícita na Pressão Explícita na Saturação (IMPES)
% 21/09/2016 por Artur Castiel Reis de Souza

if phasekey == 1 && strcmp(pmethod, 'tpfa')
    onephaseflowTPFA
elseif phasekey == 1 && strcmp(pmethod, 'mpfad')
    onephaseflowMPFAD
end