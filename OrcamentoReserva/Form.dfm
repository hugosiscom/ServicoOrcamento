object Form4: TForm4
  Left = 0
  Top = 0
  Caption = 'Servi'#231'o Or'#231'amento'
  ClientHeight = 99
  ClientWidth = 230
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  TextHeight = 15
  object btnParar: TBitBtn
    Left = 147
    Top = 66
    Width = 75
    Height = 25
    Align = alCustom
    Anchors = [akRight, akBottom]
    Caption = 'Parar'
    TabOrder = 0
    OnClick = btnPararClick
    ExplicitLeft = 463
    ExplicitTop = 273
  end
  object btnIniciar: TBitBtn
    Left = 8
    Top = 66
    Width = 75
    Height = 25
    Hint = 
      'Inicia o timer para verificar de minuto '#224' minuto se existem or'#231'a' +
      'mentos n'#227'o processados e os marca como cancelados.'
    Align = alCustom
    Anchors = [akLeft, akBottom]
    Caption = 'Iniciar'
    TabOrder = 1
    OnClick = btnIniciarClick
    ExplicitTop = 273
  end
  object Timer1: TTimer
    Interval = 3000
    OnTimer = Timer1Timer
    Left = 96
    Top = 8
  end
end
