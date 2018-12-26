object Main: TMain
  Left = 0
  Top = 0
  Caption = 'Main'
  ClientHeight = 312
  ClientWidth = 527
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
  object Button1: TButton
    Left = 422
    Top = 8
    Width = 75
    Height = 25
    Caption = 'Button1'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Memo1: TMemo
    Left = 24
    Top = 8
    Width = 209
    Height = 153
    Lines.Strings = (
      'Memo1')
    TabOrder = 1
  end
  object Button2: TButton
    Left = 422
    Top = 47
    Width = 75
    Height = 26
    Caption = 'Init '
    TabOrder = 2
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 424
    Top = 79
    Width = 73
    Height = 25
    Caption = 'Poll'
    TabOrder = 3
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 424
    Top = 120
    Width = 73
    Height = 25
    Caption = 'Read'
    TabOrder = 4
    OnClick = Button4Click
  end
  object Button5: TButton
    Left = 424
    Top = 168
    Width = 73
    Height = 25
    Caption = 'Button5'
    TabOrder = 5
    OnClick = Button5Click
  end
  object Button6: TButton
    Left = 414
    Top = 199
    Width = 83
    Height = 25
    Caption = 'Button6'
    TabOrder = 6
    OnClick = Button6Click
  end
  object Button7: TButton
    Left = 289
    Top = 183
    Width = 129
    Height = 33
    Caption = 'readpos'
    TabOrder = 7
    OnClick = Button7Click
  end
  object Button8: TButton
    Left = 297
    Top = 216
    Width = 121
    Height = 33
    Caption = 'set 0'
    TabOrder = 8
    OnClick = Button8Click
  end
  object Button9: TButton
    Left = 128
    Top = 216
    Width = 137
    Height = 41
    Caption = 'Button9'
    TabOrder = 9
    OnClick = Button9Click
  end
  object Edit1: TEdit
    Left = 264
    Top = 16
    Width = 121
    Height = 21
    NumbersOnly = True
    TabOrder = 10
    Text = '3000'
  end
  object Button10: TButton
    Left = 264
    Top = 40
    Width = 89
    Height = 25
    Caption = 'Button10'
    TabOrder = 11
    OnClick = Button10Click
  end
  object Button11: TButton
    Left = 272
    Top = 80
    Width = 81
    Height = 25
    Caption = 'Button11'
    TabOrder = 12
    OnClick = Button11Click
  end
  object Edit2: TEdit
    Left = 272
    Top = 112
    Width = 105
    Height = 21
    TabOrder = 13
    Text = '-1'
  end
end
