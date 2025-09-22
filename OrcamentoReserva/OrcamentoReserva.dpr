program OrcamentoReserva;

uses
  Vcl.Forms,
  Form in 'Form.pas' {Form4},
  dm in 'dm.pas' {DataModule1: TDataModule},
  encrypt_decrypt in 'C:\Trabalho Atual\Compartilhado\encrypt_decrypt.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm4, Form4);
  Application.CreateForm(TDataModule1, DataModule1);
  Application.Run;
end.
