
m = size(inedge,1);
elemfaces = zeros(size(elem,1),4);

for ii = 1:size(elem,1)
    p = elem(ii,1:end-1);
    nfaces1 = circshift(p,[1 0]); 
    nfaces1 = nfaces1(1:2);
    nfaces2 = circshift(p,[1 1]); 
    nfaces2 = nfaces2(1:2);
    nfaces3 = circshift(p,[1 2]); 
    nfaces3 = nfaces3(1:2);
    nfaces4 = circshift(p,[1 3]); 
    nfaces4 = nfaces4(1:2);

   % procurar em inedge
   
    tag1 = (inedge(:,1) ==  nfaces1(1)  & inedge(:,2) ==  nfaces1(2)) | (inedge(:,2) ==  nfaces1(1)  & inedge(:,1) ==  nfaces1(2));
    tag2 = (inedge(:,1) ==  nfaces2(1)  & inedge(:,2) ==  nfaces2(2)) | (inedge(:,2) ==  nfaces2(1)  & inedge(:,1) ==  nfaces2(2));
    tag3 = (inedge(:,1) ==  nfaces3(1)  & inedge(:,2) ==  nfaces3(2)) | (inedge(:,2) ==  nfaces3(1)  & inedge(:,1) ==  nfaces3(2));
    tag4 = (inedge(:,1) ==  nfaces4(1)  & inedge(:,2) ==  nfaces4(2)) | (inedge(:,2) ==  nfaces4(1)  & inedge(:,1) ==  nfaces4(2));

   
   % procurar em bedge
    tag5 = (bedge(:,1) ==  nfaces1(1)  & bedge(:,2) ==  nfaces1(2)) | (bedge(:,2) ==  nfaces1(1)  & bedge(:,1) ==  nfaces1(2));
    tag6 = (bedge(:,1) ==  nfaces2(1)  & bedge(:,2) ==  nfaces2(2)) | (bedge(:,2) ==  nfaces2(1)  & bedge(:,1) ==  nfaces2(2));
    tag7 = (bedge(:,1) ==  nfaces3(1)  & bedge(:,2) ==  nfaces3(2)) | (bedge(:,2) ==  nfaces3(1)  & bedge(:,1) ==  nfaces3(2));
    tag8 = (bedge(:,1) ==  nfaces4(1)  & bedge(:,2) ==  nfaces4(2)) | (bedge(:,2) ==  nfaces4(1)  & bedge(:,1) ==  nfaces4(2));
   
    ki = [find(tag1) find(tag2) find(tag3) find(tag4)];
    kb = [find(tag5) find(tag6) find(tag7) find(tag8)];
    
    kb = kb  +  m * ones(size(kb,1), size(kb,2)); 
    
    k = [unique(ki) unique(kb)];
    elemfaces(ii,:) = k;
    
%     elemfaces(ii,:) = unique([find(tag1) find(tag2) find(tag1) find(tag3) find(tag4) find(tag5) find(tag6) find(tag7)  find(tag8)]);
    
end