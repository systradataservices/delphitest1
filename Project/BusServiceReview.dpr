program BusServiceReview;

uses
  Vcl.Forms,
  MainForm in '..\Main Form\MainForm.pas' {frmMain},
  LineParser in '..\Units\Classes\LineParser.pas',
  LineParserInterface in '..\Units\Interfaces\LineParserInterface.pas',
  BusServiceReaderInterface in '..\Units\Interfaces\BusServiceReaderInterface.pas',
  BusServiceDataTypesAndConstants in '..\Units\Types And Constants\BusServiceDataTypesAndConstants.pas',
  CharacterStack in '..\Units\Classes\CharacterStack.pas',
  DataController in '..\Units\Classes\DataController.pas',
  ViewInterface in '..\Units\Interfaces\ViewInterface.pas',
  ErrorLoggingInterface in '..\Units\Interfaces\ErrorLoggingInterface.pas',
  RefCountedClass in '..\Units\Classes\RefCountedClass.pas',
  BusServiceReader in '..\Units\Classes\BusServiceReader.pas',
  InstanceFactory in '..\Units\Classes\InstanceFactory.pas',
  ClassRegistration in '..\Units\ClassRegistration.pas',
  DataControllerInterface in '..\Units\Interfaces\DataControllerInterface.pas',
  BusServiceModelInterface in '..\Units\Interfaces\BusServiceModelInterface.pas',
  BusServiceModel in '..\Units\Classes\BusServiceModel.pas',
  HashedComponent in '..\Units\Classes\HashedComponent.pas',
  ModelClasses in '..\Units\Classes\ModelClasses.pas',
  ModelDataItemInterface in '..\Units\Interfaces\ModelDataItemInterface.pas';

{$R *.res}

begin
  {$IFDEF DEBUG}
  ReportMemoryLeaksOnShutdown := true;
  {$ENDIF}
  {implementation classes for the various data interfaces are registered during
  initialization. It does not matter what order they are registered in so the
  order of units in the uses clause is not important here.}
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
