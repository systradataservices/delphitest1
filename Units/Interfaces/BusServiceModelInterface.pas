unit BusServiceModelInterface;

  {==============================================}
  { Data Model Interface for data representing   }
  { operators, services and schedules in a       }
  { structured model using component ownership.  }
  { Author: Tony Foster                          }
  { Date: January 2022                           }
  {==============================================}

interface

uses
  BusServiceDataTypesAndConstants, ModelDataItemInterface, DataControllerInterface, ErrorLoggingInterface;

type
  IBusServiceModel = interface
  ['{DDD41E13-8A77-4259-A689-66201A1BEA38}']
    procedure ReceiveNewServiceRecord(ServiceRecord: TServiceDefinition);
    function GetRootItem: IModelDataItem;
    function LoadDataFromCSVFile(FileName: string; Logger: IErrorLog): boolean;
    property RootItem: IModelDataItem read GetRootItem;
  end;

implementation

end.
