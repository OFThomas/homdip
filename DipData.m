% Gets coincidences for the dip from all the files

Dist = 28780:2:28920;
NoOfMeasurements = length(Dist);
Coincidences = zeros(length(Dist));

for n = 1:NoOfMeasurements
    % Convert .ptu to .out file
    PTUfile = strcat('d',int2str(Dist(n)),'.ptu');
    Read_PTU2(PTUfile);
    
    % Get data from .out file
    OUTfile = strcat('d',int2str(Dist(n)),'.out');
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
end

