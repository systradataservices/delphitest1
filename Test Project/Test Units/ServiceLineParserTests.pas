unit ServiceLineParserTests;

interface

uses
  DUnitX.TestFramework, LineParserInterface, BusServiceDataTypesAndConstants;

type
  [TestFixture]
  TServiceLineParserTester = class
  private
    Parser: IServiceLineParser;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    [Test]
    [TestCase('TestA','"A2B Bus and Coach Limited";"127";"1101110"')]
    procedure Test1(const AValue1: string);
    [Test]
    [TestCase('TestB','A2B Bus and Coach Limited";"127";"1101110"')]
    procedure Test2(const AValue1: string);
  end;

implementation

uses
  LineParser;

procedure TServiceLineParserTester.Setup;
begin
  Parser := TServiceLineParser.Create as IServiceLineParser;
end;

procedure TServiceLineParserTester.TearDown;
begin
  Parser := nil;
end;

procedure TServiceLineParserTester.Test1(const AValue1: string);
var
  TheRes: TLineParseResult;
  Service: TServiceDefinition;
begin
  Service.OperatorName := '';
  Service.ServiceName  := '';
  Service.ActiveDays   := [];

  TheRes := Parser.ParseLine(AValue1, Service);
  Assert.AreEqual(TheRes, prNoError);
end;

procedure TServiceLineParserTester.Test2(const AValue1: string);
var
  TheRes: TLineParseResult;
  Service: TServiceDefinition;
begin
  Service.OperatorName := '';
  Service.ServiceName  := '';
  Service.ActiveDays   := [];

  TheRes := Parser.ParseLine(AValue1, Service);
  Assert.AreEqual(TheRes, prUnreadableElement);
end;

initialization
  TDUnitX.RegisterTestFixture(TServiceLineParserTester);

end.
