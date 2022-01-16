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
  DataControllerInterface;

type
  TfrmMain = class(TForm, IView, IErrorLog)
    pnlTop: TPanel;
    btnLoadData: TButton;
    MainPages: TPageControl;
    ServicesPage: TTabSheet;
    ErrorsPage: TTabSheet;
    ErrorLog: TMemo;
    StatusBar1: TStatusBar;
    BusDataTree: TTreeView;
    Splitter1: TSplitter;
    pnlInfoArea: TPanel;
    lblAddInfo: TLabel;
    procedure btnLoadDataClick(Sender: TObject);
  private
    { Private declarations }
    fDataController: IDataController;
  protected
    {IErrorLog}
    procedure ClearLog;
    procedure AddErrorLine(ErrorLine: string);

    {IDisplayInterface}
    procedure ClearDisplay;
    function AddTopLevelNode(ItemName: string): TTreeNode;
    function AddChildNode(Parent: TTreeNode; ItemName: string): TTreeNode;
    procedure SortNodes;
    procedure ExpandNodes; {s.l.o.w.}
  public
    { Public declarations }
    constructor Create(Aowner: TComponent); override;
    destructor Destroy; override;
  end;

var
  frmMain: TfrmMain;

implementation

uses
  BusServiceDataTypesAndConstants, InstanceFactory;

{$R *.dfm}

function TfrmMain.AddChildNode(Parent: TTreeNode; ItemName: string): TTreeNode;
begin
  Result := nil;
  if Assigned(Parent) then
    begin
      Result := BusDataTree.Items.AddChild(Parent, ItemName);
    end;
end;

procedure TfrmMain.AddErrorLine(ErrorLine: string);
begin
  ErrorLog.Lines.Add(ErrorLine);
end;

function TfrmMain.AddTopLevelNode(ItemName: string): TTreeNode;
begin
  Result := BusDataTree.Items.AddChild(nil, ItemName);
end;

procedure TfrmMain.btnLoadDataClick(Sender: TObject);
var
  AllOK: boolean;
  OD: TOpenDialog;
  Ticks: Cardinal;
begin
  if Assigned(fDataController) then
    begin
      OD := TOpenDialog.Create(self);
      try
        btnLoadData.Enabled := false;
        OD.InitialDir := ExtractFilePath(Application.ExeName);
        OD.Filter := 'CSV Files (*.csv)|*.csv';
        if OD.Execute then
          begin
            Ticks := GetTickCount;
            AllOK := fDataController.LoadDataFromCSVFile(OD.FileName, self as IErrorLog) and
                     fDataController.DisplayDataByDaysOfWeekGrouping(self as IErrorLog);

            if AllOK then
              MainPages.ActivePage := ServicesPage
            else
              MainPages.ActivePage := ErrorsPage;
            Ticks := GetTickCount - Ticks;
            StatusBar1.Panels[0].Text := Format(C_READ_AND_DISPLAY_TIME, [Ticks]);
          end;
      finally
        OD.Free;
        btnLoadData.Enabled := true;
      end;
    end;
end;

procedure TfrmMain.ClearDisplay;
begin
  BusDataTree.Items.Clear;
end;

procedure TfrmMain.ClearLog;
begin
  ErrorLog.Lines.Clear;
end;

constructor TfrmMain.Create(Aowner: TComponent);
begin
  inherited;
  InstanceFactory.TInstanceFactory.SingleInstance.CreateInstance(IDataController, fDataController);
  if Assigned(fDataController) then
    begin
      fDataController.RegisterView(self as IView);
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

procedure TfrmMain.ExpandNodes;
begin
  BusDataTree.FullExpand;
end;

procedure TfrmMain.SortNodes;
begin
  BusDataTree.SortType := stText;
  BusDataTree.AlphaSort(true);
end;

end.
