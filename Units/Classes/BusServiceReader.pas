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
  protected
    function ReadData(FileName: string; LineReader: IServiceLineParser; ErrorLog: IErrorLog; ModelBuilder: IBusServiceModel): boolean;
  public
  end;

implementation

uses
  BusServiceDataTypesAndConstants;

{ TBusServiceReader }

function TBusServiceReader.ReadData(FileName: string; LineReader: IServiceLineParser; ErrorLog: IErrorLog; ModelBuilder: IBusServiceModel): boolean;
var
  TheFile: TextFile;
  TheLine: string;
  ServiceDef: TServiceDefinition;
  LogLine: string;
begin
  Result := true;

  if Assigned(ErrorLog) then
    ErrorLog.ClearLog;

  if FileExists(FileName) and Assigned(LineReader) then
    begin
      AssignFile(TheFile, FileName);

      Reset(TheFile);
      while not EOF(TheFile) do
        begin {read each line and parse through line reader interface}
          ReadLn(TheFile, TheLine);
          if LineReader.ParseLine(TheLine, ServiceDef) = prNoError then
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
         begin
           ErrorLog.AddErrorLine(Format(C_FILE_NOT_FOUND, [FileName]));
         end;
    end;
end;

end.
