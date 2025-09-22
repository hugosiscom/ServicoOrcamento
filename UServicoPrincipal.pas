unit UServicoPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.SvcMgr, Vcl.Dialogs;

type
  TServiceOrcamentoReserva = class(TService)
    procedure ServiceStart(Sender: TService; var Started: Boolean);
    procedure ServiceStop(Sender: TService; var Stopped: Boolean);
  private
    { Private declarations }
  public
    function GetServiceController: TServiceController; override;
    { Public declarations }
  end;

var
  ServiceOrcamentoReserva: TServiceOrcamentoReserva;

implementation

{$R *.dfm}

uses dm;

procedure ServiceController(CtrlCode: DWord); stdcall;
begin
  ServiceOrcamentoReserva.Controller(CtrlCode);
end;

function TServiceOrcamentoReserva.GetServiceController: TServiceController;
begin
  Result := ServiceController;
end;

procedure TServiceOrcamentoReserva.ServiceStart(Sender: TService; var Started: Boolean);
begin
  dm.DataModule1.Ativo := true;
end;

procedure TServiceOrcamentoReserva.ServiceStop(Sender: TService; var Stopped: Boolean);
begin
  dm.DataModule1.Ativo := false;
end;

end.
