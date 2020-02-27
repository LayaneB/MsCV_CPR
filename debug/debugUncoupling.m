global coarseneigh coarseelem elemloc npar 
tol = 10^-13;
coupling = cell(npar,1);
badElem = cell(npar,1);
A = TransFn;
%A = M;
for ii = 1 :npar
    
    coarseNeighbors = find(coarseneigh(1:npar));
    elemInCoarse = coarseelem{ii};
   % A(elemInCoarse,:)
    B = equalTol( full(A(elemInCoarse,:)),tol);
    neighTemp = [];
    brokenEl = [];
    
    for jj = 1 : size(B,1) 
%         if ii == 2 
%             %1+1
%         end
        neighTemp = unique([neighTemp ; elemloc(find(B(jj,:)))]);
        brokenEl = [brokenEl find(B(jj,:))]; 
        brokenEl = setdiff(brokenEl,elemInCoarse);
    end     
    coupling{ii} = neighTemp;
    badElem{ii} = brokenEl;
end

vecTest = false(npar,1);
for ii  = 1:npar
   vecTest(ii) = isequal(coupling{ii} ,ii);    
end


allBad = [];

for ii = 1:npar
    allBad = unique([allBad,badElem{ii}]);
end

disp('coarse volumes with external influence')
if ~isempty(find(~vecTest))
    disp('deu merda')
    1+1;    
    
end
find(~vecTest)