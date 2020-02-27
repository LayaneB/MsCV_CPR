%--------------------------------------------------------------------------
% GETMULTISCALE
%--------------------------------------------------------------------------
% Script responsable for generating all multiscale properties
%--------------------------------------------------------------------------
% OUTPUT:  cell : coarseedge{}
%                 intinterface{}
%                 exinterface{}
%                 exinterfaceaxes{}
%                 interfacecenter{}
%                 coarseblockcenter()
%                 numinterface()
%				  coarseneigh()
%--------------------------------------------------------------------------
% INPUT: Scripts don't take input. This script uses all variables stated 
% inside preprocessor.m
%--------------------------------------------------------------------------
%% GENERATING COARSE CELL EDGES AND COARSE CELL NEIGHBORS
%--------------------------------------------------------------------------
% coarseedge{npar} - ALL EDGES OF A COARSE CELL
% Cell Array containing a matrix with the edges of each partion
% ex: coarseedge{3} - first collumn is a reference to either bedge or
% inedge and the second column is flag: 1 - look bedge | 0 - look inedge
% edge)
%   Reference Flag
%     3        0
%     4        0
%         ...
%     23       1
%--------------------------------------------------------------------------
% intinterface - coarse edge neighbors - EACH OTHER NEIGHBORS
% intinterface{m,n} gives the refrence of the edges that belong to h M and N
% intinterface(3,4) =
%   Reference 
%     3    
%     4   
%    ...
%     23 
%--------------------
%--------------------------------------------------------------------------
% exinterface- coarse edge on the boundary
% exinterface{m} gives the edges of coarse cell M that belong  to the
% boundary
%   Reference 
%     3      
%     4     
%    ...
%     23     
%--------------------------------------------------------------------------
% exinterfaceaxes- coarse edge on the boundary x
% exinterface{m} gives the edges of coarse cell M that belong  to the
% boundary
%      
%    ___2___       1 - Right
%   |       |      2  - Top
% 3 |       | 1    3 - Left
%   |_______|      4 - Bottom
%       4
%   Conection between external interface and axes 
%   Coarse Cell  Right Top Left Bottom
%                 1     2    3    4
%     1    
%     2
%    ...
%    number
%   of coarse
%     cells
% ex: exinterfaceaxes{1,3} - interface of partion 3 located on the left
%
%--------------------------------------------------------------------------
% interfacecenter{} - coordinates of each interface of all coarse cells
% ex: interfacecenter{2}  returns the center coordinate of the interface
% boundary from coarse block 2
%      
%    ___2___       1 -  [1 0.5]
%   |       |      2  - [0.5 1]
% 3 |       | 1    3 -  [0 0.5]
%   |_______|      4 -  [0.5 0]
%       4
%   The number of interfaces may very for each coarse cell
%   The return value is a n x 2 matrix, where n is the number of interfaces.
%
%--------------------------------------------------------------------------
% coarseblockcenter() - coordinates of the center of a coarse block
% ex: coarseblockcenter(3) returns the center of coarse block 3
%      
%    ___2___       
%   |       |      O - [0.25 0.25]
% 3 |   O   | 1   
%   |_______|      
%       4
%   coarseblockcenter is a matrix n x 2, where n is the number of 
%   coarseblocks
%   ex: coarseblockcenter(3) = [0.33 0.45]
%
%--------------------------------------------------------------------------
% numinterface() - return the number of interfaces (sides) of coarseblock
%    Interface 3:  
%    ___2___       
%   |       |      O - [0.25 0.25]
% 3 |   O   | 1   
%   |_______|      
%       4
%	 ex: numinterface(3)  returns 4 (Coarse block 3 has 4 interfaces)
%--------------------------------------------------------------------------
% coarseneigh(i,j) - matrix that returns 1 if i is neighbor to jj
% PS: coarseneigh is [npar npar+1]. A last collumn is added to tell if
% a coarse element is neighbor to the boundary.
%					
%   Ex: npar = 20  
%	 ex: coarseneigh(3,18) returns 1 if 3 and 18 are neighbors;0 otherwise
%		 coarseneigh(14,21) returns 1 if 14 is on the boundary;0 otherwise
%--------------------------------------------------------------------------
% starts only if working in a multiscale mesh
if meshtype == true
    %checking bedges for edges on the border
    %edges from bedges come already oriented
    for i=1:npar
        tmp = find(elemloc( bedge(:,3)) ==i);
        s_tmp = size(tmp);
        exinterface{i} = tmp;
        coarseedge{i} = [tmp, ones(s_tmp(1),1)];
    end
 clear tmp s_tmp
 
    %checking inedges for edges on course boundary partion
    for ii = 1:npar
        for jj = 1:npar
            if ( ii ~= jj)
                intinterface{ii,jj} = [find(elemloc(inedge(:,3)) == ii & elemloc(inedge(:,4)) == jj) ; find(elemloc(inedge(:,3)) == jj & elemloc(inedge(:,4)) == ii)];
            end
        end
    end
    
    %adding internal edges in intiinterface to coarseedges
    
    for ii = 1:npar
        auxmat = [];
        for jj = 1:npar
            if ~isempty(intinterface{ii,jj})
                auxmat = [auxmat ;intinterface{ii,jj}];
            end
        end
        coarseedge{ii} = [coarseedge{ii} ;auxmat , zeros(size(auxmat))];
        
    end
    clear auxmat
    %% splitting edges on the boarder 
    for ii=1:npar
        t = size(exinterface{ii});
        for jj = 1:t(1)
            ref = exinterface{ii}(jj);
            p1 = coord(bedge(ref,1),1:2);
            p2 = coord(bedge(ref,2),1:2);
            dx = p1(1) - p2(1);
            dy = p1(2) - p2(2); 
            if (dy == 0) & (p1(2) == 0) & (p2(2) == 0) 
            % case edge lays on the bottom
                fp = 4;
            elseif (dy == 0) & (p1(2) ~= 0) & (p2(2) ~= 0) 
            % case edge lays on top
                fp = 2;
            elseif (dx == 0) & (p1(1) == 0) & (p2(1) == 0) 
            % case edge lays on the left
                fp = 3;
            else
            % case edge lays on the right
                fp = 1;                               
            end
            exinterfaceaxes{ii,fp} = [exinterfaceaxes{ii,fp} ; ref];
            exinterfaceaxes{ii,fp} = unique(exinterfaceaxes{ii,fp});
        end
        
    end
    
    
    %% collecting data on the number of interfaces and calculating the centers
