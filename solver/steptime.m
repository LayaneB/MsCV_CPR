function delt=steptime(f_elem,S_old,influx,CFL,S_cont,auxflag,nw,no,ordem)
order = 1;
n= ordem-1;
global centelem pormap inedge coord bedge satlimit visc
delt=1e50;
dt_local=1e49;
TOL=1e-12;
for iface=1:(size(bedge,1)+size(inedge,1))
    
    
    if (size(bedge,1)<iface) % quando iface é maior que numero de faces de
        % contorno quere dizer que pertece ao interior da malha. 
        lef=inedge(iface-size(bedge,1),3); % elemento a direita da face i
        rel=inedge(iface-size(bedge,1),4); % elemento a esquerda da face i
        A=norm(coord(inedge(iface-size(bedge,1),1),:)-coord(inedge(iface-size(bedge,1),2),:)); % comprimento dos baricentros adyacentes a face i
        xI = centelem(lef,:);
        xJ = centelem(rel,:);
        dx = norm(xI - xJ);
        if abs(S_old(lef)-S_old(rel))<TOL
        else
            alpha = abs((influx(iface)/A)*(f_elem(lef)-f_elem(rel))/(S_old(lef)-S_old(rel)));
            dt_local = abs((CFL/((2*n) + 1))*pormap(1)*dx/alpha);
        end
    else
        if bedge( iface,5)==auxflag || bedge( iface,5)==102
            lef=bedge(iface,3);
            A=norm(coord(bedge(iface,1),:)-coord(bedge(iface,2),:)); % comprimento dos baricentros adyacentes a face i
            xI = centelem(lef,:);
            xJ=0.5*(coord(bedge(iface,1),:)+coord(bedge(iface,2),:));
            dx = norm(xI - xJ);
            
            if abs(S_old(lef)-S_cont)<TOL
            else
                % calculo do fluxo fracional no contorno
                Krw2 = ((S_cont - satlimit(1))/(1-satlimit(1)-satlimit(2)))^nw;
                
                Kro2 = ((1 - S_cont - satlimit(1))/(1-satlimit(1)-satlimit(2)))^no;
                
                L2 = Krw2/visc(1) + Kro2/visc(2);
                
                f_cont= (Krw2/visc(1))/L2;
                
                alpha = abs((influx(iface)/A)*(f_cont-f_elem(lef))/(S_cont - S_old(lef)));
                dt_local = abs((CFL/(2*n))*pormap(1)*dx/alpha); 
%                 dt_local = abs((CFL/(2*order-1))*pormap(1)*dx/alpha); ##
%                 original##
%             
            end
        end
   
    end
    
    if dt_local<delt
        delt=dt_local;
    end
end

end

