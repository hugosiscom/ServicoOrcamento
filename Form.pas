unit Form;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons;

type
  TForm4 = class(TForm)
    btnParar: TBitBtn;
    btnIniciar: TBitBtn;
    procedure btnIniciarClick(Sender: TObject);
    procedure btnPararClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form4: TForm4;

implementation

{$R *.dfm}

uses dm;

procedure TForm4.btnIniciarClick(Sender: TObject);
begin
  dm.DataModule1.Ativo := true;
  dm.DataModule1.Timer1.Enabled := true;
  btnIniciar.Enabled := false;
  btnParar.Enabled := true;
end;

procedure TForm4.btnPararClick(Sender: TObject);
begin
  dm.DataModule1.Ativo := false;
  dm.DataModule1.Timer1.Enabled := false;
  btnParar.Enabled := false;
  btnIniciar.Enabled := true;
end;

end.
