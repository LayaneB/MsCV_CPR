function [ flow ] = compoundFlow( flowPp, flowPd, bedgeSize)
%UNTITLED Summary of this function goes/ here
%   Detailed explanation goes here
    global edgesOnCoarseBoundary
    refEdges = edgesOnCoarseBoundary + bedgeSize;
    flow = flowPp;
    flow(refEdges) = flowPd;
end

