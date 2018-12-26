program ft260;

uses
  Vcl.Forms,
  i2cmain in 'i2cmain.pas' {Main},
  uLibFT260 in 'uLibFT260.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMain, Main);
  Application.Run;
end.
