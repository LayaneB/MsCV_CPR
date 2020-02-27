function  changefilename( name )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
    fid = fopen('start.dat','r');
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
A{290} = name;
% Write cell A into txt
fid = fopen('start.dat', 'w');
for i = 1:numel(A)
    if A{i+1} == -1
        fprintf(fid,'%s', A{i});
        break
    else
        fprintf(fid,'%s\n', A{i});
    end
end
    
end

