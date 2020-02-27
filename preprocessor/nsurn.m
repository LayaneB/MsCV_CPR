function [ out ] = nsurn(node, inp, region )
%ESURN 
%   inp == 1 : return de number of elements around inside region
%   inp == 2 : return de number of elements itself inside region
%   inp == 3 : return ref

global nsurn1 nsurn2 elemloc pointloc

point = nsurn2(node)+1;
length = nsurn2(node+1) - nsurn2(node);
node = nsurn1(point :(point+length-1));

%out = node


ref = false(size(node,1),1);
for ii = 1 : size(node,1)
    nodeRef = node(ii);
    
    if sum( ismember(pointloc{nodeRef},region)) > 0
        ref(ii) = true;
   
    end
    
end


if inp == 1
    out = sum(ref) ;
elseif inp == 2
    out = node(ref);
else
    out = ref;
end

end

