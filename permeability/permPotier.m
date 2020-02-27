function [out] = permPotier( x,y )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
        out = cos(x.^0.25 + y.^0.25)*sqrt(4*pi) .* exp((1/pi)*cos(x.^10+y.^10))*0.0001 + 1 + 1*cos(x.^0.25 .*  y.^0.25);
        out = out*100;
end

