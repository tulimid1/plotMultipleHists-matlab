function plotMutlipleHists(varargin)
%{
Plot multiple vectors on the same figure but make sure the bins and limits
align

INPUTS:
varargin: 
    vectors of data 

OUTPUT:
Figure with multiple histograms that have align edges 
%}

% check arguments are vectors 
arguments (Repeating)
    varargin (1,:) {mustBeVector}
end

numVectors = length(varargin); 

h = gobjects([numVectors, 1]); % pre-allocate 
f = gobjects([numVectors, 1]); 
binDistances = nan([numVectors, 1]);

for n = 1:numVectors
    % plot individually to get individual bin edges 
    f(n) = figure('visible', 'off');
    h(n) = histogram(varargin{n}); 
    binDistances(n) = calculateDistanceBtwEdges(h(n)); 
end
overallLimits = determineLargestLimits(h); 
delta = determineSmallestDelta(binDistances); 
close(f)
plotAll(varargin, overallLimits, delta)
end

function plotAll(data, limits, delta)
figure();
edges = limits(1):delta:limits(2); 
for i =1:length(data)
    histogram(data{i}, 'binlimits', limits, 'binedges', edges);
    if i == 1
        hold on
    end
end
ylabel('Frequency')
set(gca, 'fontsize', 16)
end

function smallestDelta = determineSmallestDelta(distances)
smallestDelta = min(distances); 
end

function limitsRange = determineLargestLimits(h)
limits = nan([length(h), 2]); 
for i = 1:length(h)
    limits(i,:) = h(i).BinLimits; 
end
limitsRange = [min(limits(:,1)), max(limits(:,2))]; 
end

function distances = calculateDistanceBtwEdges(h)
distances = h.BinWidth; 
end

