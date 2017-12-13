% Open file and read in data
filename = uigetfile('*.out');
Data = importdata(filename)';

Channel = Data(1,:);    % Arrival channel
TimeOfArrival = Data(2,:);    % Arrival time (in picoseconds)
NoOfPhotons = size(Data,2);   % Total number of records
Delay = [];

CoincidenceCount = 0;
TimeWindow = 2.5;

for n = 1:NoOfPhotons-1
    if Channel(n) ~= Channel(n+1)   % Arrival channel different
        if TimeOfArrival(n+1) - TimeOfArrival(n) <= TimeWindow*1000  
            CoincidenceCount = CoincidenceCount + 1;
            Delay = [Delay, TimeOfArrival(n+1) - TimeOfArrival(n)];
        end
    end
end

Delay = Delay/1000; % Delay between photons is given in ns

BinWidth = 0.025;  % 100 bins for every 2.5ns
NoOfBins = TimeWindow/BinWidth;

% Fit gaussian to the histogram
[y, x] = hist(Delay, NoOfBins);
gaussEqn = 'a*exp(-((x-b)/c)^2/2)+d';  
StartPts = [max(y) 1.5 0.5 min(y)];  
f = fit(x', y', gaussEqn, 'Start', StartPts);
coeffs = coeffvalues(f);
% Important information from fitted model
Mean = coeffs(2);
StandardDeviation = coeffs(3);
Accidentals = round(NoOfBins*coeffs(4));

% Plot histogram and fitted Gaussian
figure;
histogram(Delay, NoOfBins);  
hold on;
p = plot(f,x,y);
set(p, 'MarkerSize',0.01);
set(p, 'LineWidth',1.5);
legend('off');
title([filename, ' Time distribution of ', num2str(CoincidenceCount),' coincidences'], 'Interpreter','none');
xlabel('Time (ns)');
ylabel('Counts');
hold off;




