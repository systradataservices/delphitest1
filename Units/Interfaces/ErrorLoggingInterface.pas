unit ErrorLoggingInterface;

interface

type
  IErrorLog = interface
  ['{A411C98A-78F6-46BE-A761-97BCA8D3B4D2}']
    procedure ClearLog;
    procedure AddErrorLine(ErrorLine: string);
  end;

implementation

end.
