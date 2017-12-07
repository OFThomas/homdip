% Code to plot the dip and fit a curve

% Comment this out if it has already been run
% Get the coincidence data for the plot
%DipData;

plot(Dist, Coincidences, '.b','MarkerSize',10);

fitEqn = 'a + b*sinc(c*x)*exp(-((x-d)/e)^2)';
xlim([779990 920710]);
ylim([0 21000]);
StartPts = [];
title('HOM Dip!!!');