program ServicoOrcamentoReserva;

uses
  Vcl.SvcMgr,
  UServicoPrincipal in 'UServicoPrincipal.pas' {ServiceOrcamentoReserva: TService},
  encrypt_decrypt in 'C:\Trabalho Atual\Compartilhado\encrypt_decrypt.pas',
  dm in 'OrcamentoReserva\dm.pas' {DataModule1: TDataModule};

{$R *.RES}

begin
  // Windows 2003 Server requires StartServiceCtrlDispatcher to be
  // called before CoRegisterClassObject, which can be called indirectly
  // by Application.Initialize. TServiceApplication.DelayInitialize allows
  // Application.Initialize to be called from TService.Main (after
  // StartServiceCtrlDispatcher has been called).
  //
  // Delayed initialization of the Application object may affect
  // events which then occur prior to initialization, such as
  // TService.OnCreate. It is only recommended if the ServiceApplication
  // registers a class object with OLE and is intended for use with
  // Windows 2003 Server.
  //
  // Application.DelayInitialize := True;
  //
  if not Application.DelayInitialize or Application.Installing then
    Application.Initialize;
  Application.CreateForm(TServiceOrcamentoReserva, ServiceOrcamentoReserva);
  Application.CreateForm(TDataModule1, DataModule1);
  Application.Run;
end.
