object Main: TMain
  Left = 0
  Top = 0
  Caption = 'FT260 tester for WEMOS stepper'
  ClientHeight = 195
  ClientWidth = 394
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 141
    Width = 31
    Height = 13
    Caption = 'Label1'
  end
  object Label2: TLabel
    Left = 8
    Top = 168
    Width = 31
    Height = 13
    Caption = 'Label2'
  end
  object Button_Check: TButton
    Left = 311
    Top = 163
    Width = 75
    Height = 25
    Caption = 'Button_Check'
    TabOrder = 0
    OnClick = Button_CheckClick
  end
  object Memo1: TMemo
    Left = 8
    Top = 8
    Width = 209
    Height = 121
    Lines.Strings = (
      'Memo1')
    TabOrder = 1
  end
  object Button7: TButton
    Left = 119
    Top = 135
    Width = 98
    Height = 28
    Caption = 'readpos'
    TabOrder = 2
    OnClick = Button7Click
  end
  object Button_Set_Pos: TButton
    Left = 223
    Top = 70
    Width = 57
    Height = 25
    Caption = 'position'
    TabOrder = 3
    OnClick = Button_Set_PosClick
  end
  object Edit1: TEdit
    Left = 286
    Top = 8
    Width = 73
    Height = 21
    Alignment = taRightJustify
    TabOrder = 4
    Text = '3000'
  end
  object ButtonSpeed: TButton
    Left = 223
    Top = 8
    Width = 57
    Height = 25
    Caption = 'speed'
    TabOrder = 5
    OnClick = ButtonSpeedClick
  end
  object ButtonTarget: TButton
    Left = 223
    Top = 39
    Width = 57
    Height = 25
    Caption = 'target'
    TabOrder = 6
    OnClick = ButtonTargetClick
  end
  object Edit2: TEdit
    Left = 286
    Top = 41
    Width = 73
    Height = 21
    Alignment = taRightJustify
    TabOrder = 7
    Text = '-1'
  end
  object CheckBox_poll: TCheckBox
    Left = 232
    Top = 135
    Width = 73
    Height = 17
    Caption = 'CheckBox_poll'
    Checked = True
    State = cbChecked
    TabOrder = 8
    OnClick = CheckBox_pollClick
  end
  object Button_goto: TButton
    Left = 288
    Top = 72
    Width = 73
    Height = 23
    Caption = 'Goto'
    TabOrder = 9
    OnClick = Button_gotoClick
  end
  object Button1: TButton
    Left = 120
    Top = 169
    Width = 97
    Height = 17
    Caption = 'Buttontable'
    TabOrder = 10
    OnClick = Button1Click
  end
  object Edit_hz: TEdit
    Left = 224
    Top = 104
    Width = 57
    Height = 21
    TabOrder = 11
    Text = '2'
  end
  object Buttonhz: TButton
    Left = 288
    Top = 104
    Width = 65
    Height = 25
    Caption = 'Buttonhz'
    TabOrder = 12
    OnClick = ButtonhzClick
  end
  object Timer1: TTimer
    Interval = 500
    OnTimer = Timer1Timer
    Left = 344
    Top = 128
  end
end
