program BusRouteReview;

uses
  Vcl.Forms,
  MainForm in '..\Main Form\MainForm.pas' {frmMain},
  LineParser in '..\Units\Classes\Line Parser\LineParser.pas',
  BusServiceReader in '..\Units\Classes\Bus Server Reader\BusServiceReader.pas',
  LineParserInterface in '..\Units\Interfaces\Line Parser\LineParserInterface.pas',
  BusServiceReaderInterface in '..\Units\Interfaces\Bus Service Reader\BusServiceReaderInterface.pas',
  BusServiceDataTypesAndConstants in '..\Units\Types And Constants\BusServiceDataTypesAndConstants.pas',
  CharacterStack in '..\Units\Classes\Character Stack\CharacterStack.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
