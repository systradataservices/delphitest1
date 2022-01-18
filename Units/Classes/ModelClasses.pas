unit ModelClasses;

  {====================================================}
  { Hierarchy of classes used to create the structured }
  { data model. Some redundancy of function but this   }
  { allows much simpler interface definition and gives }
  { schedule awareness to all levels.                  }
  { Author: Tony Foster                                }
  { Date: January 2022                                 }
  {====================================================}

interface

uses
  Classes, HashedComponent, BusServiceDataTypesAndConstants, ModelDataItemInterface,
  System.Generics.Collections, System.Generics.Defaults;

type
  TDayAwareHashedComponent = class(THashedComponent, IModelDataItem)
  private
    FServiceScheduleGroups: TServiceScheduleGroups;
  protected
    function CanDisplaySubItems: boolean; virtual;
    function DisplayString: string;
    function MakeActveDaysString: string; virtual;
    procedure SetServiceScheduleGroups(const Value: TServiceScheduleGroups);
    function GetServiceScheduleGroups: TServiceScheduleGroups;
    function GetModelDataItem(index: integer): IModelDataItem;
    function GetModelDataItemByName(ItemName: string): IModelDataItem;
    function GetModelDataItemCount: integer;
  public
    constructor Create(Aowner: TComponent); override;
    property ServiceScheduleGroups: TServiceScheduleGroups read GetServiceScheduleGroups write SetServiceScheduleGroups;
  end;

  TBusServiceOperator = class(TDayAwareHashedComponent);

  TBusService = class(TDayAwareHashedComponent)
  protected
    function MakeActveDaysString: string; override;
    function CanDisplaySubItems: boolean; override;
  end;

  TServiceSchedule = class(TDayAwareHashedComponent)
  private
    FDaysOfWeek: TDaysOfWeek;
    procedure SetDaysOfWeek(const Value: TDaysOfWeek);
  protected
    function MakeActveDaysString: string; override;
  public
    constructor Create(Aowner: TComponent); override;
    property DaysOfWeek: TDaysOfWeek read FDaysOfWeek write SetDaysOfWeek;
  end;

implementation

uses
  SysUtils;

{ TServiceSchedule }

constructor TServiceSchedule.Create(Aowner: TComponent);
begin
  inherited;
  FDaysOfWeek := [];
end;

function TServiceSchedule.MakeActveDaysString: string;
var
  DayCounter: TDayOfWeek;
begin
  Result := '(';
  for DayCounter := Low(TDayOfWeek) to High(TDayOfWeek) do
    if DayCounter in FDaysOfWeek then
      Result := Result + CA_DAYNAME_ABBREV[DayCounter]
    else
      Result := Result + C_NOT_RUNNING;
  Result := Result + ')';
end;

procedure TServiceSchedule.SetDaysOfWeek(const Value: TDaysOfWeek);
begin
  FDaysOfWeek := Value;
  if dwSaturday in fDaysOfWeek then
    FServiceScheduleGroups := FServiceScheduleGroups + [sgSaturday]
  else
    FServiceScheduleGroups := FServiceScheduleGroups - [sgSaturday];

  if dwSunday in fDaysOfWeek then
    FServiceScheduleGroups := FServiceScheduleGroups + [sgSunday]
  else
    FServiceScheduleGroups := FServiceScheduleGroups - [sgSunday];

  if FDaysOfWeek * C_WEEKDAYS <> [] then
    FServiceScheduleGroups := FServiceScheduleGroups + [sgWeekdays]
  else
    FServiceScheduleGroups := FServiceScheduleGroups + [sgWeekdays];
end;

{ TDayAwareHashedComponent }

function TDayAwareHashedComponent.CanDisplaySubItems: boolean;
begin
  Result := true;
end;

constructor TDayAwareHashedComponent.Create(Aowner: TComponent);
begin
  inherited;
  FServiceScheduleGroups := [];
end;

procedure TDayAwareHashedComponent.SetServiceScheduleGroups(
  const Value: TServiceScheduleGroups);
begin
  FServiceScheduleGroups := Value;
end;

function TDayAwareHashedComponent.DisplayString: string;
begin
  Result := FriendlyName + MakeActveDaysString;
end;

function TDayAwareHashedComponent.GetModelDataItem(index: integer): IModelDataItem;
var
  Counter1: integer;
  ThisIndex: integer;
  temp: IModelDataItem;
begin
  result := nil;
  ThisIndex := -1;
  for counter1 := 0 to ComponentCount - 1 do
    if Components[Counter1].GetInterface(IModelDataItem, temp) then
      begin
        inc(ThisIndex);
        if ThisIndex = Index then
          begin
            Result := temp;
            break;
          end;
      end;
end;

function TDayAwareHashedComponent.GetModelDataItemByName(
  ItemName: string): IModelDataItem;
begin
  Result := FindChildByName(ItemName) as IModelDataItem;
end;

function TDayAwareHashedComponent.GetModelDataItemCount: integer;
var
  Counter1: integer;
  temp: IModelDataItem;
begin
  result := 0;
  for counter1 := 0 to ComponentCount - 1 do
    if Components[Counter1].GetInterface(IModelDataItem, temp) then
      inc(Result);
end;

function TDayAwareHashedComponent.GetServiceScheduleGroups: TServiceScheduleGroups;
begin
  Result := FServiceScheduleGroups;
end;

function TDayAwareHashedComponent.MakeActveDaysString: string;
begin
  Result := '';
end;

{ TBusService }

function TBusService.CanDisplaySubItems: boolean;
begin
  Result := false;
end;

function TBusService.MakeActveDaysString: string;
var
  Sched: IModelDataItem;
begin
  Result := '';
  Sched := GetModelDataItem(0);
  if Assigned(Sched) then
    Result := Sched.MakeActveDaysString;
end;

end.
