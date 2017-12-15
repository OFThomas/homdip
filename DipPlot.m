% Code to plot the dip and fit a curve

% Get the coincidence data for the plot
%DipData;
Accidentals = Accidentals_nf;
Coincidences = Coincidences_nf;
Dist = Dist_nf;

% Distance in um and centred on the dip
Distum = (Dist-median(Dist))*1000;

% Fit combination of sinc and gaussian
%fitEqn = '(a1*x + a2)*(1 - sinc(b*(x-c))*exp(-((x-c)/d)^2)) + e';
%StartPts = [0.1 max(Coincidences) 0.01 0 100 min(Coincidences)];
fitEqn = 'a*(1 - exp(-((x-c)/d)^2)) + e';
StartPts = [max(Coincidences) 0 0.5 min(Coincidences)];

% Plot graph
f = fit(Distum', Coincidences', fitEqn, 'Start', StartPts);
figure;
%p = plot(f, Distum, Coincidences);
hold on;
plot(Distum, Accidentals,'.c','MarkerSize',10);
%set(p, 'LineWidth', 1.2);
%set(p, 'MarkerSize', 10);
plot(Distum, Coincidences, '.b','MarkerSize',10);
plot(Distum, Coincidences, '-r');
xlim([min(Distum) max(Distum)]);
%xlim([-70 70]);
ylim([0 max(Coincidences+1000)]);
xlabel('Path Difference \mum');
ylabel('Coincidences / s');
legend('Data','Fitted','Accidentals');
