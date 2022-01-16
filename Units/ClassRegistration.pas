unit ClassRegistration;

  {================================================}
  { registration of interfaces and implementing    }
  { classes for use by the simple instance factory }
  { Author: Tony Foster                            }
  { Date: January 2022                             }
  {================================================}

interface

implementation

uses
  InstanceFactory, BusServiceReader, BusServiceReaderInterface, LineParser, LineParserInterface,
  DataController, DataControllerInterface, BusServiceModel, BusServiceModelInterface;

procedure RegisterClasses;
var
  Factory: TInstanceFactory;
begin
  Factory := InstanceFactory.TInstanceFactory.SingleInstance;
  if Assigned(Factory) then
    begin
      InstanceFactory.TInstanceFactory.SingleInstance.RegisterInterfaceClass(IBusServiceReader,    TBusServiceReader);
      InstanceFactory.TInstanceFactory.SingleInstance.RegisterInterfaceClass(IServiceLineParser,   TServiceLineParser);
      InstanceFactory.TInstanceFactory.SingleInstance.RegisterInterfaceClass(IBusServiceModel,     TBusServiceModel);
      InstanceFactory.TInstanceFactory.SingleInstance.RegisterInterfaceClass(IDataController,      TDataController);
    end;
end;

initialization
  RegisterClasses;

end.
