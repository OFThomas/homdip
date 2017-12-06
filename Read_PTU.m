function Read_PTU % Read PicoQuant Unified TTTR Files
% This is demo code. Use at your own risk. No warranties.
% Marcus Sackrow, PicoQuant GmbH, December 2013
% Peter Kapusta, PicoQuant GmbH, November 2016
% Edited script: text output formatting changed by KAP.

% Note that marker events have a lower time resolution and may therefore appear
% in the file slightly out of order with respect to regular (photon) event records.
% This is by design. Markers are designed only for relatively coarse
% synchronization requirements such as image scanning.

% T Mode data are written to an output file [filename].out
% We do not keep it in memory because of the huge amout of memory
% this would take in case of large files. Of course you can change this,
% e.g. if your files are not too big.
% Otherwise it is best process the data on the fly and keep only the results.

% All HeaderData are introduced as Variable to Matlab and can directly be
% used for further analysis

    % some constants
    tyEmpty8      = hex2dec('FFFF0008');
    tyBool8       = hex2dec('00000008');
    tyInt8        = hex2dec('10000008');
    tyBitSet64    = hex2dec('11000008');
    tyColor8      = hex2dec('12000008');
    tyFloat8      = hex2dec('20000008');
    tyTDateTime   = hex2dec('21000008');
    tyFloat8Array = hex2dec('2001FFFF');
    tyAnsiString  = hex2dec('4001FFFF');
    tyWideString  = hex2dec('4002FFFF');
    tyBinaryBlob  = hex2dec('FFFFFFFF');

    % Globals for subroutines
    global fid
    global TTResultFormat_TTTRRecType;
    global TTResult_NumberOfRecords; % Number of TTTR Records in the File;
    global MeasDesc_GlobalResolution;

    TTResultFormat_TTTRRecType = 0;
    TTResult_NumberOfRecords = 0;
    MeasDesc_GlobalResolution = 0;

    % start Main program
    [filename, pathname]=uigetfile('*.ptu', 'T-Mode data:');
    fid=fopen([pathname filename]);

    fprintf(1,'\n');
    Magic = fread(fid, 8, '*char');
    if not(strcmp(Magic(Magic~=0)','PQTTTR'))
        error('Magic invalid, this is not an PTU file.');
    end
    Version = fread(fid, 8, '*char');
    fprintf(1,'Tag Version: %s\n', Version);

    % there is no repeat.. until (or do..while) construct in matlab so we use
    % while 1 ... if (expr) break; end; end;
    while 1
        % read Tag Head
        TagIdent = fread(fid, 32, '*char'); % TagHead.Ident
        TagIdent = (TagIdent(TagIdent ~= 0))'; % remove #0 and more more readable
        TagIdx = fread(fid, 1, 'int32');    % TagHead.Idx
        TagTyp = fread(fid, 1, 'uint32');   % TagHead.Typ
                                            % TagHead.Value will be read in the
                                            % right type function
        if TagIdx > -1
          EvalName = [TagIdent '(' int2str(TagIdx + 1) ')'];
        else
          EvalName = TagIdent;
        end
        fprintf(1,'\n   %-40s', EvalName);
        % check Typ of Header
        switch TagTyp
            case tyEmpty8
                fread(fid, 1, 'int64');
                fprintf(1,'<Empty>');
            case tyBool8
                TagInt = fread(fid, 1, 'int64');
                if TagInt==0
                    fprintf(1,'FALSE');
                    eval([EvalName '=false;']);
                else
                    fprintf(1,'TRUE');
                    eval([EvalName '=true;']);
                end
            case tyInt8
                TagInt = fread(fid, 1, 'int64');
                fprintf(1,'%d', TagInt);
                eval([EvalName '=TagInt;']);
            case tyBitSet64
                TagInt = fread(fid, 1, 'int64');
                fprintf(1,'%X', TagInt);
                eval([EvalName '=TagInt;']);
            case tyColor8
                TagInt = fread(fid, 1, 'int64');
                fprintf(1,'%X', TagInt);
                eval([EvalName '=TagInt;']);
            case tyFloat8
                TagFloat = fread(fid, 1, 'double');
                fprintf(1, '%e', TagFloat);
                eval([EvalName '=TagFloat;']);
            case tyFloat8Array
                TagInt = fread(fid, 1, 'int64');
                fprintf(1,'<Float array with %d Entries>', TagInt / 8);
                fseek(fid, TagInt, 'cof');
            case tyTDateTime
                TagFloat = fread(fid, 1, 'double');
                fprintf(1, '%s', datestr(datenum(1899,12,30)+TagFloat)); % display as Matlab Date String
                eval([EvalName '=datenum(1899,12,30)+TagFloat;']); % but keep in memory as Matlab Date Number
            case tyAnsiString
                TagInt = fread(fid, 1, 'int64');
                TagString = fread(fid, TagInt, '*char');
                TagString = (TagString(TagString ~= 0))';
                fprintf(1, '%s', TagString);
                if TagIdx > -1
                   EvalName = [TagIdent '{' int2str(TagIdx + 1) '}'];
                end
                eval([EvalName '=[TagString];']);
            case tyWideString
                % Matlab does not support Widestrings at all, just read and
                % remove the 0's (up to current (2012))
                TagInt = fread(fid, 1, 'int64');
                TagString = fread(fid, TagInt, '*char');
                TagString = (TagString(TagString ~= 0))';
                fprintf(1, '%s', TagString);
                if TagIdx > -1
                   EvalName = [TagIdent '{' int2str(TagIdx + 1) '}'];
                end
                eval([EvalName '=[TagString];']);
            case tyBinaryBlob
                TagInt = fread(fid, 1, 'int64');
                fprintf(1,'<Binary Blob with %d Bytes>', TagInt);
                fseek(fid, TagInt, 'cof');
            otherwise
                error('Illegal Type identifier found! Broken file?');
        end
        if strcmp(TagIdent, 'Header_End')
            break
        end
    end
    fprintf(1, '\n----------------------\n');
    outfile = [pathname filename(1:length(filename)-4) '.out'];
    global fpout;
    fpout = fopen(outfile,'W');
    % Check recordtype
    fprintf(1,'PicoHarp T2 data\n');
    
    fprintf(1,'\nWriting data to %s', outfile);
    fprintf(1,'\nThis may take a while...');

    global cnt_ph;
    global cnt_ov;
    global cnt_ma;
    cnt_ph = 0;
    cnt_ov = 0;
    cnt_ma = 0;
    % choose right decode function
    ReadPT2;

    fclose(fid);
    fclose(fpout);
    fprintf(1,'Ready!  \n\n');
    fprintf(1,'\nStatistics obtained from the data:\n');
    fprintf(1,'\n%i photons, %i overflows, %i markers.',cnt_ph, cnt_ov, cnt_ma);

    fprintf(1,'\n');
end


%% Read PicoHarp T2
function ReadPT2
    global fid;
    global fpout;
    global TTResult_NumberOfRecords; % Number of TTTR Records in the File;
    global cnt_ph;
    global cnt_ov;
    global MeasDesc_GlobalResolution;
    ofltime = 0;
    WRAPAROUND = 210698240;
    SHIFT = 268435455;
    TimeRes = MeasDesc_GlobalResolution * 1e12;

    for i = 1:TTResult_NumberOfRecords
        T2Record = fread(fid, 1, 'ubit32');
        T2time = bitand(T2Record,SHIFT);             %the lowest 28 bits
        chan = bitand(bitshift(T2Record,-28),15);      %the next 4 bits
        timetag = T2time + ofltime;
        if chan <= 1
            cnt_ph = cnt_ph + 1;
            fprintf(fpout,'\n%i %0.1f' , chan, (timetag*TimeRes));
        else
            if chan == 15
                ofltime = ofltime + WRAPAROUND; % unwrap the time tag overflow
                cnt_ov = cnt_ov + 1;
            end
        end
    end
end
