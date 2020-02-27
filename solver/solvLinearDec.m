function [ out ] = solvLinearDec( A,B,elemlist,elemvalue)
%solvLinearDec Solves a linear equation which its order is decreased using pre
%calculated values
% Ax = B
% INPUT - 
% A: Matrix
% B: Column Vector
% elemlist : list of elements(column) which values already known -
% elemvalue: list of values(column) for each element in elemlist

out = zeros(size(B));
logElemList = ismember(1:size(A,1), elemlist);




a = A(~logElemList,~logElemList);

%[A B]
%A(~logElemList,~logElemList)
%A(~logElemList,logElemList)
%elemvalue
%B(~logElemList)

b = B(~logElemList) - A(~logElemList,logElemList)*elemvalue;


%x = a\b;

out(logElemList) = elemvalue;
out(~logElemList) = a\b;

end

