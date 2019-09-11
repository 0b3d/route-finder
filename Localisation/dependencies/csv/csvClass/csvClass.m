classdef csvClass <handle
    %this class can read /write CSV files;
    %elements of the csv can be strings/double/int values
    %if the csv file is only double/int values the speed/ram consumption is
    %much lower than if they were strings
    %CSV format:
    
    %col_1;col_2;...;col_n
    %val1;val2;...;valn_n
    %...
    %val_1;valm_2;...;val_n
    
    %example csv file
        % filename;testCase;testerAngle;line;speed;direction;offset
        % file1.rec;TC01;-30;7;4.5;left;1.9
        % file2.rec;TC01;-30;7;4.6;left;1.8
        % file3;TC02;-60;1;0.2;right;90
    
    properties(Access = public)
        signals ={};
        data =[];%an cell array
        nrcycles = 0;
        filename ={};
        format_str=[];
        format_str_Cell ={};%contain a cell of strings
        file_delim = ';'
    end
    
    methods
        function this = csvClass(fileDelim)
            if nargin ==1
                assert(ischar(fileDelim), 'Please enter a char for file delimiter');
                this.file_delim = fileDelim;
            end
        end
        function openCSV(this, filenamePath)
            
            this.data=[];
            this.filename=[];
            this.nrcycles=[];
            this.signals=[];
            %open the csv file and reads it
            if nargin ==2
                %if we enter the file path
                try
                    assert(exist(filenamePath,'file')>0,'Please enter an existing file on the hard drive');
                    catch e
                        errordlg(['Line:', num2str(e.stack(1,1).line ),'|Func:', e.stack(1,1).name, '|Msg:', e.message]);
                        rethrow (e);%for console debugging
                end
                CSV_File =filenamePath;
            else
                [f,d] = uigetfile('*.csv;*.bin', 'select *.csv or *.bin file', 'MultiSelect', 'off');
                if(isempty(f ))
                    return;
                else
                    CSV_File = [d,f];
                end
            end
 
            this.filename = CSV_File;
            fid = fopen(CSV_File,'r');
            fseek(fid, 0, 'eof');
            filesize = ftell(fid);
            % Move back to the start of the file
            frewind(fid);
            assert(fid ~= -1,'Couldnt open the file');
            
            header_str = fgetl(fid);
            % Parse the header string into separate headers
            header_cell = textscan(header_str,'%s','delimiter',this.file_delim);
            header_cell= header_cell{1};
            
            % Read the first line of data  after header line to determine the column data types
            [data,fidpos] = textscan(fid,'%s',length(header_cell),'delimiter',this.file_delim);
            data= data{1}';
  
            % Check the contents of each column and contruct a column format specifier
            % string
            format_str = [];
            format_str_Cell ={};
            for i = 1:length(data)
                % If str2num returns a numeric value, then the column in numeric,
                % otherwise if str2num returns empty, then the column is text
                if ~isnan(str2double(data{i}))
                    col_format = '%f';
                else
                    col_format = '%s';
                end
                format_str = [format_str col_format]; %#ok<AGROW>
                format_str_Cell{i} =col_format;
            end
            this.format_str = format_str;
            this.format_str_Cell = format_str_Cell;
            clear format_str format_str_Cell;            


            %set output signals
            this.signals = header_cell;
            this.nrcycles=0;
            tic;
            oldPos = fidpos;
            while((fidpos  ~= filesize) && (~isempty(data{1})))
                %assign struct values to signal struct
                this.nrcycles = this.nrcycles + 1;    
                [~, fidpos]= textscan(fid,this.format_str,1,'delimiter',this.file_delim);
            end
            fidpos  =oldPos;
            fseek(fid, fidpos, 'bof');
            isCellArray = false;
            if this.isCellArray()
                isCellArray =true;
                tempData=cell (length(data),this.nrcycles);
            else
                nrLines = length(data);
                nrCol = this.nrcycles;
                tempData=zeros(nrLines,nrCol);
            end
            
            frewind(fid);
            this.nrcycles =0;
            [data,fidpos] = textscan(fid,'%s',length(header_cell),'delimiter',this.file_delim);%skip header
            [data fidpos]= textscan(fid,this.format_str,1,'delimiter',this.file_delim);%read the first line
            if ~this.isCellArray()
                    data = cell2mat(data);
            end
            while((fidpos  ~= filesize))
                %assign struct values to signal struct
                this.nrcycles = this.nrcycles + 1;
                tempData(1:length(data),this.nrcycles) = data';
                [data fidpos]= textscan(fid,this.format_str,1,'delimiter',this.file_delim);
                if ~isCellArray
                    data = cell2mat(data);
                end
                fprintf(1,'\b\b\b\b\b\b\b\b...%3d%% ', round((fidpos/filesize) *100));
            end
            this.data =tempData;
            clear tempData;
            toc;
            fclose(fid);
            fprintf('\n Finished loading the file !');
        end

        function r = getSignalValue(this, name)
            %get the array 'signal name' which is a column in the CSV
            %returns a line array with nr elements = nr cycles
            r=[];
            sigId = this.getSignalId(name);
            nrCycles =this.getNrCycles();
            if sigId > 0
                r = this.data(sigId,1:nrCycles)';
            end
        end
        
        function r = deletSig(this, name1, name2)
            %deletes from csv signal name1 if only one param is given or
            %signals between [name1, name2] inclusive
            r = false;
            assert(nargin >1 && nargin < 4  ,'Please enter at least one signal name !');
            if nargin == 2
                sigId1 = this.getSignalId(name1);
                assert(sigId1 > 0, 'Couldnt find %s in CSV file',name1);
                %delete only one signal
                this.data(sigId1,:)=[];
                this.signals(sigId1)= [];
                this.format_str_Cell(sigId1)=[];
                
            else
                sigId1 = this.getSignalId(name1);
                sigId2 = this.getSignalId(name2);                
                
                assert(sigId1 >0 &&  sigId2> 0, 'Couldnt find %s or %s in CSV file',name1, name2);
                
                this.data(min(sigId1,sigId2):max(sigId1,sigId2),:)=[];
                this.signals(min(sigId1,sigId2):max(sigId1,sigId2))= [];
            end
            r= true;
        end
        
        function r = getSignalId(this, name)
            %returns -1 or signal ID
            assert(ischar(name) >0, 'Please enter a signal name !');
            r = find(strcmp(this.signals,name));
            if isempty(r)
                r = -1;
            end
        end
        
        function saveCsv(this, path ,csvName)
            %save the csv
            try
                assert(~isempty(path) && ~isempty(csvName),'Path or filename empty');
                if path(end)~= '\'
                    path(end+1)= '\';
                end
                
                f= fopen([path csvName],'w');
                assert(f >0 ,'cannot create file %s',[path csvName]);
            catch e
                errordlg(['Line:', num2str(e.stack(1,1).line ),'|Func:', e.stack(1,1).name, '|Msg:', e.message]);
                rethrow (e);%for console debugging
            end
            
            nrCol = this.getNrCycles();
            nrLines = this.getNrSignals();
            %assert(~this.isCellArray, Function not implemented for Cell arrays at the moment !');
            %print the header
            temp = this.signals';
            for k = 1:nrLines
                if k == nrLines
                    str ='%s';
                else
                    str = '%s;';
                end
              fprintf(f, str, temp{k});
            end
            fprintf(f, '\n');
            if ~this.isCellArray()
                for k = 1:nrCol
                    fprintf(f, '%f;', this.data(:,k) );
                    fprintf(f, '\n');
                    fprintf(1,'\b\b\b\b\b\b\b\b...%3d%% ', round((k/nrLines) *100));
                end
            else%slow
                for k = 1:nrCol%columns
                    for i =1:nrLines%lines
                        if i== nrLines
                            formatStr = [this.format_str_Cell{i}];
                        else
                            formatStr = [this.format_str_Cell{i} ';'];
                        end
                        if iscell(this.data{i,k})
                            data = cell2mat(this.data{i,k});
                        else
                            data = this.data{i,k};
                        end
                        fprintf(f, formatStr, data);
                    end
                    fprintf(f, '\n');
                    fprintf('\b\b\b\b\b\b\b\b...%3d%% ', round((k/nrLines) *100));
                end
            end
            clear temp;
            fclose(f);
            fprintf('\nFile saved with success ! ');
        end
        
        function r = getNrCycles(this)
            %get nr of lines in the csv
            r = size(this.data,2);
            
        end
        function r= getNrSignals(this)
            r = size(this.data,1);
        end
        
        function r = getSignals(this)
            r = this.signals;
        end
        
        function r = isCellArray(this)
            %checks if data contains only double values
            %if this.data contains only double values then we have a matrix
            %of double, else we have a matrix of cell arrays
            r= false;
            if regexpi(this.format_str, 's', 'start')
                r=true;
            end
        end
        
        function r = isEmpty(this)
            r= false;
            if isempty(this.data)
                r= true;
            end
        end
    end
end

