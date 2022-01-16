unit DataControllerInterface;

  {==================================================}
  { Controller Interface to manage the various Model }
  { data and coordinate I/O between Model and        }
  { view.                                            }
  { Author: Tony Foster                              }
  { Date: January 2022                               }
  {==================================================}

interface

uses
  ErrorLoggingInterface, ViewInterface;

type
  IDataController = interface
  ['{61B66603-03C5-43B5-AD54-6644E1FF9781}']
    function LoadDataFromCSVFile(FileName: string; Logger: IErrorLog): boolean;
    function DisplayDataByDaysOfWeekGrouping(Logger: IErrorLog): boolean;
    procedure RegisterView(View: IView);
  end;

implementation

end.
