unit RefCountedClass;

  {==============================================}
  { Base class for interface implementors giving }
  { simple reference counting for lifetime       }
  { management.                                  }
  { Author: Tony Foster                          }
  { Date: January 2022                           }
  {==============================================}

interface

type
  TRefCountedClass = class of TRefCounted;

  TRefCounted = class(TObject, IInterface)
  protected
    fRefCount: integer;
    procedure DoInitialisation; virtual;
    { IInterface }
    function QueryInterface(const IID: TGUID; out Obj): HResult; virtual; stdcall;
    function _AddRef: Integer; stdcall;
    function _Release: Integer; stdcall;
  public
    constructor CreateRefCounted; virtual;
  end;

implementation

uses
  Windows;

{ TRefCounted }

constructor TRefCounted.CreateRefCounted;
begin
  inherited Create;
  DoInitialisation;
end;

procedure TRefCounted.DoInitialisation;
begin
  fRefCount := 0;
end;

function TRefCounted.QueryInterface(const IID: TGUID; out Obj): HResult;
begin
  if GetInterface(IID, Obj) then
    Result := S_OK
  else
    Result := E_NOINTERFACE;
end;

function TRefCounted._AddRef: Integer;
begin
  inc(fRefCount);
  Result := fRefCount;
end;

function TRefCounted._Release: Integer;
begin
  Dec(fRefCount);
  if fRefCount <= 0 then
    Free;
  Result := fRefCount;
end;

end.
