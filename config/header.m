pointer = fopen(fileID3,'w');
fprintf(pointer,'%f\n',size(elem,1));
fprintf(pointer,'%f\n',npar);
fprintf(pointer,'%f\n',vpi_vecF);


fclose(pointer);