unit CharacterStack;

interface

type
  TCharacterStack = class
  private
    fData: array of Char;
    fCount: integer;
    fCurrentLength: integer;
    FGrowthStep: integer;
    procedure SetGrowthStep(const Value: integer);
    function Grow: integer;
    function Shrink: integer;
  protected
  public
    function Push(NewChar: Char): integer;
    function Pop: Char;
    function Peek: Char;
    constructor Create;
    property GrowthStep: integer read FGrowthStep write SetGrowthStep;
  end;

implementation

{ TCharacterStack }

constructor TCharacterStack.Create;
begin
  inherited Create;
  FGrowthStep    := 10;
  fCount         := 0;
  fCurrentLength := 0;
  Grow;
end;

function TCharacterStack.Grow: integer;
begin
  Inc(fCurrentLength, fGrowthStep);
  SetLength(fData, fCurrentLength);
  Result := fCurrentLength;
end;

function TCharacterStack.Peek: Char;
begin
  Result := #0;
  {read value on top of stack, if present}
  if (fCount > 0) and (fCurrentLength >= fCount) then
    Result := fData[fCount - 1];
end;

function TCharacterStack.Pop: Char;
begin
  {get top element}
  Result := Peek;

  {a pop removes top element}
  if fCount > 0 then
    Dec(fCount);
  {shrink stack if necessary. No conditional as we check in shrink}
  Shrink;
end;

function TCharacterStack.Push(NewChar: Char): integer;
begin
  {a new char going onto the top of the stack}
  inc(fCount);
  {see if we need to grow. Conditional as not checked in Grow}
  if fCurrentLength - fCount < 1 then
    Grow;
  {add new char into top element and return new count}
  fData[fCount - 1] := NewChar;
  Result := fCount;
end;

procedure TCharacterStack.SetGrowthStep(const Value: integer);
begin
  FGrowthStep := Value;
end;

function TCharacterStack.Shrink: integer;
begin
  {to avoid excessive grow/shrink cycles only shrink when
  we are two steps below size}
  if fCurrentLength - fCount >= 2 * FGrowthStep then
    begin
      Dec(fCurrentLength, fGrowthStep);
      SetLength(fData, fCurrentLength);
    end;
  Result := fCurrentLength;
end;

end.
