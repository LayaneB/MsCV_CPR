function  leitor( name, diretorio )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
    ms = 'Multiscale-Pressure';
    or = 'Original-Pressure';
    ext = '.vtk'; 
    
    
    numero = 0:10:1050;
    mswords = cell(length(numero),1);
    orwords = cell(length(numero),1);
    for ii = 1:length(numero)
        mswords{ii} = [ms '00' num2str(numero(ii)) ext];
        orwords{ii} = [or '00' num2str(numero(ii)) ext];
    end
    
  
    fid = fopen(diretorio,'r');
    i = 1;
    tline = fgetl(fid);
    A{i} = tline;
    while ischar(tline)
        i = i+1;
        tline = fgetl(fid);
        A{i} = tline;
    end
    fclose(fid);

    
    % Change cell A
% A{290} = name;
% % Write cell A into txt
% fid = fopen('start.dat', 'w');
% for i = 1:numel(A)
%     if A{i+1} == -1
%         fprintf(fid,'%s', A{i});
%         break
%     else
%         fprintf(fid,'%s\n', A{i});
%     end
% end
    
end

