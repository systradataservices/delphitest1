unit LineParser;

  {==============================================}
  { Class to parse a line of service information }
  { Author: Tony Foster                          }
  { Date: January 2022                           }
  {==============================================}

interface

uses
  RefCountedClass, SysUtils,
  LineParserInterface, BusServiceDataTypesAndConstants;

type
  TServiceLineParser = class(TRefCounted, IServiceLineParser)
  private
    fLastState: TCharacterState;
    function CharacterState(Character: Char): TCharacterState;
    function DecodeDayString(DaysString: string; var Error: boolean): TDaysOfWeek;
  protected
    procedure DoInitialisation(Injected: IInterface); override;
    function ParseLine(Line: string; var Service: TServiceDefinition): TLineParseResult;
  public
  end;

implementation

const
  {we would probably want a more extensive set of constants
  here but for this example, these will suffice.}
  C_DOUBLE_QUOTE = '"';
  C_COMMA        = ',';
  C_SEMI_COLON   = ';';
  C_SPACE        = ' ';
  C_ONE          = '1';

type
  TParseElement = (peOperatorName, peServiceName, peDaysOfWeek);
  TControlChar  = (ccDoubleQuote, ccDelimiter, ccSpace, ccCharacter);
  TNextState    = array[TControlChar] of array[TCharacterState] of TCharacterState;

const
  {new states after presenting a char in a given state}
  CA_NEXT_STATES: TNextState = (
                                (csOpeningString, csError,         csError,         csClosingString, csOpeningString, csError),
                                (csError,         csInString,      csDelimiter,     csInString,      csError,         csError),
                                (csNothing,       csNothing,       csClosingString, csInString,      csNothing,       csError),
                                (csError,         csInString,      csError,         csInString,      csError,         csError)
                               );

{ TServiceLineParser }

function TServiceLineParser.CharacterState(Character: Char): TCharacterState;
  {nested func for control char type}
  function ControlCharFromChar: TControlChar;
  begin
    case Character of
      C_DOUBLE_QUOTE        : Result := ccDoubleQuote;
      C_COMMA, C_SEMI_COLON : Result := ccDelimiter;
      C_SPACE               : Result := ccSpace;
      else                    Result := ccCharacter;
    end;
  end;
begin
  {simple dual level state machie to handle next action based on character found}
  Result     := CA_NEXT_STATES[ControlCharFromChar, fLastState];
  fLastState := Result;
end;

function TServiceLineParser.DecodeDayString(DaysString: string; var Error: boolean): TDaysOfWeek;
var
  TheLength: integer;
  Index    : integer;
begin
  Result    := [];
  Error     := false;
  TheLength := Length(DaysString);
  {we will throw an error if the string is longer than 7.
  Maybe there are occasions when all days are not included
  if those at the end are not covered, so allow less than
  seven}
  if (TheLength > 7) or (TheLength <= 0) then
    begin
      Error := true;
      Exit;
    end;

  {only react to a "1", everything else is a false}
  Index  := 0;
  while Index < TheLength do
    begin
      Inc(Index);
      if DaysString[Index] = C_ONE then
        Result := Result + [TDayOfWeek(Index - 1)];
    end;
end;

procedure TServiceLineParser.DoInitialisation(Injected: IInterface);
begin
  inherited;
  fLastState := csNothing;
end;

function TServiceLineParser.ParseLine(Line: string;
  var Service: TServiceDefinition): TLineParseResult;
var
  LocalLine     : string;
  tempString    : string;
  Counter1      : integer;
  tempChar      : Char;
  CurrentElement: TParseElement;
  Error         : boolean;
begin
  fLastState := csNothing;
  Result     := prBlankLine;
  LocalLine  := Trim(Line);
  if Length(LocalLine) > 0 then
    begin {we at least have something}
      tempString     := '';
      CurrentElement := peOperatorName;

      {loop through all incoming chars to build service elements}

      {I do feel that this could also be done with a recursive function
      but doing it this way makes room for a little more flexibility &
      error prevention}

      for counter1 := 1 to Length(LocalLine) do
        begin
          tempChar := LocalLine[Counter1];
          case CharacterState(tempChar) of
            csNothing:
              begin
                {dop nothing in here}
              end;
            csOpeningString:
              begin
                {initialise new element}
                tempString := '';
              end;
            csClosingString:
              begin
                {this is where we need to set the element of data}
                case CurrentElement of
                  peOperatorName:
                    begin
                      Service.OperatorName := Trim(tempString);
                    end;
                  peServiceName:
                    begin
                      Service.ServiceName  := Trim(tempString);
                    end;
                  peDaysOfWeek:
                    begin
                      Service.ActiveDays   := DecodeDayString(tempString, Error);
                      if Error then
                        begin
                          Result := prUnreadableElement;
                          Exit;
                        end;
                    end;
                end;
              end;
            csInString:
              begin
                tempString := tempString + tempChar;
              end;
            csDelimiter:
              begin
                {this is where we move to next element of data}
                if Ord(CurrentElement) < Ord(peDaysOfWeek) then
                  begin
                    CurrentElement := TParseElement(Ord(CurrentElement) + 1);
                  end
                else
                  begin
                    Result := prUnreadableElement;
                    Exit;
                  end;
              end;
            csError:
              begin
                Result := prUnreadableElement;
                Exit;
              end;
          end;
        end;

      {if we have got here having set the days then result is no error}
      if CurrentElement = peDaysOfWeek then
        Result := prNoError
      else
        Result := prUnreadableElement;
    end;  {we at least have something}
end;

end.
