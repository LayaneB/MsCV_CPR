auxmat = load(fileID3);
nnElem = auxmat(1);
nnpar = auxmat(2);
vpiSnapshot = auxmat(3:end);
vpiErrorPressure = zeros(size(vpiSnapshot));
vpiErrorSaturation = zeros(size(vpiSnapshot));
%converting and generating data
%original data
auxmat = load(fileID1);
origPress = reshape(auxmat(:,1),nnElem,size(vpiSnapshot,1));
origSat = reshape(auxmat(:,2),nnElem,size(vpiSnapshot,1));
auxmat = load(fileID2);
msPress = reshape(auxmat(:,1),nnElem,size(vpiSnapshot,1));
msSat = reshape(auxmat(:,2),nnElem,size(vpiSnapshot,1));

for ii = 1:size(vpiSnapshot,1)
   postprocessorTMS2(origPress(:,ii),origSat(:,ii), vpiSnapshot(ii)*100,superFolder,0);
   postprocessorTMS2(msPress(:,ii),msSat(:,ii), vpiSnapshot(ii)*100,superFolder,1);
   vpiErrorPressure(ii) = normError(origPress(:,ii),msPress(:,ii),2);
   vpiErrorSaturation(ii) = normError(origSat(:,ii),msSat(:,ii),2);
end

%%writing error
dlmwrite(strcat(superFolder,'\error.dat'),[vpiSnapshot vpiErrorPressure vpiErrorSaturation])


