if strcmp(mshfile{1}(end-4),'u')
    %structured mesh
    meshAnal = 1;
    %meshname = mshfile{1}(1:end-5);
else
    meshAnal = 2;
    %meshname = mshfile{1}(1:end-4);
end
   