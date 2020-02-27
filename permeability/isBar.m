function [ out ] = isBar (x,y, varargin)
%isBar Takes multiple barriers and returns 1 if element is inside and 0
%if eleemnt is outside
%   Detailed explanation goes here


out = zeros(size(x,1),1);

for index = 1:size(varargin,2)
    out = orLogic(out,varargin{index}{2} * inpolygon(x,y,varargin{index}{1}(:,1),varargin{index}{1}(:,2)));    
end

end

