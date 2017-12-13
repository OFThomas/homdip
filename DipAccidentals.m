% Gets average accidentals for the dip from all the files

FileNames = importdata('homdipdata.txt');
NoOfMeasurements = length(FileNames);
Accidentals = zeros(1,NoOfMeasurements);

for n = 1:NoOfMeasurements
    % Convert .ptu to .out file
    PTUfile = char(FileNames(n));
    
    % Get data from .out file
    OUTfile = strcat(PTUfile(1:end-4),'.out');
    Data = importdata(OUTfile)';
    Channel = Data(1,:);    % Arrival channel
    TimeOfArrival = Data(2,:);    % Arrival time (in picoseconds)
    NoOfPhotons = size(Data,2);   % Total number of records
    
    % Work out number of coincidences
    Coincidences = 0;
    for m = 1:NoOfPhotons-1
        if Channel(m) ~= Channel(m+1)   % Arrival channel different
            if (TimeOfArrival(m+1) - TimeOfArrival(m) >= 3000  && TimeOfArrival(m+1) - TimeOfArrival(m) <= 10000)
                Coincidences = Coincidences + 1;
            end
        end
    end
    
    Accidentals(n) = round(2.5*Coincidences/7); 
end