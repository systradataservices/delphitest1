unit LineParserInterface;

  {==================================================}
  { Interface to parse a line of service information }
  { Author: Tony Foster                              }
  { Date: January 2022                               }
  {==================================================}

interface

uses
  BusServiceDataTypesAndConstants;

type
  IServiceLineParser = interface
  ['{5323DB60-FFF8-4EBC-8507-7EC2FFDE013E}']
    function ParseLine(Line: string; var Service: TServiceDefinition): TLineParseResult;
  end;

implementation

end.
