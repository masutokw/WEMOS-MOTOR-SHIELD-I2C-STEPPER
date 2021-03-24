object Main: TMain
  Left = 0
  Top = 0
  Caption = 'FT260 tester for WEMOS stepper'
  ClientHeight = 163
  ClientWidth = 401
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 2
    Top = 125
    Width = 31
    Height = 13
    Caption = 'Label1'
  end
  object Label2: TLabel
    Left = 112
    Top = 124
    Width = 31
    Height = 13
    Caption = 'Label2'
  end
  object Label3: TLabel
    Left = 360
    Top = 59
    Width = 38
    Height = 13
    Caption = 'mteps/s'
  end
  object Label4: TLabel
    Left = 358
    Top = 91
    Width = 23
    Height = 13
    Caption = 'Ticks'
  end
  object Button_Check: TButton
    Left = 88
    Top = 140
    Width = 81
    Height = 16
    Caption = 'Button_Check'
    TabOrder = 0
    OnClick = Button_CheckClick
  end
  object Memo1: TMemo
    Left = 0
    Top = 0
    Width = 209
    Height = 121
    Lines.Strings = (
      'Memo1')
    TabOrder = 1
  end
  object Button7: TButton
    Left = 210
    Top = 114
    Width = 73
    Height = 21
    Caption = 'Read Counter'
    TabOrder = 2
    OnClick = Button7Click
  end
  object Button_Set_Pos: TButton
    Left = 210
    Top = 28
    Width = 70
    Height = 21
    Caption = 'Set Counter'
    TabOrder = 3
    OnClick = Button_Set_PosClick
  end
  object Edit1: TEdit
    Left = 306
    Top = 84
    Width = 48
    Height = 21
    Alignment = taRightJustify
    TabOrder = 4
    Text = '3000'
  end
  object ButtonSpeed: TButton
    Left = 210
    Top = 85
    Width = 57
    Height = 21
    Caption = 'Set Period'
    TabOrder = 5
    OnClick = ButtonSpeedClick
  end
  object ButtonTarget: TButton
    Left = 210
    Top = 1
    Width = 72
    Height = 21
    Caption = 'Set target'
    TabOrder = 6
    OnClick = ButtonTargetClick
  end
  object Edit2: TEdit
    Left = 285
    Top = 2
    Width = 69
    Height = 21
    Alignment = taRightJustify
    TabOrder = 7
    Text = '-1'
  end
  object CheckBox_poll: TCheckBox
    Left = 307
    Top = 116
    Width = 87
    Height = 17
    Caption = 'Read counter'
    Checked = True
    State = cbChecked
    TabOrder = 8
    OnClick = CheckBox_pollClick
  end
  object Button_goto: TButton
    Left = 356
    Top = 2
    Width = 38
    Height = 21
    Caption = 'Goto'
    TabOrder = 9
    OnClick = Button_gotoClick
  end
  object Button1: TButton
    Left = -1
    Top = 141
    Width = 73
    Height = 17
    Caption = 'Buttontable'
    TabOrder = 10
    OnClick = Button1Click
  end
  object Edit_hz: TEdit
    Left = 285
    Top = 55
    Width = 69
    Height = 21
    Alignment = taRightJustify
    TabOrder = 11
    Text = '200'
  end
  object Buttonhz: TButton
    Left = 210
    Top = 56
    Width = 69
    Height = 21
    Caption = 'Set Speed'
    TabOrder = 12
    OnClick = ButtonhzClick
  end
  object Edit3: TEdit
    Left = 285
    Top = 27
    Width = 69
    Height = 21
    Alignment = taRightJustify
    TabOrder = 13
    Text = '0'
  end
  object Timer1: TTimer
    Interval = 200
    OnTimer = Timer1Timer
    Left = 21
    Top = 30
  end
end
