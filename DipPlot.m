% Code to plot the dip and fit a curve

% Get the coincidence data for the plot
%DipData;

% Distance in um and centred on the dip
Distum = (Dist-median(Dist))*100;

% Fit combination of sinc and gaussian
fitEqn = 'a*(1 - sinc(b*(x-c))*exp(-((x-c)/d)^2)) + e';
StartPts = [max(Coincidences) 0.01 0 100 min(Coincidences)];

% Plot graph
f = fit(Distum', Coincidences', fitEqn, 'Start', StartPts);
p = plot(f, Distum, Coincidences);
set(p, 'MarkerSize',10);
xlim([min(Distum) max(Distum)]);
ylim([0 max(Coincidences+1000)]);
xlabel('Path Difference \mum');
ylabel('Coincidences / s');
title('HOM Dip');