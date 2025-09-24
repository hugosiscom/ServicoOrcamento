unit dm;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.VCLUI.Wait, Data.DB, FireDAC.Comp.Client, FireDAC.Phys.FB,
  FireDAC.Phys.FBDef, IniFiles, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet,
  Vcl.ExtCtrls, Vcl.Dialogs, System.DateUtils, encrypt_decrypt, UUtilidade;

type
  TDataModule1 = class(TDataModule)
    FDConn: TFDConnection;
    fdqParametros: TFDQuery;
    fdqEmpresa: TFDQuery;
    Timer1: TTimer;
    fdqParametrosMINUTOS_LIMITE_ORCAMENTO: TIntegerField;
    fdqOrcAbertos: TFDQuery;
    fdqOrcAbertosCD_ORCAM: TIntegerField;
    fdqItemOrc: TFDQuery;
    fdqItemOrcCD_PRODUTO: TIntegerField;
    fdqItemOrcQTD_PRODUTO: TBCDField;
    fdqItemOrcQUANTIDADE_NF: TBCDField;
    fdqEstoque: TFDQuery;
    fdqEstoqueCODEMPRESA: TIntegerField;
    fdqEstoqueCODPRODUTO: TIntegerField;
    fdqEstoqueESTOQUE: TBCDField;
    fdqEstoqueESTOQUE_RESERVA: TBCDField;
    fdqEstoqueQTDPC: TBCDField;
    fdqEstoqueESTOQUE_CONS: TBCDField;
    fdqEstoqueID_SETOR_ESTOQUE: TIntegerField;
    fdqEstoqueVALOR_CUSTO: TFMTBCDField;
    fdqEstoqueVALOR_CUSTO_MEDIO: TFMTBCDField;
    fdqEstoqueVALOR_VENDA: TFMTBCDField;
    fdqEstoqueVALOR_REVENDA: TFMTBCDField;
    fdqEstoqueDATA_HORA_ALTERACAO: TSQLTimeStampField;
    fdqEstoqueVALOR_VENDA_DOLAR: TBCDField;
    fdqEstoqueCBENEF: TStringField;
    fdqEstoqueVALOR_ULTIMO_CUSTO: TBCDField;
    fdqOrcAbertosCANCELADO_TP: TStringField;
    fdqOrcAbertosNOTA_PROCESSADA: TStringField;
    fdqOrcAbertosRESERVA: TStringField;
    fdqOrcAbertosDATAHORA_COMPLETA: TSQLTimeStampField;
    fdqOrcAbertosDESCRICAO: TStringField;
    QryLogs: TFDQuery;
    QryLogsCODIGO: TIntegerField;
    QryLogsCOD_EMPRESA: TIntegerField;
    QryLogsTABELA: TStringField;
    QryLogsDATA: TDateField;
    QryLogsCOD_USUARIO: TIntegerField;
    QryLogsCAMPO_CHAVE: TIntegerField;
    QryLogsDESCRICAO: TMemoField;
    QryLogsUSUARIO: TStringField;
    QryLogsDS_USUARIO: TStringField;
    QryLogsLOJA: TStringField;
    fdqEmpresaCODIGO: TIntegerField;
    procedure DataModuleCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure logBanco(codEmpresa: Integer; codCampoChave: Integer; fdquery: TFDQuery; tabela: String);
  private
    { Private declarations }
  public
  var
    Ativo: boolean;
  end;

var
  DataModule1: TDataModule1;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}
{$R *.dfm}

procedure TDataModule1.DataModuleCreate(Sender: TObject);

begin
  var
    conect: String := 'connections.ini';
  var
  Ini := TIniFile.create((ExtractFilePath(ParamStr(0)) + conect));
  with Ini do
    try
      FDConn.Connected := false;
      FDConn.Params.Clear;
      FDConn.Params.Add('DriverID=FB');
      FDConn.Params.Add('Database=' + (Ini.ReadString('Siscomsoft', ('PATH'), '')));
      FDConn.Params.Add('User_Name=' + (Ini.ReadString('Siscomsoft', ('USER'), '')));
      FDConn.Params.Add('Password=' + Decode(Ini.ReadString('Siscomsoft', ('Password'), '')));
      FDConn.Params.Add('Protocol=TCP');
      FDConn.Params.Add('Server=' + (Ini.ReadString('Siscomsoft', ('SERVER'), '')));
      FDConn.Params.Add('CharacterSet=' + (Ini.ReadString('Siscomsoft', ('ServerCharSet'), '')));
      FDConn.Params.Add('SQLDialect=' + (Ini.ReadString('Siscomsoft', ('SQLDialect'), '')));

      FDConn.Connected := True;
    finally
      Ini.free;
    end;

