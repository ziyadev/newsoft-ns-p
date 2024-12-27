program Project3;

uses
  Vcl.Forms,
  Unit3 in 'Unit3.pas' {Master},
  Unit1 in 'Unit1.pas' {Form1},
  Unit2 in 'Unit2.pas' {SessionVForm};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMaster, Master);
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TSessionVForm, SessionVForm);
  Application.Run;
end.
