File = uigetfile('*.ptu');  %Select final file to convert
File = File(1:end-4);   %Deletes '.ptu'
NoOfFiles = str2num(File(end));   %Reads in number of files to convert  
File = File(1:end-1);

for n = 1:NoOfFiles
    FileToConvert = strcat(File,int2str(n),'.ptu');
    Read_PTU2(FileToConvert);
end


% Add everything to one big file
BigFile = fopen(strcat(File,'.out'),'W');
for n = 1:NoOfFiles
    % Retrieve data from small files
    FileToConvert = strcat(File,int2str(n),'.out');
    SmallFile = fopen(FileToConvert);   
    Data = fscanf(SmallFile, '%d %f', [2 Inf]);
    fclose(SmallFile);
    
    % Adjust time of arrival
    Data(2,:) = Data(2,:) + (n-1)*60e12;
    
    % Add to big file
    fprintf(BigFile, '%d %20.1f\n', Data);
end
fclose(BigFile);