end;

procedure TDataModule1.logBanco(codEmpresa: Integer; codCampoChave: Integer; fdquery: TFDQuery; tabela: String);
begin
  try
    var
    stLog := TStringList.create;
    stLog.AddStrings(GerarLogFD(fdquery, fdquery.UpdateStatus));
    QryLogs.Open;
    QryLogs.Append;
    QryLogs.FieldByName('COD_EMPRESA').AsInteger := codEmpresa;
    QryLogs.FieldByName('TABELA').AsString := tabela;
    QryLogs.FieldByName('DATA').AsDateTime := Date;
    QryLogs.FieldByName('COD_USUARIO').AsInteger := 1;
    QryLogs.FieldByName('CAMPO_CHAVE').AsInteger := codCampoChave;
    QryLogs.FieldByName('USUARIO').AsString := 'root';
    QryLogs.FieldByName('DESCRICAO').AsString := stLog.Text + ' Gerado AUTOMATICAMENTE pelo Serviço Orcamento Reserva';
    QryLogs.Post;
    QryLogs.close;
    stLog.Clear;
  except
    On E: Exception do
    begin
      // ShowException(E.Message);
    end;

  end;
end;

procedure TDataModule1.Timer1Timer(Sender: TObject);
begin
  if Ativo then
  begin

    Timer1.Enabled := false;
    try
      fdqEmpresa.Open;
      FDConn.StartTransaction;
      fdqEmpresa.first;
      while not fdqEmpresa.Eof do
      begin
        fdqParametros.close;
        fdqParametros.ParamByName('CODEMPRESA').AsInteger := fdqEmpresaCODIGO.AsInteger;
        fdqParametros.Open;

        var
        limiteMinutos := fdqParametrosMINUTOS_LIMITE_ORCAMENTO.AsInteger;

        if limiteMinutos > 0 then
        begin
          fdqOrcAbertos.close;
          fdqOrcAbertos.ParamByName('CODEMPRESA').AsInteger := fdqEmpresaCODIGO.AsInteger;
          fdqOrcAbertos.Open;

          // somente orçamento reserva e no processados
          fdqOrcAbertos.first;
          while not fdqOrcAbertos.Eof do
          begin
            var
            minutosPassados := MinutesBetween(Now, fdqOrcAbertosDATAHORA_COMPLETA.AsDateTime);

            if minutosPassados > limiteMinutos then
            begin
              fdqItemOrc.close;
              fdqItemOrc.ParamByName('CD_ORCAM').AsInteger := fdqOrcAbertosCD_ORCAM.AsInteger;
              fdqItemOrc.Open;

              fdqItemOrc.first;

              while not fdqItemOrc.Eof do
              begin
                fdqEstoque.close;
                fdqEstoque.ParamByName('CODPRODUTO').AsInteger := fdqItemOrcCD_PRODUTO.AsInteger;
                fdqEstoque.ParamByName('CODEMPRESA').AsInteger := fdqEmpresaCODIGO.AsInteger;
                fdqEstoque.Open;

                if not fdqEstoque.IsEmpty then
                begin
                  fdqEstoque.Edit;
                  fdqEstoqueESTOQUE.AsCurrency := fdqEstoqueESTOQUE.AsCurrency + fdqItemOrcQTD_PRODUTO.AsCurrency;
                  fdqEstoqueESTOQUE_RESERVA.AsCurrency := fdqEstoqueESTOQUE_RESERVA.AsCurrency - fdqItemOrcQTD_PRODUTO.AsCurrency;
                  fdqEstoque.Post;
                  fdqEstoque.ApplyUpdates;

                  logBanco(fdqEmpresaCODIGO.AsInteger, fdqItemOrcCD_PRODUTO.AsInteger, fdqEstoque, 'ESTOQUE');
                end;

                fdqItemOrc.Next;
              end;
              fdqOrcAbertos.Edit;
              fdqOrcAbertosCANCELADO_TP.AsString := 'EP';
              fdqOrcAbertos.Post;
              fdqOrcAbertos.ApplyUpdates;

              logBanco(fdqEmpresaCODIGO.AsInteger, fdqOrcAbertosCD_ORCAM.AsInteger, fdqOrcAbertos, 'NOTAORC');

              fdqOrcAbertos.Next;
            end
            else
              fdqOrcAbertos.Next;
          end
        end;
        fdqEmpresa.Next;
      end;
    finally
      FDConn.Commit;
      fdqEmpresa.close;
      fdqParametros.close;
      fdqOrcAbertos.close;
      fdqItemOrc.close;
      fdqEstoque.close;
      Timer1.Enabled := True;
    end;
  end;

end;

end.
