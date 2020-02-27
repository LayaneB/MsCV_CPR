function [ A,B ] = minusTPFA( edgesOnCoarseBoundary, pc,  A,B,Ted)
%minusTPFA - function that decouples the matrix
% takes it out the influence of the edges on the coarse boundary

%minusTPFA(edgesOnCoarseBoundary,TransF,F,tEq(edgesOnCoarseBoundary));
    global inedge coarseElemCenter

    %% minush the edges of the coarse volume
    ii = edgesOnCoarseBoundary;
    [r,c] = size(A);
    sub2indVec = @(ol1,oc1,ol2,oc2,ol3,oc3,ol4,oc4) [ (ol1+r.*(oc1-1)) (ol2+r.*(oc2-1)) (ol3+r.*(oc3-1)) (ol4+r.*(oc4-1))];
%     sub2indVecSingle = @(ol1,oc1)  (ol1+r.*(oc1-1));
%     normVec = @(x,y,z) sqrt( x.^2+ y.^2 + z.^2);
    GlobalPoint = sub2indVec(inedge(ii,3) , inedge(ii,3),inedge(ii,3) , inedge(ii,4),inedge(ii,4) , inedge(ii,3),inedge(ii,4) , inedge(ii,4));
    LM = localMatrix(Ted, Ted); 
    
    for i=1:size(LM,1)
%         results = GlobalPoint(i,:);
%         [a1, a2] = ind2sub(size(A),results(1));
%         [b1, b2] = ind2sub(size(A),results(2));
%         [c1, c2] = ind2sub(size(A),results(3));
%         [d1, d2] = ind2sub(size(A),results(4));

%         antes =  A(GlobalPoint(i,:));
        A(GlobalPoint(i,:)) =  A(GlobalPoint(i,:)) - LM(i,:) ;
%         depois = A(GlobalPoint(i,:));
    end    
    
%     %% adding dirichlet boundary conditions
%     for index = 1:size(coarseElemCenter,1)
%         refElem = coarseElemCenter(index);
%         A(refElem,:) = 0;
%         A(refElem,refElem) = 1;
%         B(refElem) = pc(index);        
%     end
%     
    
end

function [out] = localMatrix(TedL, TedR) 
        %[ lambd, TedL, TedR] 
        out = [-TedL , TedL, TedR, -TedR];
end
