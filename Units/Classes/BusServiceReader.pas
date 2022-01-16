unit BusServiceReader;

  {==============================================}
  { Class to read service information from file  }
  { using injected helper interface to parse the }
  { line data and injected error logger to show  }
  { errors.                                      }
  { Author: Tony Foster                          }
  { Date: January 2022                           }
  {==============================================}

interface

uses
  RefCountedClass, SysUtils,
  BusServiceReaderInterface, LineParserInterface, ErrorLoggingInterface, BusServiceModelInterface;

type
  TBusServiceReader = class(TRefCounted, IBusServiceReader)
  private
    fLineReader: IServiceLineParser;
  protected
    procedure DoInitialisation(Injected: IInterface); override;
    function ReadData(FileName: string; ErrorLog: IErrorLog; ModelBuilder: IBusServiceModel): boolean;
  public
  end;

implementation

uses
  BusServiceDataTypesAndConstants;

{ TBusServiceReader }

procedure TBusServiceReader.DoInitialisation(Injected: IInterface);
begin
  inherited;
  Injected.QueryInterface(IServiceLineParser, fLineReader);
end;

function TBusServiceReader.ReadData(FileName: string; ErrorLog: IErrorLog; ModelBuilder: IBusServiceModel): boolean;
var
  TheFile: TextFile;
  TheLine: string;
  ServiceDef: TServiceDefinition;
  LogLine: string;
begin
  Result := true;

  if Assigned(ErrorLog) then
    ErrorLog.ClearLog;

  if FileExists(FileName) then
    begin
      if Assigned(fLineReader) then
        begin
          AssignFile(TheFile, FileName);

          Reset(TheFile);
          while not EOF(TheFile) do
            begin {read each line and parse through line reader interface}
              ReadLn(TheFile, TheLine);
              if fLineReader.ParseLine(TheLine, ServiceDef) = prNoError then
                begin
                  if Assigned(ModelBuilder) then
                    ModelBuilder.ReceiveNewServiceRecord(ServiceDef);
                end
              else
                begin
                  Result := false;
                  LogLine := Format(C_ERROR_FORMAT, [TheLine]);
                  if Assigned(ErrorLog) then
                    ErrorLog.AddErrorLine(LogLine);
                end;
            end;  {read each line and parse through line reader interface}
        end
      else
        begin
          Result := false;
          if Assigned(ErrorLog) then
            ErrorLog.AddErrorLine(C_ERROR_NO_LINEREADER);
        end;
    end
  else
    begin
      Result := false;
       if Assigned(ErrorLog) then
         ErrorLog.AddErrorLine(Format(C_FILE_NOT_FOUND, [FileName]));
    end;
end;

end.
