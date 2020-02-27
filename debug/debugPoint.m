for ii=1:npar
    for jj=(ii+1):npar
        if  ~isempty(intinterface{ii,jj})
            
            coordtp = centerinterface(intinterface{ii,jj},inedge, coord,elemloc);
            plot(coordtp(1),coordtp(2),'mo');
        end
    end
end

% for ii = 1:npar
%         if  ~isempty(exinterface{ii})
%             coordtp = centerinterface(exinterface{ii},bedge, coord,elemloc);
%             plot(coordtp(1),coordtp(2),'o');
%         end    
% end

for ii = 1:npar
        for jj = 1:4
            if  ~isempty(exinterfaceaxes{ii,jj})
                coordtp = centerinterface(exinterfaceaxes{ii,jj},bedge, coord,elemloc);
                plot(coordtp(1),coordtp(2),'go');
            end    
        end
end

for ii = 1:npar
       p = intCoord(coarseblockcenter(ii),1:2);
       plot(p(1),p(2),'ro');          
end

store = find(intCoord(:,3) == 5);

for ii = 1 : size(store,1)
    
   p = intCoord(store(ii),1:2);
   plot(p(1),p(2),'rX');    
end
