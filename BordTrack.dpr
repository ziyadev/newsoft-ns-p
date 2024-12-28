program BordTrack;

uses
  Vcl.Forms,
  Unit2 in 'units\Unit2.pas' {SessionVForm},
  uSplash in 'units\uSplash.pas' {Splash},
  uAuthenticate in 'units\uAuthenticate.pas' {Authenticate},
  UMaster in 'units\UMaster.pas' {Master},
  DelphiZXIngQRCode in 'Units\DelphiZXIngQRCode.pas',
  Unit4 in 'Units\Unit4.pas' {ActivationSuccess};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TSplash, Splash);
  Application.Run;

end.
