function [F,V,N]=elementface
global bedge inedge elem coord esurn1 esurn2 nsurn1 nsurn2 npar Nregion Vregion

% cuidado quando esta em sentido horario e antihorario.

auxnflag=50000*ones(size(coord,1),1);
for ifacont=1:size(bedge,1)
   
    auxnflag(bedge(ifacont,1),1)=201;
    
end



% if strcmp(pmetodo,'nlfvSY')
%     auxnflag=nflag;
%     auxnflag(size(bedge,1)+1:size(coord,1),1)=50000;
%     auxnflag(size(bedge,1)+1:size(coord,1),2)=50000;
% else
%     
%     auxnflag=nflag;
% end
for ii=1:size(elem,1)
    i=1;
    n=elem(ii,4);
    if n~=0
        list=elem(ii,1:4);
    else
        list=elem(ii,1:3);
    end
    for jj=1:length(list)
        if jj<length(list)
            ibedge=find(((bedge(:,1)==list(jj+1) & bedge(:,2)==list(jj))|(bedge(:,1)==list(jj) & bedge(:,2)==list(jj+1))));
            
            if ibedge~=0
                F(ii,i)=ibedge; % flag da face 
                i=i+1;
            else
                iedge=find((inedge(:,1)==list(jj+1) & inedge(:,2)==list(jj))|(inedge(:,1)==list(jj) & inedge(:,2)==list(jj+1)));
                F(ii,i)=iedge+size(bedge,1);
                i=i+1;
            end
        else
            ibedge=find(((bedge(:,1)==list(jj) & bedge(:,2)==list(1))|(bedge(:,1)==list(1) & bedge(:,2)==list(jj))));
            
            if ibedge~=0
                F(ii,i)=ibedge;
                i=i+1;
            else
                iedge=find((inedge(:,1)==list(jj) & inedge(:,2)==list(1))|(inedge(:,1)==list(1) & inedge(:,2)==list(jj)));
                F(ii,i)=iedge+size(bedge,1);
                
                i=i+1;
            end
        end
    end
    
    
end

