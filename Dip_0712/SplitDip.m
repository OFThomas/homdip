%
FileNames = importdata('dipout.txt');
NoOfMeasurements = length(FileNames);
Coincidences = zeros(4,NoOfMeasurements);
Dist = zeros(1,NoOfMeasurements);

qps = 2.5e11;  % 1/4s in ps

for n = 1:NoOfMeasurements
    File = char(FileNames(n));
    Data = importdata(File)';
    Channel = Data(1,:); 
    TimeOfArrival = Data(2,:);    % Arrival time (in picoseconds)
    NoOfPhotons = size(Data,2);

    for m = 1:NoOfPhotons-1
        for k = 1:4
            if ((TimeOfArrival(m)) < k*qps && (TimeOfArrival(m) > (k-1)*qps))
                if ((Channel(m) ~= Channel(m+1)) && TimeOfArrival(m+1) - TimeOfArrival(m) <= 2500)  
                    Coincidences(k,n) = Coincidences(k,n) + 1;
                end
            end
        end
    end      
    
    Dist(n) = str2double(File(1:end-4));
end
%}
CoincMean = mean(Coincidences,1);
figure;
plot(Dist,Coincidences);
axis tight;

figure;
plot(Dist,Coincidences);
hold on;
plot(Dist,CoincMean,'.b','MarkerSize',10);
hold off;
axis tight;

figure;
plot(Dist,CoincMean,'.b','MarkerSize',10);
axis tight;