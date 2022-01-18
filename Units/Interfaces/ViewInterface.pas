unit ViewInterface;

interface

uses
  ComCtrls;

type
  IView = interface
  ['{2A081C02-8D38-49A0-AA21-2CF13A87B8D6}']
    function AddTopLevelNode(ItemName: string): TTreeNode;
    function AddChildNode(Parent: TTreeNode; ItemName: string): TTreeNode;
    procedure AddDummyNode(ParentNode: TTreeNode);
  end;

implementation

end.
