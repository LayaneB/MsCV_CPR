
%pointer = fopen(fileID1,'a');

dlmwrite(fileID2,[full(p) full(S_old')],'-append','delimiter','\t','precision',3);
%fclose(pointer);