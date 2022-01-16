unit BusServiceReaderInterface;

  {=================================================}
  { Interface to read service information from file }
  { using injected helper interface to parse the    }
  { line data and injected error logger to show     }
  { errors.                                         }
  { Author: Tony Foster                             }
  { Date: January 2022                              }
  {=================================================}

interface

uses
  ErrorLoggingInterface, LineParserInterface, BusServiceModelInterface;

type
  IBusServiceReader = interface
  ['{382E16C5-F39F-479E-ADC3-C23B04847E26}']
    function ReadData(FileName: string; LineReader: IServiceLineParser; ErrorLog: IErrorLog; ModelBuilder: IBusServiceModel): boolean;
  end;

implementation

end.
