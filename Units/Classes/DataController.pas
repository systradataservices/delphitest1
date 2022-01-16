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
  Classes,
  RefCountedClass,
  ViewInterface, ErrorLoggingInterface, DataControllerInterface, BusServiceModelInterface;

type
  TDataController = class(TRefCounted, IDataController)
  private
    fModel: IBusServiceModel;
    fView : IView;
  protected
    procedure DoInitialisation; override;
    procedure RegisterView(View: IView);
    function LoadDataFromCSVFile(FileName: string; Logger: IErrorLog): boolean;
    function DisplayDataByDaysOfWeekGrouping(Logger: IErrorLog): boolean;
  public
    destructor Destroy; override;
  end;

implementation

uses
  BusServiceReader, MainForm, Forms, InstanceFactory, BusServiceDataTypesAndConstants,
  ComCtrls, ModelDataItemInterface;

{ TDataController }

destructor TDataController.Destroy;
begin
  fModel := nil;
  inherited;
end;

function TDataController.DisplayDataByDaysOfWeekGrouping(Logger: IErrorLog): boolean;
var
  GroupCounter : TServiceScheduleGroup;
  Node         : TTreeNode;
  OpNode       : TTreeNode;
  ServNode     : TTreeNode;
  Counter1     : integer;
  Counter2     : integer;
  RootItem     : IModelDataItem;
  tempOperator : IModelDataItem;
  tempService  : IModelDataItem;
  tempSched    : IModelDataItem;
  tempString   : string;
  ErrorString  : string;
begin
  result := false;
  if Assigned(fView) then
    begin {view assigned}
      Result := true;
      fView.ClearDisplay;
      if Assigned(fModel) then
        begin {we have a model}
          RootItem := fModel.RootItem;
          if Assigned(RootItem) then
            begin {we have a data root to read from}
              for GroupCounter := Low(TServiceScheduleGroup) to High(TServiceScheduleGroup) do
                begin {each days group}
                  Node := fView.AddTopLevelNode(CA_SCHEDULE_GROUPNAMES[GroupCounter]);
                  if Assigned(Node) then
                    begin {node came back from the view OK}
                      Node.Data := nil;
                      for counter1 := 0 to RootItem.ModelDataItemCount - 1 do
                        begin {each top level item in the structured model}
                          tempOperator := RootItem.ModelDataItem[Counter1];
                          if Assigned(tempOperator) then
                            begin {got operator item OK}
                              if GroupCounter in tempOperator.ServiceScheduleGroups then
                                begin {this operator runs on this day group}
                                  OpNode := fView.AddChildNode(Node, tempOperator.FriendlyName);
                                  if Assigned(OpNode) then
                                    begin {node came back from the view OK}
                                      OpNode.Data := tempOperator;
                                      for counter2 := 0 to tempOperator.ModelDataItemCount - 1 do
                                        begin {each service owned by the operator}
                                          tempService := tempOperator.ModelDataItem[Counter2];
                                          if Assigned(tempService) then
                                            begin {got the service oK}
                                               if GroupCounter in tempService.ServiceScheduleGroups then
                                                 begin  {this service runs on this day group}
                                                   tempString := '';
                                                   if tempService.ModelDataItemCount > 0 then
                                                     begin {service owns at least one item (schedule)}
                                                       tempSched := tempService.ModelDataItem[0];
                                                       if Assigned(tempSched) then
                                                         tempString := tempSched.MakeActveDaysString;
                                                     end;  {service owns at least one item (schedule)}
                                                   if tempString <> '' then
                                                     tempString := tempService.FriendlyName + ' ' + tempString
                                                   else
                                                     tempString := tempService.FriendlyName;

                                                   ServNode := fView.AddChildNode(OpNode, tempString);
                                                   ServNode.Data := tempService;
                                                 end;   {this service runs on this day group}
                                            end;  {got the service oK}
                                        end;  {each service owned by the operator}
                                    end   {node came back from the view OK}
                                  else
                                    begin {view failed to provide display element}
                                      ErrorString := C_ERROR_NO_NODE;
                                    end;  {view failed to provide display element}
                                end;  {this operator runs on this day group}
                            end;  {got operator item OK}
                        end;  {each top level item in the structured model}
                    end   {node came back from the view OK}
                  else
                    begin {view failed to provide display element}
                      ErrorString := C_ERROR_NO_NODE;
                    end;  {view failed to provide display element}
                end;  {each days group}
            end   {we have a data root to read from}
          else
            begin {no data root}
              ErrorString := C_ERROR_NO_ROOT;
            end;  {no data root}
        end  {we have a model}
      else
        begin {model not assigned}
          ErrorString := C_ERROR_NO_MODEL;
        end;  {model not assigned}
      {sorting of the tree takes as long as the
      load and populate for the supplied data.}
      fView.SortNodes;
    end  {view assigned}
  else
    begin {view not assigned}
      ErrorString := C_ERROR_NO_VIEW;
    end;  {view not assigned}

  if not Result then
    begin
      if ErrorString = '' then
        ErrorString := C_GENERAL_DISPLAY_ERROR;
      if Assigned(Logger) then
        Logger.AddErrorLine(ErrorString);
    end;
end;

procedure TDataController.DoInitialisation;
begin
  inherited;
  InstanceFactory.TInstanceFactory.SingleInstance.CreateInstance(IBusServiceModel, fModel);
end;

function TDataController.LoadDataFromCSVFile(FileName: string; Logger: IErrorLog): boolean;
begin
  Result := fModel.LoadDataFromCSVFile(FileName, Logger);
end;

procedure TDataController.RegisterView(View: IView);
begin
  fView := View;
end;

end.
