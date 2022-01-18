unit InstanceFactory;

  {==============================================}
  { Singleton Class to handle instance creation  }
  { fron provided interface GUID. Relies upon a  }
  { single implementing class per interface.     }
  { Author: Tony Foster                          }
  { Date: January 2022                           }
  {==============================================}

interface

uses
  SysUtils, System.Generics.Collections, RefCountedClass;

type
  TInstanceFactory = class
  private
    class var fSingleInstance: TInstanceFactory;
    fInterfaceHash: TDictionary<TGUID, TRefCountedClass>;
  protected
    constructor Create;
    function ImplementingClass(TheInterface: TGUID): TRefCountedClass;
  public
    destructor Destroy; override;
    class function SingleInstance: TInstanceFactory;
    class destructor DestroyClass;
    procedure RegisterInterfaceClass(TheInterface: TGUID; TheClass: TRefCountedClass);
    procedure DeRegisterInterfaceClass(TheInterface: TGUID; TheClass: TRefCountedClass);
    function CreateInstance(TheInterface: TGUID; out Obj; Injected: IInterface = nil): boolean;
  end;

implementation

{ TInstanceFactory }

constructor TInstanceFactory.Create;
begin
  inherited;
  fInterfaceHash := TDictionary<TGUID, TRefCountedClass>.Create;
end;

function TInstanceFactory.CreateInstance(TheInterface: TGUID; out obj; Injected: IInterface = nil): boolean;
var
  TheClass: TRefCountedClass;
  TheInstance: TRefCounted;
begin
  {look up implementing class and, if it exists,
  create an instance and return its interface entry.}
  Result := false;
  Pointer(Obj) := nil;
  TheClass := ImplementingClass(TheInterface);
  if TheClass <> nil then
    begin
      TheInstance := TheClass.CreateRefCounted(Injected);
      Result := TheInstance.GetInterface(TheInterface, obj);
    end;
end;

procedure TInstanceFactory.DeRegisterInterfaceClass(TheInterface: TGUID;
  TheClass: TRefCountedClass);
begin
  fInterfaceHash.Remove(TheInterface);
end;

destructor TInstanceFactory.Destroy;
begin
  FreeAndNil(fInterfaceHash);
  inherited;
end;

class destructor TInstanceFactory.DestroyClass;
begin
  if Assigned(fSingleInstance) then
    fSingleInstance.Free;
  fSingleInstance := nil;
end;

function TInstanceFactory.ImplementingClass(TheInterface: TGUID): TRefCountedClass;
begin
  if not fInterfaceHash.TryGetValue(TheInterface, Result) then
    Result := nil;
end;

procedure TInstanceFactory.RegisterInterfaceClass(TheInterface: TGUID;
  TheClass: TRefCountedClass);
begin
  fInterfaceHash.AddOrSetValue(TheInterface, TheClass);
end;

class function TInstanceFactory.SingleInstance: TInstanceFactory;
begin
  if not assigned(fSingleInstance) then
    fSingleInstance := TInstanceFactory.Create;
  result := fSingleInstance;
end;

end.
