function DaneMiasta = importfile(workbookFile, sheetName, startRow, endRow)
%IMPORTFILE Import data from a spreadsheet
%  DANEMIASTA = IMPORTFILE(FILE) reads data from the first worksheet in
%  the Microsoft Excel spreadsheet file named FILE.  Returns the data as
%  a table.
%
%  DANEMIASTA = IMPORTFILE(FILE, SHEET) reads from the specified
%  worksheet.
%
%  DANEMIASTA = IMPORTFILE(FILE, SHEET, STARTROW, ENDROW) reads from the
%  specified worksheet for the specified row interval(s). Specify
%  STARTROW and ENDROW as a pair of scalars or vectors of matching size
%  for dis-contiguous row intervals.
%
%  Example:
%  DaneMiasta = importfile("C:\Users\Rafal\Documents\PW\6 semestr\PSZT\Projekt-1\TestyMatLab\DaneMiasta.xlsx", "Arkusz2", 2, 2319);
%
%  See also READTABLE.
%
% Auto-generated by MATLAB on 29-Mar-2020 18:04:08

%% Input handling

% If no sheet is specified, read first sheet
if nargin == 1 || isempty(sheetName)
    sheetName = 1;
end

% If row start and end points are not specified, define defaults
if nargin <= 3
    startRow = 2;
    endRow = 2319;
end

%% Setup the Import Options
opts = spreadsheetImportOptions("NumVariables", 3);

% Specify sheet and range
opts.Sheet = sheetName;
opts.DataRange = "A" + startRow(1) + ":C" + endRow(1);

% Specify column names and types
opts.VariableNames = ["Miasta", "Latitude", "Longitude"];
opts.VariableTypes = ["string", "double", "double"];
opts = setvaropts(opts, [1], "WhitespaceRule", "preserve");
opts = setvaropts(opts, [1], "EmptyFieldRule", "auto");

% Import the data
DaneMiasta = readtable(workbookFile, opts, "UseExcel", false);

for idx = 2:length(startRow)
    opts.DataRange = "A" + startRow(idx) + ":C" + endRow(idx);
    tb = readtable(workbookFile, opts, "UseExcel", false);
    DaneMiasta = [DaneMiasta; tb]; %#ok<AGROW>
end

end