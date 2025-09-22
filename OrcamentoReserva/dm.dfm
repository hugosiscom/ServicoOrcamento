object DataModule1: TDataModule1
  OnCreate = DataModuleCreate
  Height = 480
  Width = 640
  object FDConn: TFDConnection
    ConnectionName = 'SiscomServOff'
    Params.Strings = (
      'CharacterSet=WIN1252'
      'User_Name=sysdba'
      'Password=masterkey'
      'Database=C:\SISCOM\bd5\COMERCIAL.FDB'
      'Port=3050'
      'Protocol=TCPIP'
      'DriverID=FB')
    ResourceOptions.AssignedValues = [rvAutoReconnect]
    ResourceOptions.AutoReconnect = True
    TxOptions.Isolation = xiReadCommitted
    ConnectedStoredUsage = []
    LoginPrompt = False
    Left = 13
    Top = 8
  end
  object fdqParametros: TFDQuery
    Connection = FDConn
    SQL.Strings = (
      
        'select MINUTOS_LIMITE_ORCAMENTO from PARAMETROS where CODEMPRESA' +
        ' = :CODEMPRESA')
    Left = 96
    Top = 80
    ParamData = <
      item
        Name = 'CODEMPRESA'
        DataType = ftInteger
        ParamType = ptInput
      end>
    object fdqParametrosMINUTOS_LIMITE_ORCAMENTO: TIntegerField
      FieldName = 'MINUTOS_LIMITE_ORCAMENTO'
      Origin = 'MINUTOS_LIMITE_ORCAMENTO'
    end
  end
  object fdqEmpresaCount: TFDQuery
    Connection = FDConn
    SQL.Strings = (
      'select count(*) from empresa em where em.INATIVA = '#39'N'#39)
    Left = 104
    Top = 8
    object fdqEmpresaCountCOUNT: TLargeintField
      AutoGenerateValue = arDefault
      FieldName = 'COUNT'
      Origin = '"COUNT"'
      ProviderFlags = []
      ReadOnly = True
    end
  end
  object Timer1: TTimer
    Interval = 60000
    OnTimer = Timer1Timer
    Left = 576
    Top = 16
  end
  object fdqOrcAbertos: TFDQuery
    Connection = FDConn
    SQL.Strings = (
      
        'select nt.CD_ORCAM,  nt.DT_ORCAM + nt.HORA_MOV AS DATAHORA_COMPL' +
        'ETA, nt.CANCELADO_TP,nt.NOTA_PROCESSADA, op.RESERVA, op.DESCRICA' +
        'O '
      'from notaorc nt'
      'join operacoes op on nt.OPERACAO = OP.CODIGO   '
      
        'where (nt.NOTA_PROCESSADA = '#39'N'#39' or nt.NOTA_PROCESSADA is null) a' +
        'nd (nt.CANCELADO_TP is null) and nt.CODEMPRESA = :CODEMPRESA and' +
        '  op.RESERVA = '#39'S'#39)
    Left = 184
    Top = 80
    ParamData = <
      item
        Name = 'CODEMPRESA'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end>
    object fdqOrcAbertosCD_ORCAM: TIntegerField
      FieldName = 'CD_ORCAM'
      Origin = 'CD_ORCAM'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
    end
    object fdqOrcAbertosCANCELADO_TP: TStringField
      FieldName = 'CANCELADO_TP'
      Origin = 'CANCELADO_TP'
      Size = 2
    end
    object fdqOrcAbertosNOTA_PROCESSADA: TStringField
      FieldName = 'NOTA_PROCESSADA'
      Origin = 'NOTA_PROCESSADA'
      FixedChar = True
      Size = 1
    end
    object fdqOrcAbertosRESERVA: TStringField
      AutoGenerateValue = arDefault
      FieldName = 'RESERVA'
      Origin = 'RESERVA'
      ProviderFlags = []
      ReadOnly = True
      FixedChar = True
      Size = 1
    end
    object fdqOrcAbertosDATAHORA_COMPLETA: TSQLTimeStampField
      AutoGenerateValue = arDefault
      FieldName = 'DATAHORA_COMPLETA'
      Origin = 'DATAHORA_COMPLETA'
      ProviderFlags = []
      ReadOnly = True
    end
    object fdqOrcAbertosDESCRICAO: TStringField
      AutoGenerateValue = arDefault
      FieldName = 'DESCRICAO'
      Origin = 'DESCRICAO'
      ProviderFlags = []
      ReadOnly = True
      Size = 60
    end
  end
  object fdqItemOrc: TFDQuery
    Connection = FDConn
    SQL.Strings = (
      
        'select it.CD_PRODUTO, it.QTD_PRODUTO, it.QUANTIDADE_NF from iten' +
        'orc it where it.CD_ORCAM = :CD_ORCAM')
    Left = 264
    Top = 80
    ParamData = <
      item
        Name = 'CD_ORCAM'
        DataType = ftInteger
        ParamType = ptInput
      end>
    object fdqItemOrcCD_PRODUTO: TIntegerField
      FieldName = 'CD_PRODUTO'
      Origin = 'CD_PRODUTO'
    end
    object fdqItemOrcQTD_PRODUTO: TBCDField
      FieldName = 'QTD_PRODUTO'
      Origin = 'QTD_PRODUTO'
      Precision = 18
    end
    object fdqItemOrcQUANTIDADE_NF: TBCDField
      FieldName = 'QUANTIDADE_NF'
      Origin = 'QUANTIDADE_NF'
      Precision = 18
    end
  end
  object fdqEstoque: TFDQuery
    Connection = FDConn
    SQL.Strings = (
      
        'select * from estoque est where est.CODPRODUTO = :CODPRODUTO and' +
        ' est.CODEMPRESA = :CODEMPRESA')
    Left = 336
    Top = 80
    ParamData = <
      item
        Name = 'CODPRODUTO'
        DataType = ftInteger
        ParamType = ptInput
      end
      item
        Name = 'CODEMPRESA'
        DataType = ftInteger
        ParamType = ptInput
      end>
    object fdqEstoqueCODEMPRESA: TIntegerField
      FieldName = 'CODEMPRESA'
      Origin = 'CODEMPRESA'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
    end
    object fdqEstoqueCODPRODUTO: TIntegerField
      FieldName = 'CODPRODUTO'
      Origin = 'CODPRODUTO'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
    end
    object fdqEstoqueESTOQUE: TBCDField
      FieldName = 'ESTOQUE'
      Origin = 'ESTOQUE'
      Precision = 18
    end
    object fdqEstoqueESTOQUE_RESERVA: TBCDField
      FieldName = 'ESTOQUE_RESERVA'
      Origin = 'ESTOQUE_RESERVA'
      Precision = 18
    end
    object fdqEstoqueQTDPC: TBCDField
      FieldName = 'QTDPC'
      Origin = 'QTDPC'
      Precision = 18
    end
    object fdqEstoqueESTOQUE_CONS: TBCDField
      FieldName = 'ESTOQUE_CONS'
      Origin = 'ESTOQUE_CONS'
      Precision = 18
    end
    object fdqEstoqueID_SETOR_ESTOQUE: TIntegerField
      FieldName = 'ID_SETOR_ESTOQUE'
      Origin = 'ID_SETOR_ESTOQUE'
    end
    object fdqEstoqueVALOR_CUSTO: TFMTBCDField
      FieldName = 'VALOR_CUSTO'
      Origin = 'VALOR_CUSTO'
      Precision = 18
      Size = 6
    end
    object fdqEstoqueVALOR_CUSTO_MEDIO: TFMTBCDField
      FieldName = 'VALOR_CUSTO_MEDIO'
      Origin = 'VALOR_CUSTO_MEDIO'
      Precision = 18
      Size = 6
    end
    object fdqEstoqueVALOR_VENDA: TFMTBCDField
      FieldName = 'VALOR_VENDA'
      Origin = 'VALOR_VENDA'
      Precision = 18
      Size = 6
    end
    object fdqEstoqueVALOR_REVENDA: TFMTBCDField
      FieldName = 'VALOR_REVENDA'
      Origin = 'VALOR_REVENDA'
      Precision = 18
      Size = 6
    end
    object fdqEstoqueDATA_HORA_ALTERACAO: TSQLTimeStampField
      FieldName = 'DATA_HORA_ALTERACAO'
      Origin = 'DATA_HORA_ALTERACAO'
    end
    object fdqEstoqueVALOR_VENDA_DOLAR: TBCDField
      FieldName = 'VALOR_VENDA_DOLAR'
      Origin = 'VALOR_VENDA_DOLAR'
      Precision = 18
    end
    object fdqEstoqueCBENEF: TStringField
      FieldName = 'CBENEF'
      Origin = 'CBENEF'
      Size = 15
    end
    object fdqEstoqueVALOR_ULTIMO_CUSTO: TBCDField
      FieldName = 'VALOR_ULTIMO_CUSTO'
      Origin = 'VALOR_ULTIMO_CUSTO'
      Precision = 18
    end
  end
end
