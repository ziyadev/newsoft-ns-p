unit Unit4;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TActivationSuccess = class(TForm)
    StaticText1: TStaticText;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ActivationSuccess: TActivationSuccess;

implementation

{$R *.dfm}

uses uSplash, Unit2, UMaster, uAuthenticate;

procedure TActivationSuccess.Button1Click(Sender: TObject);
begin
  splash.hide;
  Authenticate.hide;
  ActivationSuccess.hide;
  application.CreateForm(TMaster, master);
  master.showmodal;

end;

end.
