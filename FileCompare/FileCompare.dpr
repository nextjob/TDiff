program FileCompare;

uses
  Vcl.Forms,
  Main in 'Main.pas' {Form3},
  HashUnit in 'HashUnit.pas',
  About in 'About.pas' {AboutBox};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFrmFileCompare, FrmFileCompare);
  Application.CreateForm(TAboutBox, AboutBox);
  Application.Run;

end.
