unit DataController;

  {==============================================}
  { Controller Class to manage the various Model }
  { data and coordinate I/O between Model and    }
  { view.                                        }
  { Author: Tony Foster                          }
  { Date: January 2022                           }
  {==============================================}

interface

uses
  Classes, ComCtrls, SysUtils,
  RefCountedClass, BusServiceDataTypesAndConstants,
  ViewInterface, ErrorLoggingInterface, DataControllerInterface, BusServiceModelInterface;

type
  TDataController = class(TRefCounted, IDataController)
  private
    fModel: IBusServiceModel;
    fView : IView;
    function ScheduleGroupFromGroupName(GroupName: string): TServiceScheduleGroup;
    function ScheduleGroupFromNode(Node: TTreeNode): TServiceScheduleGroup;
  protected
    procedure DoInitialisation(Injected: IInterface); override;
    function LoadDataFromCSVFile(FileName: string; Logger: IErrorLog): boolean;

    function AddScheduleGroupNodes(Logger: IErrorLog): boolean;
    procedure AddChildNodes(ParentNode: TTreeNode; Logger: IErrorLog);
  public
    destructor Destroy; override;
  end;

implementation

uses
  BusServiceReader, MainForm, Forms, InstanceFactory,
  ModelDataItemInterface;

{ TDataController }

procedure TDataController.AddChildNodes(ParentNode: TTreeNode; Logger: IErrorLog);
var
  RootItem : IModelDataItem;
  NodeItem : IModelDataItem;
  ChildItem: IModelDataItem;
  Counter1 : integer;
  ChildNode: TTreeNode;
  ThisScheduleGroup: TServiceScheduleGroup;
begin
  NodeItem := nil;
  if not assigned(ParentNode) then
    begin
      if Assigned(Logger) then
        Logger.AddErrorLine(C_ERROR_NO_NODE);
      exit;
    end;

  RootItem := fModel.RootItem;
  if not Assigned(RootItem) then
    begin
      if Assigned(Logger) then
        Logger.AddErrorLine(C_ERROR_NO_ROOT);
      Exit;
    end;

  try
    {this line can raise an exception if top node name is unsuitable}
    ThisScheduleGroup := ScheduleGroupFromNode(ParentNode);

    if ParentNode.Level = 0 then
      NodeItem := RootItem
    else
      NodeItem := RootItem.GetModelDataItemByName(ParentNode.Text);

    if Assigned(NodeItem) then
      begin
        for counter1 := 0 to NodeItem.ModelDataItemCount - 1 do
          begin {each child item}
            ChildItem := NodeItem.ModelDataItem[Counter1];
            if Assigned(ChildItem) and (ThisScheduleGroup in ChildItem.ServiceScheduleGroups) then
              begin
                ChildNode := fView.AddChildNode(ParentNode, ChildItem.DisplayString);
                ChildNode.Data := ChildItem;
                if ChildItem.CanDisplaySubItems and (ThisScheduleGroup in ChildItem.ServiceScheduleGroups) then
                  fView.AddDummyNode(ChildNode);
              end;
          end;  {each child item}
      end;
  except on E: Exception do
    if Assigned(Logger) then
      Logger.AddErrorLine(E.Message);
  end;
end;

function TDataController.AddScheduleGroupNodes(Logger: IErrorLog): boolean;
var
  GroupCounter : TServiceScheduleGroup;
  Node         : TTreeNode;
  RootItem     : IModelDataItem;
begin
  Result := true;
  if not Assigned(fView) then
    begin
      Result := false;
      if Assigned(Logger) then
        Logger.AddErrorLine(C_ERROR_NO_VIEW);
      Exit;
    end;

  RootItem := fModel.RootItem;
  if not Assigned(RootItem) then
    begin
      Result := false;
      if Assigned(Logger) then
        Logger.AddErrorLine(C_ERROR_NO_ROOT);
      Exit;
    end;

  for GroupCounter := Low(TServiceScheduleGroup) to High(TServiceScheduleGroup) do
    begin
      Node := fView.AddTopLevelNode(CA_SCHEDULE_GROUPNAMES[GroupCounter]);
      if GroupCounter in RootItem.ServiceScheduleGroups then
        fView.AddDummyNode(Node);
      Result := Result and Assigned(Node);
    end;

  if not Result then
    if Assigned(Logger) then
      Logger.AddErrorLine(C_ERROR_NO_NODE);
end;

destructor TDataController.Destroy;
begin
  fModel := nil;
  inherited;
end;

procedure TDataController.DoInitialisation(Injected: IInterface);
begin
  inherited;
  Injected.QueryInterface(IView, fView);
  InstanceFactory.TInstanceFactory.SingleInstance.CreateInstance(IBusServiceModel, fModel);
end;

function TDataController.LoadDataFromCSVFile(FileName: string; Logger: IErrorLog): boolean;
begin
  Result := fModel.LoadDataFromCSVFile(FileName, Logger);
end;

function TDataController.ScheduleGroupFromGroupName(
  GroupName: string): TServiceScheduleGroup;
begin
  if GroupName = CA_SCHEDULE_GROUPNAMES[sgWeekdays] then
    Result := sgWeekdays
  else if Groupname = CA_SCHEDULE_GROUPNAMES[sgSaturday] then
    Result := sgSaturday
  else if GroupName = CA_SCHEDULE_GROUPNAMES[sgSunday] then
    Result := sgSunday
  else
    raise Exception.Create(C_ERROR_INVALID_GROUP);
end;

function TDataController.ScheduleGroupFromNode(
  Node: TTreeNode): TServiceScheduleGroup;
var
  ParentNode: TTreeNode;
  ErrorMessage: string;
begin
  result       := sgWeekdays;
  ErrorMessage := '';
  ParentNode   := Node;
  if Assigned(ParentNode) then
    begin
      while Assigned(ParentNode.Parent) do
        ParentNode := ParentNode.Parent;

      try
        Result := ScheduleGroupFromGroupName(Trim(ParentNode.Text));
      except on E: Exception do
        ErrorMessage := E.Message;
      end;
    end
  else
    begin
      ErrorMessage := C_ERROR_NODE_DATA;
    end;

  if ErrorMessage <> '' then
    raise exception .Create(ErrorMessage);
end;

end.
