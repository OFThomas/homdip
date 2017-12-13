% Gets coincidences for the dip from all the files

FileNames = importdata('homdipdata.txt');
NoOfMeasurements = length(FileNames);
Coincidences = zeros(1,NoOfMeasurements);
Dist = zeros(1,NoOfMeasurements);

for n = 1:NoOfMeasurements
    % Convert .ptu to .out file
    PTUfile = char(FileNames(n));
    Read_PTU2(PTUfile);
    
    % Get data from .out file
    OUTfile = strcat(PTUfile(1:end-4),'.out');
    Data = importdata(OUTfile)';
    Channel = Data(1,:);    % Arrival channel
    TimeOfArrival = Data(2,:);    % Arrival time (in picoseconds)
    NoOfPhotons = size(Data,2);   % Total number of records
    
    % Work out number of coincidences
    for m = 1:NoOfPhotons-1
        if Channel(m) ~= Channel(m+1)   % Arrival channel different
            if TimeOfArrival(m+1) - TimeOfArrival(m) <= 2500 % 2.5ns window
                Coincidences(n) = Coincidences(n) + 1;
            end
        end
    end
    
    Dist(n) = str2double(PTUfile(1:end-4));
end


