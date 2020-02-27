function [S_old, dt] = firstorderstdseqimp(S_old,influx,bflux,dt,wells,q,nw,no)

global elem bedge inedge elemarea pormap

if size(pormap,1) == 1
   pormapMod = ones(size(elem,1),1);
else
    pormapMod = pormap;    
end
C = sparse(size(elem,1),size(elem,1));

t1=1;t2=1;

if ~isequal(wells,0)
    for i=1:size(wells,1)
       if wells(i,2)==1
           injecelem(1,t1)=wells(i,1);
           t1=t1+1;
       elseif wells(i,2)==2
           producelem(1,t2)=wells(i,1);
           t2=t2+1;
       end
    end
end
%--------------------------------------------------------------------------
%Boundary edges
for i = 1:size(bedge,1)
    C(bedge(i,3),bedge(i,3)) =  C(bedge(i,3),bedge(i,3)) + ...
        bflux(i)/(elemarea(bedge(i,3))*pormapMod(elem(bedge(i,3),5)));
end

%--------------------------------------------------------------------------
%Internal edges
for i = 1:size(inedge,1)
    if influx(i) >= 0
        C(inedge(i,3),inedge(i,3)) =  C(inedge(i,3),inedge(i,3)) - ...
            influx(i)/(elemarea(inedge(i,3))*pormapMod(elem(inedge(i,3),5)));            
        C(inedge(i,4),inedge(i,3)) =  C(inedge(i,4),inedge(i,3)) + ...
            influx(i)/(elemarea(inedge(i,4))*pormapMod(elem(inedge(i,4),5)));
    else
        C(inedge(i,3),inedge(i,4)) =  C(inedge(i,3),inedge(i,4)) - ...
            influx(i)/(elemarea(inedge(i,3))*pormapMod(elem(inedge(i,3),5)));
        C(inedge(i,4),inedge(i,4)) =  C(inedge(i,4),inedge(i,4)) + ...
            influx(i)/(elemarea(inedge(i,4))*pormapMod(elem(inedge(i,4),5)));   
    end    
end

if ~isequal(wells,0)
%Calculo termo fonte explicito
    for i=1:size(producelem,2)
        Qprod = q(producelem(i))/(elemarea(producelem(i))*pormapMod(elem(producelem(i),5)));
        C(producelem(i),producelem(i)) = C(producelem(i),producelem(i)) + Qprod;
    end
    for i=1:size(injecelem,2)
        Qinj = q(injecelem(i))/(elemarea(injecelem(i))*pormapMod(elem(injecelem(i),5)));
        C(injecelem(i),injecelem(i)) = C(injecelem(i),injecelem(i)) + Qinj;
    end
end
y=1; ref=0;
while ref == 0
    
    Sw_n = S_old;
    Sw_n1k = S_old;
    Sw_n1k1 = S_old;
    
    dtC = dt*C;
    
    x=1;
    r = 1;
    while (max(abs(r) > 10^-4)&&(x<15))

        Sw_n1k = Sw_n1k1; %- 1;

        [ fw_n1k ] = fractionalflow(Sw_n1k,nw,no);

        [ dfwdS_n1 ] = calcdfdS1(Sw_n1k,nw,no);

        dfwdS_n1 = diag(dfwdS_n1); 

        r = Sw_n + dtC*fw_n1k - Sw_n1k;

        J_n1=dtC*dfwdS_n1;
        
        J_n1=J_n1-eye(size(C));

        s = J_n1\r;

        Sw_n1k1 = Sw_n1k - s;

%         for i=1:size(Sw_n1k1,1)
%             if abs(Sw_n1k1(i)) < 10^-7
%                 Sw_n1k1(i)=0;
%             end
%         end
        
       % Sw_n1k1(abs(Sw_n1k1) < 10^-7) = 0;
        
        x = x + 1;
        
    end
    
   % if (max(Sw_n1k1)-1 > 10^-6)||(min(Sw_n1k1)<0)||(x==15)
     if (max(Sw_n1k1) > 1 )||( min(Sw_n1k1)<0)||(x==15)
        %dt = dt/(5^(y-1));
        %dt = dt/(2*y);%(5^(y-1));
        dt = dt/5;
        %y = y + 1;
        ref = 0;
    else
        ref = 1;
    end
  %  ref = 1;
  
  
end

S_old = Sw_n1k1;

S_old(S_old > 1) = 1;
S_old(S_old < 0) = 0;
end

