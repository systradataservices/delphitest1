unit ViewInterface;

interface

uses
  ComCtrls;

type
  IView = interface
  ['{2A081C02-8D38-49A0-AA21-2CF13A87B8D6}']
    procedure ClearDisplay;
    function AddTopLevelNode(ItemName: string): TTreeNode;
    function AddChildNode(Parent: TTreeNode; ItemName: string): TTreeNode;
    procedure SortNodes;
    procedure ExpandNodes;
  end;

implementation

end.
