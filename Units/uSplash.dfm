object Splash: TSplash
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'Splash'
  ClientHeight = 361
  ClientWidth = 615
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -27
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  PixelsPerInch = 96
  TextHeight = 33
  object Label1: TLabel
    Left = 225
    Top = 36
    Width = 165
    Height = 33
    Caption = 'Splash Screen'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -27
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object Timer1: TTimer
    OnTimer = Timer1Timer
    Left = 296
    Top = 168
  end
end
