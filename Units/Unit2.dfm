object SessionVForm: TSessionVForm
  Left = 0
  Top = 0
  BorderIcons = [biMinimize, biMaximize]
  BorderStyle = bsToolWindow
  Caption = 'Validation de session'
  ClientHeight = 75
  ClientWidth = 379
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OldCreateOrder = True
  Position = poDesktopCenter
  PixelsPerInch = 96
  TextHeight = 15
  object Label1: TLabel
    Left = 104
    Top = 14
    Width = 161
    Height = 15
    Caption = 'Validation de session en cour...'
  end
  object ProgressBar1: TProgressBar
    Left = 16
    Top = 35
    Width = 337
    Height = 17
    Style = pbstMarquee
    TabOrder = 0
  end
end
