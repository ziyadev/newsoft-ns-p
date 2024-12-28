unit uSplash;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TSplash = class(TForm)
    Label1: TLabel;
    Timer1: TTimer;
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Splash: TSplash;

implementation

uses
  uAuthenticate;

{$R *.dfm}

procedure TSplash.Timer1Timer(Sender: TObject);
begin
  Timer1.Enabled := False;
  Application.CreateForm(TAuthenticate, Authenticate);
  Authenticate.ShowModal;
end;

end.
