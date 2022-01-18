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
  object pnlMain: TPanel
    Left = 0
    Top = 65
    Width = 769
    Height = 564
    Align = alClient
    TabOrder = 2
    ExplicitLeft = 280
    ExplicitTop = 312
    ExplicitWidth = 185
    ExplicitHeight = 41
    object Splitter1: TSplitter
      Left = 329
      Top = 1
      Height = 562
      ExplicitLeft = 241
      ExplicitTop = 6
    end
    object pnlErrorLog: TPanel
      Left = 332
      Top = 1
      Width = 436
      Height = 562
      Align = alClient
      TabOrder = 0
      ExplicitLeft = 488
      ExplicitTop = 216
      ExplicitWidth = 185
      ExplicitHeight = 41
      object lblErrorLog: TLabel
        Left = 1
        Top = 1
        Width = 434
        Height = 16
        Align = alTop
        Caption = 'Error Log'
        ExplicitWidth = 53
      end
      object ErrorLog: TMemo
        Left = 1
        Top = 17
        Width = 434
        Height = 544
        Align = alClient
        ReadOnly = True
        ScrollBars = ssBoth
        TabOrder = 0
        ExplicitLeft = 2
        ExplicitTop = 2
        ExplicitWidth = 433
        ExplicitHeight = 560
      end
    end
    object pnlTree: TPanel
      Left = 1
      Top = 1
      Width = 328
      Height = 562
      Align = alLeft
      TabOrder = 1
      object lblBusServices: TLabel
        Left = 1
        Top = 1
        Width = 326
        Height = 16
        Align = alTop
        Caption = 'Bus Services'
        ExplicitWidth = 76
      end
      object BusDataTree: TTreeView
        Left = 1
        Top = 17
        Width = 326
        Height = 544
        Align = alClient
        Ctl3D = False
        Indent = 19
        ParentCtl3D = False
        ReadOnly = True
        SortType = stText
        TabOrder = 0
        OnExpanding = BusDataTreeExpanding
        ExplicitLeft = -144
        ExplicitTop = 1
        ExplicitWidth = 329
        ExplicitHeight = 560
      end
    end
  end
end