%% 
for No=1:size(coord,1)
    N_element_No=esurn2(No+1)-esurn2(No);
    
    n_pontos=nsurn2(No+1)-nsurn2(No);
    
    %construção do tensor permeabilidade.%
    
    for k=1:N_element_No
        
        n1=elem(esurn1(esurn2(No)+k),1);
        n2=elem(esurn1(esurn2(No)+k),2);
        n3=elem(esurn1(esurn2(No)+k),3);
        n4=elem(esurn1(esurn2(No)+k),4);
        a=zeros(2,1);
        ii=1;
        for jj=[n1,n2,n3,n4]
            if jj~=No && jj==0
                a(ii,1)=jj;
                ii=ii+1;
            elseif jj~=No && jj~=0
                for g=1:n_pontos
                    h=nsurn1(nsurn2(No)+g);
                    if jj==h
                        a(ii,1)=jj;
                        ii=ii+1;
                    end
                end
            end
        end
        list=nsurn1(nsurn2(No)+1:nsurn2(No+1));
        list2=esurn1(esurn2(No)+1:esurn2(No+1));
        
        for g=1:size(list,1)
            h=list(g);
            if length(list)==length(list2)
                if length(list)==k
                    if a(1,1)==list(g)
                        r=size(list,1)+1;
                    elseif a(2,1)==h
                        s=length(list);
                    end
                else
                    if a(1,1)==h
                        r=g;
                    elseif a(2,1)==h
                        s=g;
                    end
                end
            else
                if a(1,1)==h
                    r=g;
                elseif a(2,1)==h
                    s=g;
                end
            end
        end
        % quere dizer que nó pertece ao no interior da malha
        %r=find(bedge(:,1)~=No); 
        if auxnflag(No,1)==50000
            
            if r==n_pontos & s==n_pontos
                
                
                m=a(2,1);
                n=a(1,1);
                
            elseif r<s
                m=a(1,1);
                n=a(2,1);
            else
                m=a(2,1);
                n=a(1,1);
            end
            
            
        else
            if r<s
                m=a(1,1);
                n=a(2,1);
            else
                m=a(2,1);
                n=a(1,1);
            end
        end
        
        
        [Tt]=faces_no(bedge, inedge,No,m,n);
        V(:,k,No)= Tt';
 
    end
    
    
    %% 
    
    m1=1;
    vetor1=nsurn1(nsurn2(No)+1:nsurn2(No+1));
    for j= [vetor1']
        ibedge=find(((bedge(:,1)==No & bedge(:,2)==j)|(bedge(:,1)==j & bedge(:,2)==No)));
        if ibedge~=0
            
            N(No,m1)=ibedge+size(inedge,1);
            m1=m1+1;
        else
            iedge=find(((inedge(:,1)==j & inedge(:,2)==No)|(inedge(:,1)==No & inedge(:,2)==j)));
            
            N(No,m1)=iedge;
            m1=m1+1;
        end
    end

    
    
    
    
end



Nregion = zeros(size(N,1),size(N,2),npar);
%tmp = zeros(size(N));

for ii = 1: npar
    tmp = zeros(size(N));
    tmp = N;
   
    if ii == 51
        1+1;
    end
    tmp(~filtEdges2(N,ii)) = 0; 
 
   
    for jj = 1:size(tmp,1)
        tmp(jj,:) = zeroswift(tmp(jj,:));   % ordenação sentido anti-horário     
    end
    %% 
    Nregion(:,:,ii) = tmp;
end


Vregion = zeros(size(V,1),size(V,2),size(V,3),npar);



for region = 1:npar
   
    for ii = 1:size(coord,1)
        auxmat = V(:,:,ii);
        auxvec = filtEdges2(V(:,:,ii),region);
        auxvec = auxvec(1,:) .*auxvec(2,:);
        auxvec = [auxvec ; auxvec];
        
        Vregion(:,:,ii,region) = zeroSwiftMat( auxmat.*auxvec);
        
    end
    
    
end



end



function out = filtEdges2(matEd, region)
    global inedge bedge elemloc
    %out = zeros(size(matEd));
    auxIn1 = zeros(size(matEd));
    auxIn2 = zeros(size(matEd));

    auxBed = zeros(size(matEd));
    
    refBedge= matEd > size(inedge,1);
    refInedge = (matEd <= size(inedge,1)) & matEd ~= 0;
    
    
    
    auxIn1(refInedge) = elemloc( inedge( matEd(refInedge),3));
    auxIn2(refInedge) = elemloc( inedge( matEd(refInedge),4));
    auxBed(refBedge )= elemloc(bedge(matEd(refBedge)- size(inedge,1),3));
    
    
    out = (auxIn1 == region) | (auxIn2 == region) | (auxBed== region) ;
end

function out = zeroswift(vec)
    b = find(vec==0);
    a = find(vec~=0);
    if (isempty(a)==0)&&(isempty(b)==0)
        c = a>b(1);
        if any(c)~=0
            ref = min(find(c==1));
            prim = vec(a(ref));
            while vec(1)~=prim
               vec = circshift(vec,1); 
            end
        end
        pos = find(vec~=0);
        vec(1:size(pos,2)) = vec(pos);
        vec(size(pos,2)+1:end) = 0;
    end
    out = vec;
    %out = circshift(vec,-1);
end

function out = antihorarioOrder(vec, node)
    global bedge inedge
    ldist = @(x,y) (x.^2 + y.^2)^(0.5);
    ref = size(inedge,1);
    bedge_ref = vec > ref;
    inedge_ref = (~bedge_ref) & (vec ~= 0); 
    
    all_nodes_b = reshape(bedge(vec(bedge_ref) - ref,1:2),1,[]);
    all_nodes_in = reshape(inedge(vec(inedge_ref),1:2),1,[]);
    node = mode([all_nodes_b, all_nodes_in]);
    
    if all(vec ~= 0)
       1+1 
    end
    
        
    end


function mat = zeroSwiftMat(mat)
    ref = mat(1,:) ~= 0;
    auxmat = zeros(2, size(find(ref),2));
    auxmat(1,:) = mat(1,ref);
    auxmat(2,:) = mat(2,ref);    
    mat = zeros(size(mat));
    mat(1,1:size(auxmat,2)) = auxmat(1,:);
    mat(2,1:size(auxmat,2)) = auxmat(2,:);
    
end

function vec = zeroSwift(vecInp,node,region)
    sz = size(vecInp,2);
    vec = zeros(1,sz);    
    p = vecInp(vecInp ~=0);  
%     tmp = zeros(size(p,1),4);
%     if no == 2
%         1+1;
%     end
%     
    
%     refP = refConv(p);
    
if ~isempty(p)
 
    p = ordEdges(node,p',region);
    
   % tmp(refP(:,1) == 1,1) = bedge(
    
    
    vec(1: 1+ size(p,1)-1) = p;

    
end

end



