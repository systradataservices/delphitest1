unit BusServiceModel;

  {==============================================}
  { Data Model Class for data representing       }
  { operators, services and schedules in a       }
  { structured model using component ownership.  }
  { Author: Tony Foster                          }
  { Date: January 2022                           }
  {==============================================}

interface

uses
  BusServiceModelInterface, RefCountedClass, BusServiceDataTypesAndConstants, ModelClasses,
  System.Generics.Collections, Classes, ModelDataItemInterface, DataControllerInterface,
  ErrorLoggingInterface;

type
  TBusServiceModel = class(TRefCounted, IBusServiceModel)
  private
    fRootItem : TDayAwareHashedComponent;
  protected
    function GetRootItem: IModelDataItem;
    procedure DoInitialisation(Injected: IInterface); override;
    function LoadDataFromCSVFile(FileName: string; Logger: IErrorLog): boolean;
    procedure ReceiveNewServiceRecord(ServiceRecord: TServiceDefinition);
  public
    destructor Destroy; override;
  end;

implementation

uses
  SysUtils, InstanceFactory, BusServiceReaderInterface, LineParserInterface;

{ TServiceModelBuilder }

destructor TBusServiceModel.Destroy;
begin
  FreeAndNil(fRootItem);
  inherited;
end;

procedure TBusServiceModel.DoInitialisation(Injected: IInterface);
begin
  inherited;
  fRootItem  := TDayAwareHashedComponent.Create(nil);
end;

function TBusServiceModel.GetRootItem: IModelDataItem;
begin
  Result := fRootItem;
end;

function TBusServiceModel.LoadDataFromCSVFile(FileName: string;
  Logger: IErrorLog): boolean;
var
  Reader: IBusServiceReader;
  LineHelper: IServiceLineParser;
  ClassesOK: boolean;
begin
  {no need to manage the  instances of the created classes. Once they
  go out of scope, reference counting will ensure that they are freed}
  Result := false;
  ClassesOK := false;
  fRootItem.ServiceScheduleGroups := [];
  if InstanceFactory.TInstanceFactory.SingleInstance.CreateInstance(IServiceLineParser, LineHelper) then
    if InstanceFactory.TInstanceFactory.SingleInstance.CreateInstance(IBusServiceReader, Reader, LineHelper as IServiceLineParser) then
      begin
        ClassesOK := true;
        Result := Reader.ReadData(FileName, Logger, self as IBusServiceModel);
      end;

   if not ClassesOK then
     begin
       if Assigned(Logger) then
         begin
           {let the caller know that we had an issue}
           Logger.ClearLog;
           Logger.AddErrorLine(C_ERROR_NO_CLASS);
         end;
     end;
end;

procedure TBusServiceModel.ReceiveNewServiceRecord(
  ServiceRecord: TServiceDefinition);
var
  tempOperator: TBusServiceOperator;
  tempService: TBusService;
  tempSchedule: TServiceSchedule;
begin
  tempOperator := fRootItem.FindAddChildByName(ServiceRecord.OperatorName, TBusServiceOperator) as TBusServiceOperator;
  if Assigned(tempOperator) then
    begin
      tempService := tempOperator.FindAddChildByName(ServiceRecord.ServiceName, TBusService) as TBusService;
      if Assigned(tempService) then
        begin
          tempSchedule := tempService.FindAddChildByName(C_SCHEDULE, TServiceSchedule) as TServiceSchedule;
          if Assigned(tempSchedule) then
            begin
              tempSchedule.DaysOfWeek            := ServiceRecord.ActiveDays;
              tempService.ServiceScheduleGroups  := tempService.ServiceScheduleGroups  + tempSchedule.ServiceScheduleGroups;
              tempOperator.ServiceScheduleGroups := tempOperator.ServiceScheduleGroups + tempSchedule.ServiceScheduleGroups;
              fRootItem.ServiceScheduleGroups    := fRootItem.ServiceScheduleGroups    + tempSchedule.ServiceScheduleGroups;
            end;
        end;
    end;
end;

end.
