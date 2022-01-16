object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = 'Bus Route Review'
  ClientHeight = 648
  ClientWidth = 769
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 16
  object pnlTop: TPanel
    Left = 0
    Top = 0
    Width = 769
    Height = 65
    Align = alTop
    TabOrder = 0
    DesignSize = (
      769
      65)
    object btnLoadData: TButton
      Left = 16
      Top = 16
      Width = 169
      Height = 34
      Anchors = [akLeft, akTop, akRight]
      Caption = 'Load Data'
      TabOrder = 0
      OnClick = btnLoadDataClick
    end
  end
  object MainPages: TPageControl
    Left = 0
    Top = 65
    Width = 769
    Height = 564
    ActivePage = ServicesPage
    Align = alClient
    TabOrder = 1
    object ServicesPage: TTabSheet
      Caption = 'Services'
      object Splitter1: TSplitter
        Left = 329
        Top = 0
        Height = 533
        ExplicitLeft = 376
        ExplicitTop = 304
        ExplicitHeight = 100
      end
      object BusDataTree: TTreeView
        Left = 0
        Top = 0
        Width = 329
        Height = 533
        Align = alLeft
        Ctl3D = False
        Indent = 19
        ParentCtl3D = False
        ReadOnly = True
        SortType = stText
        TabOrder = 0
      end
      object pnlInfoArea: TPanel
        Left = 332
        Top = 0
        Width = 429
        Height = 533
        Align = alClient
        BevelOuter = bvNone
        BorderStyle = bsSingle
        TabOrder = 1
        object lblAddInfo: TLabel
          AlignWithMargins = True
          Left = 8
          Top = 8
          Width = 409
          Height = 216
          Margins.Left = 8
          Margins.Top = 8
          Margins.Right = 8
          Margins.Bottom = 8
          Align = alTop
          Alignment = taCenter
          Caption = 
            'This panel might ordinarily expose data from the selected item. ' +
            'Each node has a pointer to its Model data item in its Data field' +
            ' and, while this would permit direct editing, it would be prefer' +
            'able to lock this out and allow the controller to handle this by' +
            ' passing the edited field plus the reference to the item being e' +
            'dited to allow the controller to handle the editing.'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -21
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          WordWrap = True
          ExplicitLeft = 3
          ExplicitTop = 3
          ExplicitWidth = 415
        end
      end
    end
    object ErrorsPage: TTabSheet
      Caption = 'Error Log'
      ImageIndex = 1
      object ErrorLog: TMemo
        Left = 0
        Top = 0
        Width = 761
        Height = 533
        Align = alClient
        ReadOnly = True
        ScrollBars = ssBoth
        TabOrder = 0
      end
    end
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 629
    Width = 769
    Height = 19
    Panels = <
      item
        Width = 200
      end>
  end
end
