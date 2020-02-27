function [ OP] = genProlongationOperator(OPb, TransFc,w,maxint )
%genProlongationOperator Generates Prolongation Operator
%   INPUT:
%   nelem = number of elements in the mesh
%   npar = number of partions
%   maxint = max number of iteration

%   OUTPUT:
%   OP = prolongation operator

    %TransFc = full(TransFc);
    flag = 0;
    global GlobalBoundary  outSupport wells elemloc
    %Dinv = sparse( diag(1./TransFc(1:size(TransFc,1)+1:end)));
    %Dinv = sparse( diag(bsxfun(@ldivide,spdiags(TransFc,0),1)) );
    Dinv =  spdiags(bsxfun(@ldivide,spdiags(TransFc,0),1),0,size(TransFc,1) ,size(TransFc,1) );
    
    %spdiags(TransFC,0)
    %OP = sparse(zeros(size(OPb)));
    OP = spalloc( size(OPb,1), size(OPb,2),nnz(OPb)*2);
    index2 = 1;
    intError = zeros(maxint,1);
    
    %Fa = [F F F F F F F F F F F F F F F];
    for index = 1: maxint
        %d = full( -w*((Dinv*(TransFc*OPb))))  ;
        d =  -w*((Dinv*(TransFc*OPb )))  ;
        %d = full(d);
        maxD= max(d(~GlobalBoundary,:));       
        %d(outSupport) = 0;   
        d = d.*~outSupport;
        intError(index) = norm(maxD);
        d = sparse(d);
        OP = d + OPb;
        %index
        %sum( OP(GlobalBoundary,:)
        OP(GlobalBoundary,:) = bsxfun(@rdivide, OP(GlobalBoundary,:) ,sum( OP(GlobalBoundary,:) ,2));
        %OP(GlobalBoundary,:) = OP(GlobalBoundary,:)./(sum(OP(GlobalBoundary,:),2)*(1?));
           % [index ant intError(index)]
        %OP(GlobalBoundary,:) = bsxfun(@rdivide, OP(GlobalBoundary,:) ,sum( OP(GlobalBoundary,:) ,2));
        %OP(GlobalBoundary,:) = bsxfun(@rdivide, OP(GlobalBoundary,:) ,sum( OP(GlobalBoundary,:) ,2));

         %use tol  0.00001
%          
         if index ~= 1
             if abs(intError(index)) < 0.000000001 ||  abs( intError(index) - intError(index-1)) < 0.000000001        %abs(intError(index) / intError(index-1)) > 1.02
                 %index
                 break
             end
         end
% 
% 
%          if abs(intError(index)) < 0.001
%              break
%          end
% %          if (( abs( intError(index+1) - intError(index))) < 0.00001 || (intError(index) < 0.0001)) && index ~= 0        	
%       
%              break
%          end

% % % 
%          if rem(index,1) == 0
%              postprocessorDebugS(full(OPb(:,11)),0,0,0,index,0,0,0,0,0);
%              index2 = index2+1;
%          end
%         

        
        OPb = OP;
       
    end
    
%     if flag == 1
%       OP =  bsxfun(@minus,OP,min(OP));
%       OP =  bsxfun(@rdivide, OP,sum(OP,2));    
%     end
% 
%     tag = wells(:,end-1)>500;
%     welltmp = wells(:,1);
%     dirWell = welltmp(tag);
%     cLoc = elemloc(dirWell);
    
end

