unit MainForm;

  {==================================================}
  { This form class is our View class for this       }
  { simple application. It implements two interfaces }
  { demonstrating suitable segregation of function   }
  { and allowing display of service data as well as  }
  { error information for when things go wrong.      }
  { Author: Tony Foster                              }
  { Date: January 2022                               }
  {==================================================}

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ViewInterface, Vcl.StdCtrls,
  Vcl.ExtCtrls, Vcl.ComCtrls, ErrorLoggingInterface,
  DataControllerInterface, BusServiceDataTypesAndConstants;

type
  TfrmMain = class(TForm, IView, IErrorLog)
    pnlTop: TPanel;
    btnLoadData: TButton;
    StatusBar1: TStatusBar;
    pnlMain: TPanel;
    Splitter1: TSplitter;
    pnlErrorLog: TPanel;
    ErrorLog: TMemo;
    lblErrorLog: TLabel;
    pnlTree: TPanel;
    BusDataTree: TTreeView;
    lblBusServices: TLabel;
    procedure btnLoadDataClick(Sender: TObject);
    procedure BusDataTreeExpanding(Sender: TObject; Node: TTreeNode;
      var AllowExpansion: Boolean);
  private
    { Private declarations }
    fDataController: IDataController;
  protected
    {IErrorLog}
    procedure ClearLog;
    procedure AddErrorLine(ErrorLine: string);

    {IDisplayInterface}
    function AddTopLevelNode(ItemName: string): TTreeNode;
    function AddChildNode(Parent: TTreeNode; ItemName: string): TTreeNode;
    procedure AddDummyNode(ParentNode: TTreeNode);
  public
    { Public declarations }
    constructor Create(Aowner: TComponent); override;
    destructor Destroy; override;
  end;

var
  frmMain: TfrmMain;

implementation

uses
  InstanceFactory;

{$R *.dfm}

function TfrmMain.AddChildNode(Parent: TTreeNode; ItemName: string): TTreeNode;
begin
  Result := nil;
  if Assigned(Parent) then
    begin
      Result := BusDataTree.Items.AddChild(Parent, ItemName);
    end;
end;

procedure TfrmMain.AddDummyNode(ParentNode: TTreeNode);
begin
  if Assigned(ParentNode) then
    BusDataTree.Items.AddChild(ParentNode, '');
end;

procedure TfrmMain.AddErrorLine(ErrorLine: string);
begin
  ErrorLog.Lines.Add(Format(C_STRING_STRING, [FormatDateTime(C_PRECISE_TIME, Now), ErrorLine]));
end;

function TfrmMain.AddTopLevelNode(ItemName: string): TTreeNode;
begin
  Result := BusDataTree.Items.AddChild(nil, ItemName);
end;

procedure TfrmMain.btnLoadDataClick(Sender: TObject);
var
  OD: TOpenDialog;
  Ticks: Cardinal;
begin
  BusDataTree.Items.BeginUpdate;
  try
    BusDataTree.Items.Clear;
  finally
    BusDataTree.Items.EndUpdate;
  end;

  if Assigned(fDataController) then
    begin
      OD := TOpenDialog.Create(self);
      try
        btnLoadData.Enabled := false;
        OD.InitialDir := ExtractFilePath(Application.ExeName);
        OD.Filter     := C_CSV_FILTER;
        if OD.Execute then
          begin
            Ticks := GetTickCount;
            if fDataController.LoadDataFromCSVFile(OD.FileName, self as IErrorLog) then
              fDataController.AddScheduleGroupNodes(self as IErrorLog);

            Ticks := GetTickCount - Ticks;
            StatusBar1.Panels[0].Text := Format(C_READ_TIME, [Ticks]);
          end;
      finally
        OD.Free;
        btnLoadData.Enabled := true;
      end;
    end;
end;

procedure TfrmMain.BusDataTreeExpanding(Sender: TObject; Node: TTreeNode;
  var AllowExpansion: Boolean);
begin
  {dynamically add child nodes when a node is expanded rather than
  loading up the view (and wasting time) by loading everything at
  the start.}
  if not Assigned(fDataController) then
    begin
      AllowExpansion := false;
      Exit;
    end;

  BusDataTree.Items.BeginUpdate;
  try
    if Assigned(Node) then
      begin
        Node.DeleteChildren;
        fDataController.AddChildNodes(Node, self as IErrorLog);
        Node.AlphaSort;
      end;
  finally
    BusDataTree.Items.EndUpdate;
  end;
end;

procedure TfrmMain.ClearLog;
begin
  ErrorLog.Lines.Clear;
end;

constructor TfrmMain.Create(Aowner: TComponent);
begin
  inherited;
  InstanceFactory.TInstanceFactory.SingleInstance.CreateInstance(IDataController, fDataController, self as IView);
  if Assigned(fDataController) then
    begin
      btnLoadData.Enabled := true;
    end
  else
    begin
      btnLoadData.Enabled := false;
      btnLoadData.Caption := C_NO_DATA_COMPONENTS;
    end;
end;

destructor TfrmMain.Destroy;
begin
  fDataController := nil;
  inherited;
end;

end.
