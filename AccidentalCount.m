filename = uigetfile('*.out');
Data = importdata(filename)';

Channel = Data(1,:);    % Arrival channel
TimeOfArrival = Data(2,:);    % Arrival time (in picoseconds)
NoOfPhotons = size(Data,2);   % Total number of records
%Delay = [];

CoincidenceCount = 0;
Low = 3;  High = 10;

for n = 1:NoOfPhotons-1
    if Channel(n) ~= Channel(n+1)   % Arrival channel different
        if (TimeOfArrival(n+1) - TimeOfArrival(n) >= Low*1000  && TimeOfArrival(n+1) - TimeOfArrival(n) <= High*1000) 
            CoincidenceCount = CoincidenceCount + 1;
            %Delay = [Delay, TimeOfArrival(n+1) - TimeOfArrival(n)];
        end
    end
end

Accidentals = round((CoincidenceCount/(High - Low))*2.5);