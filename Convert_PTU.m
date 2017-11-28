File = uigetfile('*.ptu');  %Select final file to convert
File = File(1:end-4);   %Deletes '.ptu'
NoOfFiles = str2num(File(end));   %Reads in number of files to convert  
File = File(1:end-1);

for n = 1:NoOfFiles
    FileToConvert = strcat(File,int2str(n),'.ptu');
    Read_PTU2(FileToConvert);
end