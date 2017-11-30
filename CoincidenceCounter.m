% Open file and read in data
filename = uigetfile('*.out');
Data = importdata(filename)';

Channel = Data(1,:);    %Arrival channel
TimeOfArrival = Data(2,:);  %Arrival time (in picoseconds)
NoOfPhotons = size(Data,2); %Total number of records
Delay = [];

CoincidenceCount = 0;
TimeWindow = 5;

for n = 1:NoOfPhotons-1
    if Channel(n) ~= Channel(n+1)   %Arrival channel different
        if TimeOfArrival(n+1) - TimeOfArrival(n) <= TimeWindow*1000  
            CoincidenceCount = CoincidenceCount + 1;
            Delay = [Delay, TimeOfArrival(n+1) - TimeOfArrival(n)];
        end
    end
end

CoincidenceCount
Delay = Delay/1000; % Delay is given in ns

[y, x] = hist(Delay, 100);
histogram(Delay, 100);  % Plot histogram

gaussEqn = 'a*exp(-((x-b)/c)^2)+d';  % Fit gaussian
StartPts = [350 1.5 0.5 10];  
f = fit(x', y', gaussEqn, 'Start', StartPts)

hold on;
p = plot(f,x,y);
set(p, 'MarkerSize',0.1);
set(p, 'LineWidth',1.5);
legend('off');
title(['Time distribution of ', num2str(CoincidenceCount),' coincidences']);
xlabel('Time (ns)');
ylabel('Counts');




