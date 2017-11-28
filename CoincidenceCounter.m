% Open file and read in data
filename = uigetfile('*.out');
fileID = fopen(filename); 
Data = fscanf(fileID, '%d %f', [2 Inf]);
fclose(fileID);

Channel = Data(1,:);    %Arrival channel
TimeOfArrival = Data(2,:);  %Arrival time (in picoseconds)
NoOfPhotons = size(Data,2); %Total number of records

CoincidenceCount = 0;

for n = 1:NoOfPhotons-1
    if Channel(n) ~= Channel(n+1)   %Arrival channel different
        if TimeOfArrival(n+1) - TimeOfArrival(n) <= 10000   %10ns apart
            CoincidenceCount = CoincidenceCount + 1;
        end
    end
end

CoincidenceCount