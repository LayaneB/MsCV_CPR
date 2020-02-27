%--------------------------------------------------------------------------
% CENTERINTERFACE
%--------------------------------------------------------------------------
% Generate the coordinates of the center of a interface
%--------------------------------------------------------------------------
% OUTPUT:  center of the interface : 
%                 [0.34044 3.4335]
%--------------------------------------------------------------------------
% INPUT: 
% inter - reference to the interface to be ploted
% edgmtrx - bedge or inedge 
% coord and elemloc
%--------------------------------------------------------------------------
function [ cent_coord ] = centerinterface( inter , edgmtrx,coord, elemloc )
%ex  centerinterface(intinterface{1,2},0, inedge,coord ,elemloc)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
%edgmtrx does not need to be 

flag = size(edgmtrx);
if flag(2) == 4
    flag = 0;
else
    flag = 1;
end
if flag == 0
    leftSide =  elemloc(edgmtrx(inter(1),3));
    rightSide = elemloc(edgmtrx(inter(1),4));
    %rot_vec is a rotation vector. it has the same size of inter
    % it gives true to the edges that need rotation
%     stmp = size(inter);
%     rot_vec = zeros(stmp(1));
    %checking edges that do not have leftSide on the left and rightSide on
    %the rigt. raises a flag True to everytime a swap is needed
    rot_vec = (elemloc(edgmtrx(inter,3)) == rightSide) ;
    % rotating all vectors in the same direction
    orient_edges = changeorientation( edgmtrx(inter,1),edgmtrx(inter,2),rot_vec);
    %sorting in a continuum way
    orient_vec = changeorder(orient_edges,inter);
    %continuum edges
    cont_edges = orient_edges(orient_vec,:);
else
    orient_edges = [ edgmtrx(inter,1) , edgmtrx(inter,2)];
    orient_vec = changeorder(orient_edges,inter);
    cont_edges = orient_edges(orient_vec,:);
end



    %aplicar o algoritmo de interpolação
    tol_c = 0.000001;
    dist = disvec( cont_edges(:,1),cont_edges(:,2) ,coord);
    dist_acum = cumsum(dist);
    dist_med = dist_acum(end)/2;

    lay_on_point =  abs(dist_acum(:) - dist_med) <= tol_c;
    if sum(lay_on_point) ~= 0 
        cent_coord = coord(cont_edges(find(lay_on_point),2),1:2);
    else
        tst = size(inter);
        %pode dar problema
        %excelente exemplo de POG - Programação Orientada a Gambiarra
        if (tst(1) == 1 |tst(1) == 2 )& tst(2) ==1
            pont = 1;
        else
            pont = find(dist_acum <= dist_med , 1,'last');
        end
        
        if tst(1) == 1 & tst(2) ==1
            inter_nodes = cont_edges;
            d = dist_med;
        else
            inter_nodes = cont_edges(pont+1,:);
            d = dist_med - dist_acum(pont);
        end
        %interpoling edge and finding the coordinates of the middle

        
        D = dist(pont);
        
        c1 = coord(inter_nodes(1),1:2);
        c2 = coord(inter_nodes(2),1:2);

        x3 = (d/D) *(c2(1) - c1(1)) + c1(1);
        y3 = (d/D) *(c2(2) - c1(2)) + c1(2);

        cent_coord = [x3,y3];
    end
end

%sort the edge in the same direction
function [ output ] = changeorientation( node1, node2 , flag )
%takes if flag == 1 swaps node 1 e node 2
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    tmp = node2(find(flag));
    node2(find(flag)) = node1(find(flag));
    node1(find(flag)) = tmp;
    output = [node1 node2];
end

function [auxvec] = changeorder(edges,inter)
%returns a permutation vector that connects the edges in a continuum way
%input: an oriented matrix of edges
%output : permutation vector that connects all the edges 
    auxvec = [1: size(inter)];
    

    %%finding out the beggining and end
    uniq_vec = unique([edges(:,1) ;edges(:,2)]);
    start_end = find(histc([edges(:,1) ;edges(:,2)], uniq_vec) == 1);
    start_end_el = uniq_vec(start_end);
    st1 = find(edges(:,1) == start_end_el(1));
    st2 = find(edges(:,1) == start_end_el(2));
    if isempty(st1) 
        start = st2;
    else
        start = st1;
    end
    %%   
    auxvec(start)= 1;
    auxvec(1) = start;
    
    for p1 = 2:size(inter)       
        auxedge = edges(auxvec,:);
        pos = find(auxedge(:,1) == auxedge(p1-1,2));
        tmp = auxvec(p1);
        auxvec(p1) = auxvec(pos);
        auxvec(pos) = tmp;
    end
end

function [d] = disvec(node1, node2,coord)
        c1 = coord(node1,:);
        c2 = coord(node2,:);
        d = ((c1(:,1) - c2(:,1)).^2 + (c1(:,2) - c2(:,2)).^2).^0.5;
    
end