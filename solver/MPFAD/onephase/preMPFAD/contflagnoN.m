function nflag= contflagnoN(bedge)
global  bcflag coord

nflag=50000*ones(size(coord,1),2);


for ifacont=1:size(bedge,1)    

    left = bedge(ifacont,1);
    right = bedge(ifacont,2);
    
    if left == 36 || right == 36
        1+1
    end
    x=bcflag(:,1)==bedge(ifacont,4);
    r=find(x==1);
    nflag(bedge(ifacont,1),2)=bcflag(r,2);
    nflag(bedge(ifacont,1),1)=bcflag(r,1);

end
end