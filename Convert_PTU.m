function Convert_PTU(File, NoOfFiles)
% Input: File - Name of file as a string (without number and ptu at end)
%        NoOfFiles - Number of files to convert

for n = 1:NoOfFiles
    FileToConvert = strcat(File,int2str(n),'.ptu');
    Read_PTU2(FileToConvert);
end
