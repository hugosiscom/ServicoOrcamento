unit dm;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.VCLUI.Wait, Data.DB, FireDAC.Comp.Client, FireDAC.Phys.FB,
  FireDAC.Phys.FBDef, IniFiles, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet,
  Vcl.ExtCtrls, Vcl.Dialogs, System.DateUtils, encrypt_decrypt;

type
  TDataModule1 = class(TDataModule)
    FDConn: TFDConnection;
    fdqParametros: TFDQuery;
    fdqEmpresaCount: TFDQuery;
    fdqEmpresaCountCOUNT: TLargeintField;
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
    procedure DataModuleCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
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
      // sConnStr := FDConn.ResultConnectionDef.BuildString();

      FDConn.Connected := True;
    finally
      Ini.free;
    end;

  Ativo := True;

end;

procedure TDataModule1.Timer1Timer(Sender: TObject);
begin
  if Ativo then
  begin

    Timer1.Enabled := false;
    try
      fdqEmpresaCount.Open;

      for var e: Integer := 1 to fdqEmpresaCountCOUNT.AsInteger do
      begin
        fdqParametros.Close;
        fdqParametros.ParamByName('CODEMPRESA').AsInteger := e;
        fdqParametros.Open;

        var
        limiteMinutos := fdqParametrosMINUTOS_LIMITE_ORCAMENTO.AsInteger;

        if limiteMinutos > 0 then
        begin
          fdqOrcAbertos.Close;
          fdqOrcAbertos.ParamByName('CODEMPRESA').AsInteger := e;
          fdqOrcAbertos.Open;

          fdqOrcAbertos.First;

          while not fdqOrcAbertos.Eof do
            if (fdqOrcAbertosRESERVA.AsString = 'S') and (fdqOrcAbertosNOTA_PROCESSADA.AsString = 'N') then
            begin
              var
              minutosPassados := MinutesBetween(Now, fdqOrcAbertosDATAHORA_COMPLETA.AsDateTime);

              if minutosPassados > limiteMinutos then
              begin
                fdqItemOrc.Close;
                fdqItemOrc.ParamByName('CD_ORCAM').AsInteger := fdqOrcAbertosCD_ORCAM.AsInteger;
                fdqItemOrc.Open;

                fdqItemOrc.First;

                while not fdqItemOrc.Eof do
                begin
                  fdqEstoque.Close;
                  fdqEstoque.ParamByName('CODPRODUTO').AsInteger := fdqItemOrcCD_PRODUTO.AsInteger;
                  fdqEstoque.ParamByName('CODEMPRESA').AsInteger := e;
                  fdqEstoque.Open;

                  if not fdqEstoque.IsEmpty then
                  begin
                    fdqEstoque.Edit;
                    fdqEstoqueESTOQUE.AsCurrency := fdqEstoqueESTOQUE.AsCurrency + fdqItemOrcQTD_PRODUTO.AsCurrency;
                    fdqEstoqueESTOQUE_RESERVA.AsCurrency := fdqEstoqueESTOQUE_RESERVA.AsCurrency - fdqItemOrcQTD_PRODUTO.AsCurrency;

                    fdqEstoque.Post;
                  end;

                  fdqItemOrc.Next;
                end;
                fdqOrcAbertos.Edit;
                fdqOrcAbertosCANCELADO_TP.AsString := 'EP';
                fdqOrcAbertos.Post;
                fdqOrcAbertos.Next;
              end
              else
                fdqOrcAbertos.Next;
            end
            else
              fdqOrcAbertos.Next;
        end;
      end;
    finally
      fdqEmpresaCount.Close;
      fdqParametros.Close;
      fdqOrcAbertos.Close;
      fdqItemOrc.Close;
      fdqEstoque.Close;
      Timer1.Enabled := True;
    end;
  end;

end;

end.