%     numinterface = zeros([npar 1]);
%     interfacecenter = cell([npar,1]);
    %internal interfaces
    
    for ii = 1 : npar
            acum = 0;
        for jj = 1 : npar
            if ~isempty(intinterface{ii,jj})
                point = centerinterface(intinterface{ii,jj},inedge, coord,elemloc);
                interfacecenter{ii} = [interfacecenter{ii};point];
                acum = acum + 1;
            end
        numinterface(ii) = acum;
        
        end
    end
    
    
    for ii= 1:npar
        acum = 0;
        for jj = 1:4
            if ~isempty(exinterfaceaxes{ii,jj})
                point = centerinterface(exinterfaceaxes{ii,jj},bedge, coord,elemloc);
                interfacecenter{ii} = [interfacecenter{ii};point];
                acum = acum + 1;
            end
        end
        numinterface(ii) = numinterface(ii) + acum;
    end
    
    %% Calculating the center of internal elements
%     coarseblockcenter = zeros([npar 2]);
    for ii = 1 : npar
        point = weiszfeld(interfacecenter{ii});
        coarseblockcenter(ii,1) = point(1);
        coarseblockcenter(ii,2) = point(2);
    end
    
    
    %% Matrix that says which element is neighbor to which
%     
%     for ii = 1:npar
%         t = size(coarseedge{ii});
%         for jj = 1:t(1)
%             flag = coarseedge{ii}(jj,2);
%             if flag
%                q = elemloc(bedge(coarseedge{ii}(jj,1),3));
%                %coarseneigh(ii,npar+1) =  coarseneigh(ii,npar+1) + 1;
%                if q ~= ii
%                   coarseneigh(ii,q) =  coarseneigh(ii,q) + 1;
%                end
%             else
%                q = elemloc(inedge(coarseedge{ii}(jj,1),3));
%                p = elemloc(inedge(coarseedge{ii}(jj,1),4));
%                if q ~= ii
%                   coarseneigh(ii,q) =  coarseneigh(ii,q) + 1;
%                end
%                if p ~= ii
%                   coarseneigh(ii,p) =  coarseneigh(ii,p) + 1;
%                end               
%                
%             end
%         end
%     end
    
    for ii=1:npar
        for jj=1:4
            if ~isempty(exinterfaceaxes{ii,jj})
                 coarseneigh(ii,npar+jj) = coarseneigh(ii,npar+jj) +1;
            end
        end
    end
    
    coarseneigh = any(coarseneigh,3);
    %%checking if neighbors share at least a single point
    %substituir por coarsedge
    for ii = 1:npar
        comp1 = unique(inedge(coarseedge{ii}(find(coarseedge{ii}(:,2) == 0),1),1:2));       
            for jj = 1:npar
                comp2 = unique(inedge(coarseedge{jj}(find(coarseedge{jj}(:,2) == 0),1),1:2));
                check = intersect(comp1,comp2);                
                if ~isempty(check) & (ii ~= jj)
                   coarseneigh(ii,jj) = coarseneigh(ii,jj) +1;
                end
            end
        
    end
    
    intPoint = cell{[npar,1]}
    
    for ii=1:npar
        
        
        
    end
    %%
    disp('Multiscale properties successfully generated');
    
    
end
