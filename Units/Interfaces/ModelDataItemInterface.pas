unit ModelDataItemInterface;

  {=================================================}
  { Interface to provide access to individual model }
  { data items. It is a common interface for all    }
  { to simplify access and give schedule awareness  }
  { at all levels.                                  }
  { Author: Tony Foster                             }
  { Date: January 2022                              }
  {=================================================}

interface

uses
  BusServiceDataTypesAndConstants;

type
  IModelDataItem = interface
  ['{92E8CF63-73AB-45A5-A44E-86095C753107}']
    function GetModelDataItem(index: integer): IModelDataItem;
    function GetModelDataItemCount: integer;
    property ModelDataItemCount: integer read GetModelDataItemCount;
    procedure SetServiceScheduleGroups(const Value: TServiceScheduleGroups);
    function GetServiceScheduleGroups: TServiceScheduleGroups;
    function GetFriendlyName: string;
    procedure SetFriendlyname(const Value: string);
    function MakeActveDaysString: string;
    property ModelDataItem[index: integer]: IModelDataItem read GetModelDataItem;
    property ServiceScheduleGroups: TServiceScheduleGroups read GetServiceScheduleGroups write SetServiceScheduleGroups;
    property FriendlyName: string read GetFriendlyName write SetFriendlyname;
  end;

implementation

end.
