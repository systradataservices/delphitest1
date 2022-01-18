unit HashedComponent;

  {==============================================}
  { Class allow fast searching of child items    }
  { using a hash table for O(1) lookup rather    }
  { than O(N) from searching through child items }
  { Author: Tony Foster                          }
  { Date: January 2022                           }
  {==============================================}

interface

uses
  Classes, SysUtils, System.Generics.Collections;

type
  THashedComponentClass = class of THashedComponent;

  THashedComponent = class(TComponent)
  private
  protected
    fFriendlyname: string;
    fHashTable: TDictionary<string, THashedComponent>;
    function GetFriendlyName: string;
    procedure SetFriendlyname(const Value: string);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function FindChildByName(TheName: string): THashedComponent;
    function AddChild(ChildName: string; ChildClass: THashedComponentClass): THashedComponent;
    function FindAddChildByName(ChildName: string; ChildClass: THashedComponentClass): THashedComponent;
    property FriendlyName: string read GetFriendlyName write SetFriendlyname;
  end;

implementation


{ THashedComponent }

function THashedComponent.AddChild(ChildName: string; ChildClass: THashedComponentClass): THashedComponent;
begin
  Result := nil;
  if ChildName <> '' then
    begin
      Result := FindChildByName(ChildName);
      if not Assigned(Result) then
        begin
          Result := ChildClass.Create(self);
          Result.FriendlyName := ChildName;
          fHashTable.Add(ChildName, Result);
        end;
    end;
end;

constructor THashedComponent.Create(AOwner: TComponent);
begin
  inherited;
  fHashTable := TDictionary<string, THashedComponent>.Create;
end;

destructor THashedComponent.Destroy;
begin
  FreeAndNil(fHashTable);
  inherited;
end;

function THashedComponent.FindAddChildByName(
  ChildName: string; ChildClass: THashedComponentClass): THashedComponent;
begin
  Result := FindChildByName(ChildName);
  if not Assigned(Result) then
    Result := AddChild(ChildName, ChildClass);
end;

function THashedComponent.FindChildByName(TheName: string): THashedComponent;
begin
  fHashTable.TryGetValue(TheName, Result);
end;

function THashedComponent.GetFriendlyName: string;
begin
  Result := fFriendlyname;
end;

procedure THashedComponent.SetFriendlyname(const Value: string);
begin
  fFriendlyname := Value;
end;

end.
